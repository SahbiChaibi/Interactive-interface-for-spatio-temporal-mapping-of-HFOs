/*
  1999-12-10
  2000-01-01/02/08
*/

#ifndef GABOR_FACTORY_H
#define GABOR_FACTORY_H

#include <iostream.h>
#include <math.h>
#include <stdlib.h>
#include <pthread.h>
#include "Vector.h"

#ifndef M_PI
#define M_PI    3.14159265358979323846
#endif

#ifndef M_SQRT2
#define M_SQRT2 1.41421356237309504880
#endif

struct GaborParameter {
  float freq;
  unsigned short position;
  unsigned short scale;
  float CNorm;    // Norma kosinusowa 
  float SNorm; 
  float Fc;	    // Iloczyn kosinusowy z sygnalem
  float Fs;	    // Iloczyn sinusowy z sygnalem 
  float phase;
  float modulus;
  int   next;
};

class MultiThreadLoop {
  int numOfThreads,Start,Stop;
  pthread_t *threads;
  GaborParameter *nextIter;

public:
  struct ThreadData {
    MultiThreadLoop *This;
    int              num;
    GaborParameter  *nextThreadIter;
  };

  MultiThreadLoop(int);
  virtual ~MultiThreadLoop();
  void loop(int,int);
  virtual void run(int,int) { ; }

  int getStart() const { return Start; }
  int getStop() const { return Stop; }
  int getNumOfThreads() const { return numOfThreads; }
  void setNextIter(GaborParameter *param) { nextIter=param; }
};

inline MultiThreadLoop::MultiThreadLoop(int num) {
  if(num>=16) {
    cerr << "Fatal error ! file: " << __FILE__  << endl;
    exit(EXIT_FAILURE);
  }
  numOfThreads=num;
  threads=new pthread_t[num];
  nextIter=0;
}

inline MultiThreadLoop::~MultiThreadLoop() {
  delete []threads;
}

const int SINUS=0,COSINUS=1,EXPONENT=2;

template<class T> inline double SQR(const T x) {
  return x*double(x);
}

class GaborFactory {
protected:
  double ConstScale;
  float *Data[3],*sig,*res;
  float SinNorm,CosNorm;
  int   N;

  void  MakeExpTable(float *,float,int,int,int);
  void  MakeExpTable(double *,double,double,int,int);
  void  MakeComplexTable(double *,double *,double *,double,double,int,int);
  void  MakeSinCosTable(float *,float *,int,int,float,int);
  void  MakeGaborCosFT(double *,double *,double *,int,int,int,double,
		       double,double);
  float getCosGabor(float *,int,int,float);
  float getSinGabor(float *,int,int,float);

public:
  GaborFactory(int);
  ~GaborFactory();
  void make(int);

  const float *getExp(const int);
  const float *getSin(const float);
  const float *getCos(const float);
  void  getGabor(float *,int,int,float,float);
  void  getFourier(float *,float,float);
  void  getDirac(float *,int);
  int   getAtomLength(int) const;
  float findGaborPhase(int,int,float,float *,float *,
		       float *,float *,float *); 
  float findGaborPhase(double *,double *,double *,float *,int,int,float,
		       float *,float *,float *,float *,float *);
  float findGaborPhase(double *,double *,double *,float *,int,int,float,
		       float *,float *,float *,float,float,int,int);
  void  getSinCos(float **,float **,float);
  void  setSignal(float *);
  void  shiftSig(int mode=1);
  void  DotGaborAtoms(double,double,int,int,int,float *,float *,double *,
		      double *);
  int   DotGaborAtoms(double,double,double,double,double,double,double,
		      double *,double *);
  void  MakeDotProduct(double *,double *,double *,int,double,double,
		       double,float *,double *,double *,int,int); 
  void  MakeDotProduct(double *,double *,double *,int,double,double,
		       double,float *,double *,double *,double *); 

  int getBaseSize() const { return N; }
};

inline int GaborFactory::getAtomLength(int scale) const {
  const  int len=int(ConstScale*scale);
  return len>=N ? N-1 : len;
}

inline const float *GaborFactory::getExp(const int scale) {
  MakeExpTable(Data[EXPONENT],float(M_PI/SQR(scale)),N+N/2,0,3*N-1);
  return Data[EXPONENT];
}

inline const float *GaborFactory::getSin(const float freq) {
  MakeSinCosTable(Data[SINUS],Data[COSINUS],0,3*N-1,freq,N+N/2);
  return Data[SINUS];
}

inline const float *GaborFactory::getCos(const float freq) {
  MakeSinCosTable(Data[SINUS],Data[COSINUS],0,3*N-1,freq,N+N/2);
  return Data[COSINUS];
}

inline void GaborFactory::getSinCos(float **Sin,float **Cos,float freq) {
  MakeSinCosTable(Data[SINUS],Data[COSINUS],0,3*N-1,freq,N+N/2);
  *Sin=Data[SINUS];
  *Cos=Data[COSINUS];
}

// --------------------------- ATOM ------------------------------------

const char DIRAC='D',FOURIER='F',GABOR='G';

class Atom {
public:
  float modulus,CNorm,SNorm,phase,freq;
  unsigned short position,scale,N;
  char  type;
  
  Atom(int n) : N(n) { modulus=0.0F; }
  Atom() { N=512; }

  friend ostream &operator<<(ostream &,const Atom &);
};

// ----------------------- DICTIONARY -------------------------------

const int OCTAVE=1,FULLSTOCH=2,VBOX=4;

class GaborDictionary {
  int          r250_index;             	      
  unsigned int r250_buffer[256];
  unsigned long seed;

  unsigned myrand();
  void r250_init(unsigned short);
  unsigned r250();
  unsigned r250n(unsigned n);
  double dr250(void);
  double frand(float,float);

protected:
  GaborParameter *gabors;
  int DicSize;
  int DicType,DicN;
  
  void reinit(unsigned short);
  void genDictionary(bool tryDic=false);
 
public:
  float DT,DF,DS;

  GaborDictionary(int,int);
  ~GaborDictionary();

  void make(int,int,int type=FULLSTOCH,int seed_=1);
  void setDicType(int);
  int  getDicType() const { return DicType; }
  int  getDicSize() const { return DicSize; }
};

inline GaborDictionary::GaborDictionary(int n,int size) {
  DT=0.01F; DS=0.1F; DF=0.01F;
  gabors=0;
  make(n,size);
}

inline GaborDictionary::~GaborDictionary() {
  delete []gabors;
}

// -------------------- MP NUMERIC ------------------------------------- 

const int ASCII=1,BINARY_FLOAT=2,BINARY_SHORT=3;
const int APPEND=1,NEWFILE=2;
const int MAX_THREADS=8;

class MatchingPursuit : public GaborDictionary, public GaborFactory {
  int    ifact[512];
  double LOG_EPSYLON;
  Atom   *atoms;
  float  epsylon;
  int    MaxIter;
  float  SamplingRate;
  float  ConvRate;
  float  AdaptiveConst;
  int    ChannelMaxNum;
  int    ChannelNumber;
  int    file_offset;
  int    TrueDim;
  int    startGabor;
  Vector<float> FFT;
  bool   eSearch;
  int    dTime;
  float  dFreq,dScale;

protected:
  int    DefaultIter;
  float  DefaultEps;

private:
  void findDirac(Atom *);
  void findFourier(Atom *);
  void findGabor(Atom *);
  void findGaborOneCPU(Atom *);
  void subAtom(const Atom &);
  void findTwoIterationGabor(Atom *,Atom *);
  void findTwoIterationGaborOneCPU(Atom *,Atom *);
  int  findCrossGabor(Atom *,GaborParameter *,float *,float *);
  void optimizeDictionary();
  void optimizeGabors(Atom *);
  void recalcParameter(Atom *);
  int  splitLoop;

  class FirstIteration : public MultiThreadLoop {
  protected:
    double *Re[MAX_THREADS],*Im[MAX_THREADS],*Exp[MAX_THREADS];
    float  *fft;
    Atom gab[MAX_THREADS];
    GaborParameter  *gabors;
    MatchingPursuit *parent;

  public:
    FirstIteration(int n,MatchingPursuit *p) : MultiThreadLoop(n) {
      parent=p;
      if(n>=MAX_THREADS) {
	cerr << "Za duzo watkow !";
	exit(EXIT_FAILURE);
      }
    }

    void setValue(const Atom &atom,GaborParameter *g,float *fft_,
		  double *Re_[MAX_THREADS],
		  double *Im_[MAX_THREADS],
		  double *Exp_[MAX_THREADS]) {

      const int size=getNumOfThreads();
      gabors=g;
      fft=fft_;
      for(int i=0 ; i<size ; i++) {
	Re[i]=Re_[i];
	Im[i]=Im_[i];
	Exp[i]=Exp_[i];
	gab[i]=atom;
      }
    }
    
    void setValue(const Atom &atom,GaborParameter *g) {
      const int size=getNumOfThreads();
      
      gabors=g;
      for(int i=0 ; i<size ; i++)
	gab[i]=atom;
    }
    
    void run(int,int);
    Atom synchronize();
  };

  class NextIteration : public FirstIteration {
    float *ExpTab[MAX_THREADS],*GaborTab[MAX_THREADS];
    double *Exp[MAX_THREADS],*Real[MAX_THREADS],*Imag[MAX_THREADS];
    float *fft;
    int start,stop,size;
    Atom  *oldAtom;

  public:
    NextIteration(int n,MatchingPursuit *p) :  FirstIteration(n,p) {
    }
    
    void setValue(const Atom &atom,GaborParameter *g,Atom *old,
		  float *ExpTablePtr[MAX_THREADS],
		  float *GaborTabPtr[MAX_THREADS],
		  double *ExpPtr[MAX_THREADS],
		  double *RealPtr[MAX_THREADS],
		  double *ImgPtr[MAX_THREADS],
		  float *fftPtr,
		  int start_,int stop_,int size_) {
      
      this->FirstIteration::setValue(atom,g);
      oldAtom=old;

      start=start_;
      stop=stop_;
      size=size_;
      fft=fftPtr;

      setNextIter(g);
      for(int i=0 ; i<MAX_THREADS ; i++) {
	ExpTab[i]=ExpTablePtr[i];
	GaborTab[i]=GaborTabPtr[i];
	Exp[i]=ExpPtr[i];
	Real[i]=RealPtr[i];
	Imag[i]=ImgPtr[i];
      }
    }
    
    void run(int,int);
  };

public:
  bool enableFFT(const GaborParameter *,int mode=1) const;
  bool enableFFT(float,float,int mode=1) const;

  void setNumOfThreads(int n) {
    if(n>=MAX_THREADS)
      splitLoop=MAX_THREADS-1;
    else
      splitLoop=n;
  }

public:
  int getNumOfThreads() const {
    return splitLoop;
  }

  void enableOptimizeGabor(bool val) {
    eSearch=val;
  }
  
  MatchingPursuit(int,int);
  ~MatchingPursuit() { if(atoms!=0) delete []atoms; }
  void  mp(int);
  bool  load(const char *,int,int,int,int,float samp=1.0F,float conv=1.0F,
	     int pos=0,int ref1=-1,int ref2=-1,int shift=0);

  bool makechannel(const char *,const char *,int,int,int,int,int,
		   float,float,int,int,int,int,int);

  bool  save(const char *,int);
  int   getDicSize() const { return DicSize+4*N; }
  float energy() const;
  float fullenergy() const;
  float signalEnergy() const;
  float findCrossGabor(Atom *,GaborParameter *,float *,float *,float *);
  void  setepsylon(float eps) { epsylon=eps; }
  float getEpsylon() const { return epsylon; }
  void  setAlpha(float alpha) { AdaptiveConst=alpha; }
  float getAlpha() const { return AdaptiveConst; }
  void  reset();
  void  norm();
  bool  saveSignal(const char *);

  int   getMaxIter() const  { return MaxIter; }
  float getSampling() const { return SamplingRate; }
  float getConvRate() const { return ConvRate; }
  int   getChannelMaxNum() const { return ChannelMaxNum; }
  int   getChannelNumber() const { return ChannelNumber; }
  bool  getESearch() const { return eSearch; }
  float getDTime() const { return DT*N; }
  float getDFreq() const { return 0.5F*DF*N; }
  float getDScale() const { return DS*N; }
  void  showInfo(ostream &) const;
};

// ------------------------- SHELL ----------------------------------

class Shell : public MatchingPursuit {
protected:
  istream &in;
  ostream &out;
  
public:
  Shell(int dimBase=512,int dicSize=70000,
	istream &str_in=cin,ostream &str_out=cout);
  ~Shell() { ; }
  int exec();
  int exec_command(const char *,const char *);

  bool loadsig(int,char **);
  bool mp     (int,char **);
  bool save   (int,char **);
  bool reinit (int,char **);
  bool savesignal(int,char **);
  bool border(int,char **);
  bool makeChannel(int,char **);
  void help();
  bool setMP(int,char **);
};

inline Shell::Shell(int dimBase,int dicSize,istream &str_in,
		    ostream &str_out) : MatchingPursuit(dimBase,dicSize),
					in(str_in), out(str_out) {   
}

#endif




