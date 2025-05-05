/* 1999 08 27/09 26/27 
   2000-01-01/02/08/10
   2000-02-15/19/20
   2000-03-11
   2000-04-16
   2000-09-28
   2000-10-18
   2000-11-26
   2001-03-08
   2001-03-20
*/

#include <iostream.h>
#include <fstream.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>
#ifndef WIN32
#include <unistd.h>
#include <sys/times.h>
#endif
#include "FileFormats.h"
#include "new_io.h"
#include "Vector.h"
#include "GaborFactory.h"

#ifdef WIN32
#include <windows.h>

inline int getNumberOfProcessors() {
  SYSTEM_INFO info;
  GetSystemInfo(&info);
  return int(info.dwNumberOfProcessors);
}

#endif

int debug=0,quiet=0;

#ifndef NO_DEBUG

void *operator new(size_t size) {
  void *ptr=malloc(size);
  //  cout << "alloc: " << size << " " << ptr << endl;
  return ptr;
}

void operator delete(void *ptr) {
  //  cout << "delete: " << ptr << endl;
  free(ptr);
}

#endif

inline double Clock() {
#ifdef LINUX
  struct tms buff;
  return 0.01*times(&buff);
#else
  return clock()/double(CLOCKS_PER_SEC);
#endif
}

static long FileSize(FILE *stream) {
  long curpos,length;

  curpos=ftell(stream);
  fseek(stream,0L,SEEK_END);
  length=ftell(stream);
  fseek(stream,curpos,SEEK_SET);
  return length;
}

static void getStartAndStop(float freq,int scale,
			    int *start,int *stop,int n) {
  if(scale==0) {
    *start=0;
    *stop=n-1;
    return;
  } else if(scale==n) {
    *start=int(n*freq/M_PI-10.0);
    *stop=*start+20; 
  } else {
    const double Const=1.05*(1.0+2.4*n/double(scale)),df=n/(2.0*M_PI);
    *start=int(df*freq-Const);
    *stop= int(df*freq+Const);
  }
  
  if(*start<0) *start=0;
  if(*stop>n)  *stop=n-1;
}

inline int setNewStartAndStop(int start,int stop,int *new_start,int *new_stop,
			      int scale,float freq,int n) {
  const double Const=1.0+2.4*n/double(scale),df=n/(2.0*M_PI);
  int a=int(df*freq-Const),b=int(df*freq+Const);

  if(a<0) a=0;
  if(b>n) b=n-1;
 
  if(b<=start || a>=stop) {
    *new_start=a;
    *new_stop=b;
    return 0;
  } else if(a>=start && b<=stop) {
    *new_start=a;
    *new_stop=b;
  } else if(a<=start && stop<=b) {
    *new_start=start;
    *new_stop=stop;
  } else if(a<=start && b<=stop) {
    *new_start=start;
    *new_stop=b;
  } else if(a<=stop && b>=stop) {
    *new_start=a;
    *new_stop=stop;
  } else {
    *new_start=a;
    *new_stop=b;
  }
  return 1;
}

/* 
   Description: implements R250 random number generator, from S.
   Kirkpatrick and E.  Stoll, Journal of Computational Physics,
   40, p. 517 (1981).
   Written by:    W. L. Maier. Adaptacja 1997 01 07 
*/

inline unsigned GaborDictionary::myrand(void) {
  seed=seed*0x015a4e35UL+1UL;
  return (unsigned)(seed>>16) & 0x7fffU;
}

void GaborDictionary::r250_init(unsigned short newseed) {
  unsigned int mask=0x8000U,msb=0xffffU;
  register int j,k;
  
  seed=(unsigned)(newseed);
  r250_index=0;
  for(j=0; j<250; j++)
    r250_buffer[j]=myrand();
  for(j=0; j<250; j++)
    if(myrand()>16384U)
      r250_buffer[j]|=0x8000U;
  for(j=0; j<16; j++) {
    k=11*j+3;
    r250_buffer[k]&=mask;
    r250_buffer[k]|=msb;
    mask>>=1;
    msb>>=1;
  }
}

unsigned int GaborDictionary::r250(void) {
  register int j;
  register unsigned int new_rand;
  
  if(r250_index>=147)
    j=r250_index-147;
  else
    j=r250_index+103;
  new_rand=r250_buffer[r250_index]^=r250_buffer[j];
  if(r250_index>=249)
    r250_index=0;
  else
    r250_index++;
  return new_rand;
}

/* returns a random unsigned integer k
   uniformly distributed in the interval 0 <= k < n */

unsigned int GaborDictionary::r250n(unsigned n) {
  register int j;
  register unsigned int new_rand,limit;
  
  limit=(65535U/n)*n;
  do
    {
      (void)r250();
      if(r250_index>=147)
	j=r250_index-147;
      else
	j=r250_index+103;
      
      new_rand=r250_buffer[r250_index]^=r250_buffer[j];
      
      if(r250_index>=249)
	r250_index=0;
      else
	r250_index++;
    } while(new_rand>=limit);
  return new_rand % n;
}

double GaborDictionary::dr250(void) { /* Return a number in [0.0 to 1.0) */ 
  register int    j;
  register unsigned int new_rand;

  if(r250_index>=147)
    j=r250_index-147;
  else
    j=r250_index+103;
  new_rand=r250_buffer[r250_index]^=r250_buffer[j];
  if(r250_index>=249)
    r250_index=0;
  else
    r250_index++;
  return new_rand/65536.0;
}

// ---------------------------------------------------------------------

static void *loopexec(void *ptr) {
  MultiThreadLoop::ThreadData *fptr=(MultiThreadLoop::ThreadData *)ptr;
  MultiThreadLoop *This=fptr->This;
  const int num=fptr->num,step=This->getNumOfThreads(),Stop=This->getStop() ;
  const GaborParameter *gabors=fptr->nextThreadIter;
  register int i;

  if(gabors==0) {
    This->run(num,This->getStart()+num);
    for(i=This->getStart()+num+step ; i<Stop ; i+=step)
      This->run(num,i);
  } else {
    for(i=This->getStart() ; i!=-1 ; i=gabors[i].next)
      if((i%step)==num)
	This->run(num,i);
  }

  pthread_exit(NULL);
  return NULL;
}

void MultiThreadLoop::loop(int start,int stop) {
  Start=start; 
  Stop=stop;

  int i;
  ThreadData *data=new ThreadData[numOfThreads];
  
  for(i=0 ; i<numOfThreads ; i++) {
    data[i].nextThreadIter=nextIter;
    data[i].This=this;
    data[i].num=i;
    
    if(pthread_create(&threads[i],NULL,loopexec,(void *)&data[i])!=0) {
      cerr << "Thread not work !";
      exit(EXIT_FAILURE);
    }
  }
  
  for(i=0 ; i<numOfThreads ; i++) 
    pthread_join(threads[i],NULL);
  delete []data;
}

#ifdef INLINE

inline double InlineSqrt(double __x) {
  register double __value;
        
  __asm__ __volatile__
	("fsqrt" : "=t" (__value): "0" (__x));

  return __value;
}

inline double InlineAtan2(double __y, double __x) {
  register double __value;
        
  __asm__ __volatile__
		("fpatan\n\t"
		 "fldl %%st(0)"
		 : "=t" (__value): "0" (__x), "u" (__y));

  return __value;
}

inline double InlineSin(double __x) {
  register double __value;
        
  __asm__ __volatile__
		("fsin" : "=t" (__value): "0" (__x));

  return __value;
}

inline double InlineCos(double __x) {
 register double __value;
        
 __asm__ __volatile__
		("fcos" : "=t" (__value): "0" (__x));

 return __value;
}

inline double InlineLog(double __x) {
	register double __value;
        
	__asm__ __volatile__
		("fldln2\n\t"
		 "fxch\n\t"
		 "fyl2x"
		 : "=t" (__value) : "0" (__x));

 	return __value;
}

inline double InlineFloor(double __x) {
  register double __value;
  volatile short __cw, __cwtmp;

  __asm__ volatile ("fnstcw %0" : "=m" (__cw) : );
  __cwtmp = (__cw & 0xf3ff) | 0x0400; /* rounding down */
  __asm__ volatile ("fldcw %0" : : "m" (__cwtmp));
  __asm__ volatile ("frndint" : "=t" (__value) : "0" (__x));
  __asm__ volatile ("fldcw %0" : : "m" (__cw));
  return __value;
}

inline void sincos(double __x, double *__sinx, double *__cosx) {
  register double __cosr,__sinr;
  
  __asm__ __volatile__
    ("fsincos": "=t" (__cosr), "=u" (__sinr) : "0" (__x));
  *__sinx=__sinr; *__cosx=__cosr;
}

#define atan2(X,Y) InlineAtan2((X),(Y))
#define sin(X)     InlineSin(X)
#define cos(X)     InlineCos(X)
#define sqrt(X)    InlineSqrt(X)
#define log(X)     InlineLog(X)
#define floor(X)   InlineFloor(X)
#else
#define sincos(x,Sin,Cos) { *(Sin)=sin(x); *(Cos)=cos(x); }
#endif

extern "C" void __ogg_fdrffti(int,float *,int *);
extern "C" void __ogg_fdrfftf(int,float *,float *,int *);
//extern "C" void __ogg_fdrfftb(int,float *,float *,int *);

#define EPSYLON 1.0e-8

// ---------------------- GABOR FACTORY ----------------------------

void GaborFactory::setSignal(float s[]) {
  const int size=3*N;
  register int i;
  
  for(i=0 ; i<size ; i++)
    res[i]=sig[i]=s[i];
}

void GaborFactory::shiftSig(int mode) {
  register int i,itmp;
  switch(mode) {
  case 1:
    for(i=0 ; i<N ; i++) {
      res[i]=sig[i]=res[N+i];
      itmp=2*N+i;
      sig[N+i]=res[N+i]=res[itmp];
      res[itmp]=sig[itmp]=0.0F;
    }
    break;
  case 2:
    for(i=0 ; i<N ; i++) {
      itmp=2*N+i;
      res[i]=sig[i]=res[itmp]=sig[itmp]=res[N+i];
    }
    break;
  }
}

void GaborFactory::make(int n) {
  if(res!=0) {
    delete []res;
  }

  int i;
  if(sig!=0) {
    delete []sig;
  }

  for(i=0 ; i<3 ; i++)
    if(Data[i]!=0)
      delete []Data[i];

  N=n;
  ConstScale=sqrt(log(1.0/EPSYLON)/M_PI);
  const int size=3*N;

  Data[SINUS]=   new float[size];
  Data[COSINUS]= new float[size];
  Data[EXPONENT]=new float[size];

  sig=new float[size];
  res=new float[size];
  for(i=0 ; i<size ; i++)
    sig[i]=res[i]=0.0F;
}

GaborFactory::GaborFactory(int n) {
  for(int i=0 ; i<3 ; i++)
    Data[i]=0;
  sig=res=0;

  make(n);
  N=512;
}

GaborFactory::~GaborFactory() {
  for(int i=0 ; i<3 ; i++) 
    delete []Data[i];
  
  delete []sig;
  delete []res;
}

void GaborFactory::MakeExpTable(double ExpTab[],double alpha,double real_trans,
				int start,int stop) {
  double RightOldExp,LeftOldExp,LeftFactor,RightFactor;
  const int trans=int(real_trans);
  const double ConstStep=exp(-2.0*alpha);
  register int left,right;	  	

  if(start<trans && trans<stop) {   
    const double dtmp1=real_trans-trans,dtmp2=trans+1-real_trans;

    LeftFactor= exp(-alpha*(1.0+2.0*dtmp1));
    LeftOldExp= ExpTab[trans]=exp(-alpha*dtmp1*dtmp1);

    RightOldExp=ExpTab[trans+1]=exp(-alpha*dtmp2*dtmp2);
    RightFactor=exp(-alpha*(1.0+2.0*dtmp2));
 
    for(left=trans-1,right=trans+2; 
	start<=left && right<=stop; left--,right++) {
      *(ExpTab+left)=(LeftOldExp*=LeftFactor);
      *(ExpTab+right)=(RightOldExp*=RightFactor);
      LeftFactor*=ConstStep;
      RightFactor*=ConstStep;
    }  
	
    if(left>=start) {	 
      for( ; start<=left ; left--) {
	*(ExpTab+left)=(LeftOldExp*=LeftFactor);
	LeftFactor*=ConstStep;
      } 
    } else {
      for( ; right<=stop; right++) {
	*(ExpTab+right)=(RightOldExp*=RightFactor);
	RightFactor*=ConstStep;
      }
    }
  } else if(trans>=stop) {
    const double dtmp=real_trans-stop;

    LeftFactor=exp(-alpha*(1.0+2.0*dtmp));
    LeftOldExp=ExpTab[stop]=exp(-alpha*dtmp*dtmp);

    for(left=stop-1; start<=left ; left--) {
      *(ExpTab+left)=(LeftOldExp*=LeftFactor);
      LeftFactor*=ConstStep;
    }
  } else {
    const double dtmp=start-real_trans;

    RightFactor=exp(-alpha*(1.0+2.0*dtmp));
    RightOldExp=ExpTab[start]=exp(-alpha*dtmp*dtmp);

    for(right=start+1; right<=stop ; right++) {
      *(ExpTab+right)=(RightOldExp*=RightFactor);
      RightFactor*=ConstStep;
    }
  }
}  

void GaborFactory::MakeExpTable(float ExpTab[],float alpha,int trans,
				int start,int stop) {
  register int left,right,itmp;	  	 
  double Factor,OldExp,ConstStep;
   
  if(start<trans && trans<stop) {                            	  
    ExpTab[trans]=1.0F; 
    OldExp=1.0;
    Factor=exp(-alpha);
    ConstStep=SQR(Factor);     	
    
    for(left=trans-1,right=trans+1 ; 
	start<=left && right<=stop ; 
	left--,right++) {
      OldExp*=Factor;
      ExpTab[left]=ExpTab[right]=float(OldExp);
      Factor*=ConstStep;
    }  
	
    if(left>=start) {	 
      for( ; start<=left ; left--) {
	ExpTab[left]=float(OldExp*=Factor);
	Factor*=ConstStep;
      } 
    } else {
      for( ; right<=stop; right++) {
	ExpTab[right]=float(OldExp*=Factor);
	Factor*=ConstStep;
      }
    }
    return;      
  } 
   
  ConstStep=exp(-2.0*alpha);
  if(trans>=stop) {
    itmp=trans-stop;	    
    ExpTab[stop]=float(OldExp=exp(-alpha*SQR(itmp)));
    Factor=exp(-alpha*(double)((itmp << 1)+1));
    
    for(left=stop-1; start<=left ; left--) {
      ExpTab[left]=float(OldExp*=Factor);
      Factor*=ConstStep;
    }
  } else {       	
    itmp=start-trans;  
    ExpTab[start]=float(OldExp=exp(-alpha*SQR(itmp)));
    Factor=exp(-alpha*(double)((itmp << 1)+1));
    
    for(right=start+1; right<=stop ; right++) {
      ExpTab[right]=float(OldExp*=Factor);
      Factor*=ConstStep;
    }
  }   
}  

void GaborFactory::MakeComplexTable(double ReTable[],double ImTable[],
				    double Exp[],double Factor,
				    double freq,int start,int stop) {
  double NewCos,Sin,Cos,OldSin,OldCos,dtmp;
  register int i;    

  sincos(freq,&Sin,&Cos);
  sincos(freq*start,&OldSin,&OldCos);
  
  dtmp=Exp[start]*Factor;
  ReTable[start]=OldCos;
  ImTable[start]=OldSin;
  for(i=start+1 ; i<=stop ; i++) {                                   	
    NewCos=OldCos*Cos-OldSin*Sin;
    dtmp=Exp[i]*Factor;
    ImTable[i]=-dtmp*(OldSin=OldCos*Sin+OldSin*Cos);
    ReTable[i]=dtmp*(OldCos=NewCos);
  }
}
    
void GaborFactory::MakeSinCosTable(float *SinTable,float *CosTable,
				   int start,int stop,float freq,int trans) {
  double NewCos,Sin,Cos,OldSin,OldCos;
  register int i;    

  sincos(freq,&Sin,&Cos);
  sincos(freq*(double)(start-trans),&OldSin,&OldCos);
  
  SinTable[start]=float(OldSin);
  CosTable[start]=float(OldCos);
  
  for(i=start+1 ; i<=stop ; i++) {                                   	
    NewCos=OldCos*Cos-OldSin*Sin;
    SinTable[i]=float(OldSin=OldCos*Sin+OldSin*Cos);
    CosTable[i]=float(OldCos=NewCos);
  }
}

float GaborFactory::getSinGabor(float *gabor,int scale,int trans,float freq) {
  const float *Exp=getExp(scale),*Sin=getSin(freq);
  double sum=0.0;
  register int i,k;
  const int size=3*N;

  for(i=0,k=trans-N/2 ; i<size ; i++,k++) 
    if(k>=0 && k<size) 
      sum+=SQR(gabor[k]=float(Exp[i]*Sin[i]));

  for(i=0 ; i<trans-N/2 ; i++)
    gabor[i]=0.0F;
  for(i=k ; i<size ; i++)
    gabor[i]=0.0F;
  return float(sum);
}

float GaborFactory::getCosGabor(float *gabor,int scale,int trans,float freq) {
  const  float *Exp=getExp(scale),*Cos=getCos(freq);
  double sum=0.0;
  register int i,k;
  const int size=3*N;

  for(i=0,k=trans-N/2 ; i<size ; i++,k++) 
    if(k>=0 && k<size) 
      sum+=SQR(gabor[k]=float(Exp[i]*Cos[i]));

  for(i=0 ; i<trans-N/2 ; i++)
    gabor[i]=0.0F;
  for(i=k ; i<size ; i++)
    gabor[i]=0.0F;
  return float(sum);
}

void GaborFactory::getGabor(float *gabor,int scale,int trans,float freq,
			    float phase) { 
  const float *Exp=getExp(scale);
  float *Sin,*Cos;
  double w1,w2,sum=0.0;
  register int i,k;
  const int size=3*N;

  phase+=float(0.5*M_PI);
  getSinCos(&Sin,&Cos,freq);
  sincos(phase,&w2,&w1);

  for(i=0,k=trans-N/2 ; i<size ; i++,k++) 
    if(k>=0 && k<size) 
      sum+=SQR(gabor[k]=float(Exp[i]*(w1*Sin[i]+w2*Cos[i])));
  
  const float s=float(1.0/sqrt(sum));

  for(i=0,k=trans-N/2 ; i<size ; i++,k++)
    if(k>=0 && k<size)
      gabor[k]*=s;
  
  for(i=0 ; i<trans-N/2 ; i++)
    gabor[i]=0.0F;
  for(i=k ; i<size ; i++)
    gabor[i]=0.0F;
}

void GaborFactory::getFourier(float *fourier,float freq,float phase) {
  const float *Sin=getSin(freq),*Cos=getCos(freq);
  const int size=3*N;
  double w1,w2,sum=0.0;
  register int i;

  sincos(phase,&w1,&w2);
  for(i=0 ; i<size ; i++) 
    sum+=SQR(fourier[i]=float(w1*Cos[i]+w2*Sin[i]));
 
  const float s=float(1.0/sqrt(sum));
  for(i=0 ; i<size ; i++)
    fourier[i]*=s;
}

void GaborFactory::getDirac(float *dirac,int trans) {
  for(register int i=N ; i<2*N ; i++)
    dirac[i]=0.0F;
  dirac[trans]=1.0F;
}

float GaborFactory::findGaborPhase(int scale,int trans,float freq,
				   float *phase,
				   float *pFs,float *pFc,float *pCNorm,
				   float *pSNorm) {
  const double alpha=M_PI/SQR(scale);
  const double ConstExp=exp(-alpha),ConstStep=SQR(ConstExp);
  double OldSin=0.0,OldCos=1.0,NewCos,OldExp=1.0;
  double Factor=ConstExp,Kc=0.0,Ks=0.0,Fs=0.0,Fc=*(res+N+trans);
  register float *f=res+N+trans;
  register double dtmp,dtmp2;
  double Sin,Cos;
  register int i,n=getAtomLength(scale); 

  sincos(freq,&Sin,&Cos);
  for(i=1 ; i<n ; i++) {
    NewCos=OldCos*Cos-OldSin*Sin;
    OldSin=OldCos*Sin+OldSin*Cos;
    OldExp*=Factor;
    dtmp=OldExp*NewCos;
    dtmp2=OldExp*OldSin;
    Kc+=SQR(dtmp);
    Ks+=SQR(dtmp2);
    Fc+=dtmp*(*(f+i)+*(f-i));
    Fs+=dtmp2*(*(f+i)-*(f-i));
    Factor*=ConstStep;
    OldCos=NewCos;
  }    
  
  Kc=2.0*Kc+1.0;
  Ks*=2.0;

  if(fabs(Fs)<1.0e-10 && fabs(Fc)<1.0e-10)
    *phase=0.0F;
  else
    *phase=float(atan2(-Fs/Ks,Fc/Kc));

  *pFs=float(Fs);
  *pFc=float(Fc);
  *pCNorm=float(Kc);
  *pSNorm=float(Ks);
  
  sincos(*phase,&OldSin,&OldCos);
  return float(SQR(Fc*OldCos-Fs*OldSin)/(Kc*SQR(OldCos)+Ks*SQR(OldSin)));
}

float GaborFactory::findGaborPhase(double ReTable[],double ImTable[],
				   double ExpTab[],float FFT[],
				   int scale,int trans,float freq,
				   float *phase,float *pFs,float *pFc,
				   float *pCNorm,float *pSNorm) {
  double Fc,Fs,Kc,OldSin,OldCos;
 
  MakeDotProduct(ReTable,ImTable,ExpTab,3*N,scale,freq,N+trans,
		 FFT,&Fc,&Fs,&Kc);

  if(fabs(Fs)<1.0e-10 && fabs(Fc)<1.0e-10)
    *phase=0.0F;
  else
    *phase=(float)atan2(-Fs/Kc,Fc/Kc);

  *pFs=(float)Fs;
  *pFc=(float)Fc;
  *pCNorm=(float)Kc;
  *pSNorm=(float)Kc;  

  sincos(*phase,&OldSin,&OldCos);
  return float(SQR(Fc*OldCos-Fs*OldSin)/Kc);
}

float GaborFactory::findGaborPhase(double ReTable[],double ImTable[],
				   double ExpTab[],float FFT[],
				   int scale,int trans,float freq,
				   float *phase,float *pFs,float *pFc,
				   float Kc,float Ks,int start,int stop) {
  double Fc,Fs,OldSin,OldCos;
 
  MakeDotProduct(ReTable,ImTable,ExpTab,3*N,scale,freq,N+trans,
		 FFT,&Fc,&Fs,start,stop);
  
  *pFs-=float(Fs);
  *pFc-=float(Fc);

  if(fabs(*pFs)<1.0e-10 && fabs(*pFc)<1.0e-10)
    *phase=0.0F;
  else
    *phase=(float)atan2(-(*pFs)/Ks,*pFc/Kc);
 
  sincos(*phase,&OldSin,&OldCos);
  return float(SQR(*pFc*OldCos-(*pFs)*OldSin)/(Kc*SQR(OldCos)+Ks*SQR(OldSin)));
}

static double NormGabor(int n,double alpha,double freq,double phase) {
  register int i;	
  const double Sin=sin(freq),Cos=cos(freq),CosPhase=cos(phase),
               SinPhase=sin(phase),ConstExp=exp(-alpha),
               ConstStep=SQR(ConstExp);
  double OldSin=0.0,OldCos=1.0,NewCos,dtmp,dtmp2,
         OldExp=1.0,Factor=ConstExp,sum=SQR(CosPhase);

  for(i=0 ; i<n ; i++) {
    NewCos=OldCos*Cos-OldSin*Sin;		
    OldSin=OldCos*Sin+OldSin*Cos;
    OldCos=NewCos;
    OldExp*=Factor;				
    Factor*=ConstStep;
    dtmp=OldExp*CosPhase*NewCos;
    dtmp2=OldExp*SinPhase*OldSin;
    sum+=SQR(dtmp-dtmp2)+SQR(dtmp+dtmp2);   
  }
  return 1.0/sqrt(sum);		
}

static double makeExpAmplitude(int N,double scale) {
  const double EPS=1.0e-8;
  register int i;
  double sum=0.0;
  
  for(i=0 ; i<N ; i++) {
    const double ds=SQR(exp(-M_PI*SQR(i/scale)));
    if(ds<=EPS) 
      break;
    sum+=ds;
  }

  return sum>=1.0e-8 ? 1.0/sqrt(2.0*sum) : 1.0e4;
}

static double makeCosAmplitude(int N,double freq,double phase) {
  register int i;
  double sum=0.0;

  for(i=-N/2+1 ; i<N/2 ; i++)
    sum+=SQR(cos(freq*i+phase));
  return sum>=1.0e-8 ? 1.0/sqrt(sum) : 1.0e4;
}

static double makeAmplitude(int DimBase,double freq,double scale,
			    double phase) {
  const double EPS=1.0e-6;
  const double CONSTEPS=2.965674828188878;
  const int halfsignal=DimBase/2;
  int frequency=(int)(freq*DimBase/M_PI),width;
  
  if(scale==0.0)
    return 1.0;
  if((fabs(DimBase-scale)<EPS && fabs(frequency)<EPS) || 
     fabs(frequency-halfsignal)<EPS)
    return 1.0/DimBase;      	 
  if(fabs(frequency)<EPS || fabs(frequency-halfsignal)<EPS)
    return makeExpAmplitude(DimBase,scale);
  if(fabs(DimBase-scale)<EPS)		            
    return makeCosAmplitude(DimBase,freq,phase);

  width=(int)(scale*CONSTEPS);
  if(width>halfsignal)
    width=halfsignal; 
  
  return NormGabor(width,M_PI/SQR(scale),freq,phase);
}

inline int GaborFactory::DotGaborAtoms(double s1,double t1,double w1,
				       double phase,
				       double s2,double t2,double w2,
				       double *Fs,double *Fc) {
  double Sin1,Cos1,Sin2,Cos2;
  const double ss1=s1*s1,
               ss2=s2*s2,
               dtmp=ss1*ss2,
               a=(ss1+ss2)/dtmp;
  
  if(s1<60.0 || s1>(0.7*N) || s2<60.0 || s2>(0.7*N))   // do poprawy
    return -1;
  
  const double b=-2.0*(t1*ss2+t2*ss1)/dtmp,
               c=(ss2*t1*t1+ss1*t2*t2)/dtmp,
               Yw=-0.25*(b*b-4.0*a*c)/a,
               Tw=-0.5*b/a,
               dtmp1=w1*Tw-w1*t1+phase,
               dtmp2=w2*(Tw-t2),
               phase1=dtmp1-dtmp2,
               phase2=dtmp1+dtmp2,
               K=0.5*exp(-M_PI*Yw)/sqrt(a),
               dtmp3=-1.0/(4.0*M_PI*a),
               C1=K*exp(SQR(w1-w2)*dtmp3),
               C2=K*exp(SQR(w1+w2)*dtmp3);

  sincos(phase1,&Sin1,&Cos1);
  sincos(phase2,&Sin2,&Cos2);
  *Fc=C1*Cos1+C2*Cos2;
  *Fs=C2*Sin2-C1*Sin1; 
  return 0;
}

void GaborFactory::DotGaborAtoms(double alpha,double freq,int trans,
				 int start,
				 int stop,float *GaborTab,
				 float *ExpTab,double *DotSin,
				 double *DotCos) {
  double NewCos,dtmp,sum1,sum2,Sin,Cos,OldSin,OldCos;
  register int i;    

  sincos(freq,&Sin,&Cos);
  MakeExpTable(ExpTab,float(alpha),trans,start,stop);
  
  sincos(freq*(double)(start-trans),&OldSin,&OldCos);
  dtmp=*(ExpTab+start)**(GaborTab+start);
  sum1=dtmp*OldSin;
  sum2=dtmp*OldCos;
   
  for(i=start+1 ; i<=stop ; i++) {                                   	
    NewCos=OldCos*Cos-OldSin*Sin;
    OldSin=OldCos*Sin+OldSin*Cos;
    OldCos=NewCos;
    dtmp=*(ExpTab+i)**(GaborTab+i);
    sum1+=dtmp*OldSin;
    sum2+=dtmp*OldCos;
  }
  
  *DotSin=sum1;
  *DotCos=sum2;  
}

inline void GaborFactory::MakeGaborCosFT(double ReTable[],double ImTable[],
					 double ExpTab[],
					 int start,int stop,int N,
					 double scale,double omega,
					 double position) {
  const double df=2.0*M_PI/N;
  MakeExpTable(ExpTab,0.0795774715459477*SQR(df*scale), // /(4.0*M_PI)
	       omega/df,start,stop);
  MakeComplexTable(ReTable,ImTable,ExpTab,0.5*scale,
		   df*position,start,stop);
}

void GaborFactory::MakeDotProduct(double ReTable[],double ImTable[],
				  double ExpTab[],
				  int N,double scale,double omega,
				  double position,float FFT[],
				  double *Fc,double *Fs,double *Fn) {
  const double Const=1.0+2.4*N/scale,df=N/(2.0*M_PI),C=2.0/N;
  double Real=0.0,Imag=0.0,Re1,Im1,Re2,Im2,Norm=0.0;
  register int start,stop,i;

  start=int(df*omega-Const);
  if(start<0) start=0;
  stop=int(df*omega+Const);
  if(stop>N)  stop=N-2;

  MakeGaborCosFT(ReTable,ImTable,ExpTab,start,stop,N,scale,omega,position); 
  for(i=start ; i<stop ; i++) {
    Re1= FFT[2*i+1];
    Im1=-FFT[2*i+2];
    Re2= ReTable[i+1];
    Im2= ImTable[i+1];

    Real+=Re1*Re2-Im1*Im2;
    Imag+=Im1*Re2+Im2*Re1;

    Norm+=Re2*Re2+Im2*Im2;
  }

  *Fc=Real*C;  
  *Fs=Imag*C; 
  *Fn=Norm*C;
}

void GaborFactory::MakeDotProduct(double ReTable[],double ImTable[],
				  double ExpTab[],
				  int N,double scale,double omega,
				  double position,float FFT[],
				  double *Fc,double *Fs,int start,int stop) {
  const double C=2.0/N;;
  double Real=0.0,Imag=0.0,Re1,Im1,Re2,Im2;
  register int i;

  MakeGaborCosFT(ReTable,ImTable,ExpTab,start,stop,N,scale,omega,position); 
  for(i=start ; i<stop ; i++) {
    Re1= FFT[2*i+1];
    Im1=-FFT[2*i+2];
    Re2= ReTable[i+1];
    Im2= ImTable[i+1];

    Real+=Re1*Re2-Im1*Im2;
    Imag+=Im1*Re2+Im2*Re1;
  }

  *Fc=Real*C; 
  *Fs=Imag*C; 
}

// ------------------------------------------------------------------------

ostream &operator<<(ostream &str,const Atom &gab) {
  str << gab.modulus << " " << gab.scale << " "
      << gab.position << " " << gab.freq
      << " " <<  gab.phase;
  return str;
}

// ------------------------ DICTIONARY -------------------------

void GaborDictionary::make(int n,int size,int type,int seed_) {
  DicN=n;
  DicSize=size;
  DicType=type;  	      
  
  if(gabors!=0) {
    delete []gabors;
    gabors=0;
  }

  if(type!=VBOX)
    gabors=new GaborParameter[DicSize];

  reinit((unsigned short)seed_);
  
  if(!quiet) {
    cout.precision(4);
    cout << "Dictionary size: " 
	 << (sizeof(GaborParameter)*DicSize)/SQR(1024.0) << " MB\n";
    cout.precision(6);
  }
}

inline double GaborDictionary::frand(float a,float b) {
  return a+(b-a)*dr250();
}

void GaborDictionary::genDictionary(bool trySize) {
  const float EPS=1.0e-6F;
  float FreqStep=float(M_PI*DF),freq;
  int   TimeStep=int(DT*DicN);
  int   ScaleStep=int(DS*DicN),scale,tim,k=0;

// cout<<"F"<< FreqStep<<endl;
// cout<<"T"<< TimeStep<<endl;
// cout<<"S"<<   ScaleStep<<endl;



  if(FreqStep<=0.0F) 
    FreqStep=float(0.01*M_PI);
  if(TimeStep<=0)
    TimeStep=1;
  if(ScaleStep<=0)
    ScaleStep=1;

  int locDicSize=0;
  for(scale=1 ; scale<DicN-ScaleStep ; scale+=ScaleStep)
    for(freq=EPS ; freq<(1.0F-EPS)*M_PI-FreqStep ; freq+=FreqStep)
      for(tim=0 ; tim<DicN-TimeStep ; tim+=TimeStep)
	locDicSize++;
    
  //if(!quiet) {
//    cout << "Stochastic Boxed Dictionary size: " << locDicSize << " atoms\n";
    /*  if(trySize)
      cout << "Estimated dictionary size       : " 
	   << (sizeof(GaborParameter)*locDicSize)/SQR(1024.0) << " MB\n";
    */
//}
  
  if(trySize)
    return;

  DicSize=locDicSize;
  if(gabors!=0)
    delete []gabors;
  gabors=new GaborParameter[DicSize];

  for(scale=1 ; scale<DicN-ScaleStep ; scale+=ScaleStep) {
    int maxScale=scale+ScaleStep;
    if(maxScale>=DicN)
      maxScale=DicN-1;
    for(freq=EPS ; freq<(1.0F-EPS)*M_PI-FreqStep ; freq+=FreqStep) {
      float maxFreq=freq+FreqStep;
      if(maxFreq>=M_PI)
	maxFreq=float(M_PI-EPS);
      for(tim=0 ; tim<DicN-TimeStep ; tim+=TimeStep) {
	int maxTim=tim+TimeStep;
	if(maxTim>=DicN)
	  maxTim=DicN-1;

	gabors[k].scale=(unsigned short)(frand(float(scale),float(maxScale)));
	gabors[k].position=(unsigned short)(frand(float(tim),float(maxTim)));
	gabors[k].freq=float(frand(freq,maxFreq));
	k++;
      }
    }
  }

  if(!quiet)
    cout << "Done.\n";
}
 
void GaborDictionary::reinit(unsigned short seed_) {
  r250_index=0; 
  seed=seed_;
  r250_init((unsigned short)seed);

  if(DicType==VBOX) {
    genDictionary();
    return;
  }

  const double eps=1.0e-6;
  int max=int(0.5+log(DicN)/log(2.0)),i;

  for(i=0 ; i<DicSize ; i++) {
    gabors[i].freq=float(eps+(1.0-eps)*M_PI*dr250());
    gabors[i].position=r250n(DicN);
    if(DicType==OCTAVE)
      gabors[i].scale=1<<r250n(max);
    else
      gabors[i].scale=1+r250n(DicN-1);
  }
}
 
void GaborDictionary::setDicType(int type) {
  const int max=int(0.5+log(DicN)/log(2.0));
  const double eps=1.0e-6;

  DicType=type;
  if(type==VBOX) {
    genDictionary();
  } else {
    for(int i=0 ; i<DicSize ; i++) {
      gabors[i].freq=float(eps+(1.0-eps)*M_PI*dr250());
      gabors[i].position=r250n(DicN);
      if(DicType==OCTAVE)
	gabors[i].scale=1<<r250n(max);
      else
	gabors[i].scale=1+r250n(DicN-1);
    }
  }
}

// ------------------------- MP NUMERIC ------------------------

inline bool MatchingPursuit::enableFFT(float scale,float freq,int mode) const {
  switch(mode) {
  case 1: 
    if(freq<0.15 || freq>=2.8)
      return false;
    return (scale>95) && (scale<0.9*N);
  case 2:
    if(freq<0.15 || freq>=2.8)
      return false;
    return (scale>100) && (scale<0.9*N);
  }
  return false;
}

inline bool MatchingPursuit::enableFFT(const GaborParameter *gab,
				       int mode) const {
  switch(mode) {
  case 1: 
    if(gab->freq<0.2 || gab->freq>2.5)
      return false;
    return (gab->scale>95) && (gab->scale<0.7*N);
  case 2:
    if(gab->freq<0.2 || gab->freq>2.5)
      return false;
    return (gab->scale>100) && (gab->scale<0.7*N);
  }
  return false;
}

void MatchingPursuit::FirstIteration::run(int thread,int ii) {
  gab[thread].type=GABOR;
  if(parent->enableFFT(&gabors[ii])) {
    gabors[ii].modulus=parent->findGaborPhase(Re[thread],
					      Im[thread],
					      Exp[thread],
					      fft,
					      gabors[ii].scale,
					      gabors[ii].position,
					      gabors[ii].freq,
					      &gabors[ii].phase,
					      &gabors[ii].Fs,
					      &gabors[ii].Fc,
					      &gabors[ii].CNorm,
					      &gabors[ii].SNorm);
  } else {  
    gabors[ii].modulus=parent->findGaborPhase(gabors[ii].scale,
					      gabors[ii].position,
					      gabors[ii].freq,
					      &gabors[ii].phase,
					      &gabors[ii].Fs,
					      &gabors[ii].Fc,
					      &gabors[ii].CNorm,
					      &gabors[ii].SNorm);
  }

  if(gabors[ii].modulus>gab[thread].modulus) {
    gab[thread].modulus=gabors[ii].modulus;
    gab[thread].scale=gabors[ii].scale;
    gab[thread].position=gabors[ii].position;
    gab[thread].phase=gabors[ii].phase;
    gab[thread].freq=gabors[ii].freq;
    gab[thread].SNorm=gabors[ii].SNorm;
    gab[thread].CNorm=gabors[ii].CNorm;
  }
}

void MatchingPursuit::NextIteration::run(int thread,int ii) {
  gab[thread].type=GABOR;
  if(parent->enableFFT(&gabors[ii],2)) {
    int new_start,new_stop;
	
    if(setNewStartAndStop(start,stop,&new_start,&new_stop,
			  gabors[ii].scale,gabors[ii].freq,size)) {
      gabors[ii].modulus=parent->findGaborPhase(Real[thread],
						Imag[thread],
						Exp[thread],
						fft,
						gabors[ii].scale,
						gabors[ii].position,
						gabors[ii].freq,
						&gabors[ii].phase,
						&gabors[ii].Fs,
						&gabors[ii].Fc,
						gabors[ii].CNorm,
						gabors[ii].SNorm,
						new_start,
						new_stop);
      
    } 
  } else {
    gabors[ii].modulus=parent->findCrossGabor(oldAtom,
					      &gabors[ii],
					      GaborTab[thread],
					      ExpTab[thread],
					      &gabors[ii].phase);
  }
  
  if(gabors[ii].modulus>gab[thread].modulus) {
    gab[thread].modulus=gabors[ii].modulus;
    gab[thread].scale=gabors[ii].scale;
    gab[thread].position=gabors[ii].position;
    gab[thread].phase=gabors[ii].phase;
    gab[thread].freq=gabors[ii].freq;
    gab[thread].SNorm=gabors[ii].SNorm;
    gab[thread].CNorm=gabors[ii].CNorm;
  }
}

Atom MatchingPursuit::FirstIteration::synchronize() {
  const int size=getNumOfThreads();
  Atom gabor=gab[0];

  for(int i=1 ; i<size ; i++)
    if(gabor.modulus<gab[i].modulus)
      gabor=gab[i];

  gabor.modulus=float(sqrt(gabor.modulus));
  return gabor;
}

MatchingPursuit::MatchingPursuit(int n,int Size) 
  : GaborDictionary(n,Size),GaborFactory(n) {
  LOG_EPSYLON=log(EPSYLON);
  atoms=0;
  DicType=FULLSTOCH;
  splitLoop=1;
  AdaptiveConst=0.7F;
  startGabor=-1;
  eSearch=true;
  dFreq=dScale=5.0F;
  dTime=5;
  MaxIter=DefaultIter=64; 
  epsylon=DefaultEps=95.0;
  SamplingRate=1.0F;
  ConvRate=1.0F;
  ChannelMaxNum=1;
  ChannelNumber=0;

  char *value;
  if((value=getenv("NPROC"))!=NULL) {
    splitLoop=atoi(value);
  } else {
    splitLoop=1;
#ifdef LINUX
    splitLoop=int(sysconf(_SC_NPROCESSORS_ONLN));
#endif

#ifdef WIN32
    splitLoop=getNumberOfProcessors();
#endif
  }

  if(splitLoop<=0)
    splitLoop=1;
  else if(splitLoop>MAX_THREADS)
    splitLoop=MAX_THREADS;

  if(!quiet)
    cout << splitLoop << " CPU's detected\n";
}

void MatchingPursuit::findDirac(Atom *maxAtom) {
  register int i;
  float maxModulus=0.0F,ftmp;
  Atom gab(N);

  gab.type=DIRAC;
  gab.freq=(3.0F*N)/4.0F;
  gab.scale=0;

  for(i=N ; i<2*N ; i++) {
    ftmp=float(SQR(res[i]));
    if(ftmp>maxModulus) {
      maxModulus=ftmp;
      gab.modulus=ftmp;
      gab.phase=float(res[i]<0.0 ? M_PI : 0.0F);
      gab.position=i;
    }
  }

#ifndef NO_DEBUG
  if(!quiet) {
    cout << "Max Dirac  : " << sqrt(gab.modulus) << endl;
  }
#endif  

  gab.modulus=float(sqrt(gab.modulus));
  if(maxAtom->modulus>gab.modulus) 
    (*maxAtom)=gab;
}

void MatchingPursuit::findFourier(Atom *maxAtom) {
  const int size=3*N;
  float *resfft=new float[2*size],*w=new float[2*size+16];
  float maxModulus=0.0F,ftmp,Const=4.0F/size;
  register int i;
  Atom gab(N);
  
  gab.type=FOURIER;
  gab.position=N/2;
  gab.scale=N;

  for(i=0 ; i<size ; i++)
    resfft[i]=res[i];

  __ogg_fdrffti(size,w,ifact);
  __ogg_fdrfftf(size,resfft,w,ifact);

  for(i=1 ; i<size ; i+=2) {
    ftmp=float((SQR(resfft[i])+SQR(resfft[i+1]))*Const);
    if(ftmp>maxModulus) {
      maxModulus=ftmp;
      gab.modulus=ftmp;
      gab.phase=float(atan2(resfft[i],resfft[i+1]));
      gab.freq=float((2.0*M_PI*i)/size);
    }
  }

#ifndef NO_DEBUG
  if(!quiet) {
    cout << "Max Fourier: " << sqrt(gab.modulus) << endl;
  }
#endif

  gab.modulus=float(sqrt(gab.modulus));
  if(maxAtom->modulus>gab.modulus) 
    (*maxAtom)=gab;

  delete []resfft;
  delete []w;
}

void MatchingPursuit::findGaborOneCPU(Atom *maxAtom) {
  const int size=3*N;
  float maxModulus=0.0F,maxPhase=0.0F;
  register int i,index=0;
  Atom gab(N);
  Vector<double> Real(size),Imag(size),Exp(size);
  Vector<float>  w(2*size+16);

  FFT.resize(2*size);
  for(i=0 ; i<size ; i++)
    FFT[i]=res[i];

  __ogg_fdrffti(size,w.getPtr(),ifact);
  __ogg_fdrfftf(size,FFT.getPtr(),w.getPtr(),ifact);

  gab.type=GABOR;
  for(i=0 ; i<DicSize ; i++) {
    float phase,modulus;
    if(enableFFT(&gabors[i])) {
      modulus=findGaborPhase(Real.getPtr(),
			     Imag.getPtr(),
			     Exp.getPtr(),
			     FFT.getPtr(),
			     gabors[i].scale,
			     gabors[i].position,
			     gabors[i].freq,
			     &phase,
			     &gabors[i].Fs,
			     &gabors[i].Fc,
			     &gabors[i].CNorm,
			     &gabors[i].SNorm);
    } else {
      modulus=findGaborPhase(gabors[i].scale,
			     gabors[i].position,
			     gabors[i].freq,
			     &phase,
			     &gabors[i].Fs,
			     &gabors[i].Fc,
			     &gabors[i].CNorm,
			     &gabors[i].SNorm);
  }

    gabors[i].modulus=modulus;
    gabors[i].phase=phase;

    if(modulus>maxModulus) {
      maxModulus=modulus;
      index=i;
      maxPhase=phase;
    }
  }
  
  gab.modulus=float(sqrt(maxModulus));
  gab.scale=gabors[index].scale;
  gab.position=gabors[index].position;
  gab.phase=maxPhase;
  gab.CNorm=gabors[index].CNorm;
  gab.SNorm=gabors[index].SNorm;
  gab.freq=gabors[index].freq;
      
  if(gab.modulus>maxAtom->modulus) 
    (*maxAtom)=gab;
}

void MatchingPursuit::findGabor(Atom *maxAtom) {
  const int size=3*N,n=getNumOfThreads();
  Vector<float> w(2*size+16);
  FirstIteration loop(n,this);
  double *Re[MAX_THREADS],*Im[MAX_THREADS],*Exp[MAX_THREADS];
  register int i;

  for(i=0 ; i<n ; i++) {
    Re[i]=new double[size];
    Im[i]=new double[size];
    Exp[i]=new double[size];
  }

  FFT.resize(2*size);
  for(i=0 ; i<size ; i++)
    FFT[i]=res[i];
  
  __ogg_fdrffti(size,w.getPtr(),ifact);
  __ogg_fdrfftf(size,FFT.getPtr(),w.getPtr(),ifact);
  
  loop.setValue(*maxAtom,gabors,FFT.getPtr(),Re,Im,Exp);
  loop.loop(0,DicSize);

  Atom atom=loop.synchronize();
  if(atom.modulus>maxAtom->modulus)
    (*maxAtom)=atom;

  for(i=0 ; i<n ; i++) {
    delete []Re[i];
    delete []Im[i];
    delete []Exp[i];
  }
}

int MatchingPursuit::findCrossGabor(Atom *atom1,GaborParameter *atom2,
				    float *modulus,float *phase) {
  if(atom1->type!=GABOR)
    return -1;

  double Fs,Fc,Sin,Cos;
  if(GaborFactory::DotGaborAtoms(atom1->scale,N+atom1->position,atom1->freq,
				 atom1->phase,
				 atom2->scale,N+atom2->position,atom2->freq,
				 &Fs,&Fc)==-1)
    return -1;

  const double C=atom1->modulus/atom1->CNorm;
  atom2->Fs-=float(C*Fs);	
  atom2->Fc-=float(C*Fc);

  if(atom2->Fs==0.0 && atom2->Fc==0.0)
    *phase=0.0F;
  else
    *phase=(float)atan2(-atom2->Fs/atom2->SNorm,atom2->Fc/atom2->CNorm);

  const double Kc=atom2->CNorm,Ks=atom2->SNorm;
  sincos(*phase,&Sin,&Cos);
  *modulus=float(SQR(atom2->Fc*Cos-atom2->Fs*Sin)/(Kc*SQR(Cos)+Ks*SQR(Sin)));

  atom2->phase=*phase;
  atom2->modulus=*modulus;
  return  0;
}

float MatchingPursuit::findCrossGabor(Atom *atom1,
				      GaborParameter *atom2,
				      float *GaborTab,
				      float *TmpExpTab,
				      float *phase) {
  const double u1=double(atom1->position),u2=double(atom2->position); 
  double Sin,Cos;

  if(atom1->type!=DIRAC) { 
    double dtmp,K1,trans,DotSin,DotCos;
    int start,stop,pozycja;
    const double S1sqr=double(atom1->scale)*double(atom1->scale),
                 S2sqr=double(atom2->scale)*double(atom2->scale);
      
    K1=-M_PI*SQR(u1-u2)/(dtmp=S1sqr+S2sqr);
    if(K1>LOG_EPSYLON) {
      const int MaxStop=3*N-1;

      trans=int(0.5+(S1sqr*u2+S2sqr*u1)/dtmp);
      pozycja=(int)(N+trans);
      dtmp=1.5+sqrt((K1-LOG_EPSYLON)/(M_PI*dtmp/(S1sqr*S2sqr)));
      
      start=pozycja-(int)dtmp;
      if(start<0)
	start=0;
      
      stop=pozycja+(int)dtmp;
      if(stop>MaxStop)
	stop=MaxStop;
      
      DotGaborAtoms(M_PI/SQR(atom2->scale),atom2->freq,
		    N+atom2->position,start,stop,GaborTab,TmpExpTab,
		    &DotSin,&DotCos);
      
      atom2->Fs-=float(DotSin);	      
      atom2->Fc-=float(DotCos);
    } else {
      *phase=atom2->phase;
      return atom2->modulus;
    }
  } else {
    double itmp=u1-u2; 
    double dtmp=itmp/(double)atom2->scale;
    dtmp=atom1->modulus*exp(-M_PI*SQR(dtmp));

    sincos(atom2->freq*itmp,&Sin,&Cos);
    atom2->Fs-=float(dtmp*Sin);
    atom2->Fc-=float(dtmp*Cos);
  }
  
  if(atom2->Fs==0.0 && atom2->Fc==0.0)
    *phase=0.0F;
  else
    *phase=float(atan2(-atom2->Fs/atom2->SNorm,atom2->Fc/atom2->CNorm));

  const double Kc=atom2->CNorm,Ks=atom2->SNorm;
  sincos(*phase,&Sin,&Cos);
  const double modulus=SQR(atom2->Fc*Cos
			   -atom2->Fs*Sin)/(Kc*SQR(Cos)+Ks*SQR(Sin));

  atom2->phase=*phase;
  atom2->modulus=float(modulus);
  return float(modulus);
}

void MatchingPursuit::findTwoIterationGabor(Atom *oldAtom,Atom *maxAtom) {
  const int size=3*N;
  register int i;
  float  *GaborTab[MAX_THREADS],*ExpTab[MAX_THREADS];
  double *Exp[MAX_THREADS],*Real[MAX_THREADS],*Imag[MAX_THREADS];
  Vector<float> fft(2*size),w(2*size+16);
  int start,stop;

  for(i=0 ; i<MAX_THREADS ; i++) {
    GaborTab[i]=new float[size];
    ExpTab[i]=new float[size];
    Exp[i]=new double[size];
    Real[i]=new double[size];
    Imag[i]=new double[size];
  }

  for(int j=0 ; j<MAX_THREADS ; j++)
    for(i=0 ; i<size ; i++)
      Exp[j][i]=Imag[j][i]=Real[j][i]=GaborTab[j][i]=ExpTab[j][i]=0.0F;

  switch(oldAtom->type) {
  case GABOR:
    getGabor(GaborTab[0],
	     oldAtom->scale,
	     oldAtom->position,
	     oldAtom->freq,
	     oldAtom->phase);
    break;
  case FOURIER:
    getFourier(GaborTab[0],oldAtom->freq,oldAtom->phase);
    break;
  case DIRAC:
    GaborTab[0][N+oldAtom->position]=(oldAtom->phase<0.5*M_PI) ? 1.0F : -1.0F;
    break;
  }

  for(i=0 ; i<size ; i++) {
    const float value=(GaborTab[0][i]*=oldAtom->modulus);

    fft[i]=value;
    for(int j=1 ; j<MAX_THREADS ; j++)
      GaborTab[j][i]=value;
  }

  __ogg_fdrffti(size,w.getPtr(),ifact);
  __ogg_fdrfftf(size,fft.getPtr(),w.getPtr(),ifact);
  
  getStartAndStop(oldAtom->freq,oldAtom->scale, 
		  &start,&stop,size);

  Atom gab(N);
  gab.type=GABOR;

  NextIteration loop(getNumOfThreads(),this);

  loop.setValue(*maxAtom,gabors,oldAtom,ExpTab,GaborTab,
		Exp,Real,Imag,fft.getPtr(),start,stop,size);
  loop.loop(startGabor,DicSize);
  
  Atom atom=loop.synchronize();
  if(atom.modulus>maxAtom->modulus)
    (*maxAtom)=atom;
  
  for(i=0 ; i<MAX_THREADS ; i++) {
    delete []GaborTab[i];
    delete []ExpTab[i];
    delete []Exp[i];
    delete []Real[i];
    delete []Imag[i];
  }
}

void MatchingPursuit::optimizeGabors(Atom *atom) {
  if(atom->type!=GABOR)
    return;

  const int    size=3*N;
  const double df=size/M_PI;
  const double DeltaFreq=5.0/df;
  const int    DeltaTime=5,DeltaScale=5;
  int fmin,fmax,smin,smax,tmin,tmax;

  fmin=int(df*(atom->freq-DeltaFreq));
  if(fmin<0) fmin=1;
  fmax=int(df*(atom->freq+DeltaFreq));
  if(fmax>=size) fmax=size-1;

  tmin=atom->position-DeltaTime;
  if(tmin<0) tmin=0;
  tmax=atom->position+DeltaTime;
  if(tmax>=N) tmax=N-1;

  if(DicType!=OCTAVE) {
    smin=atom->scale-DeltaScale;
    if(smin<=1) smin=1;
    smax=atom->scale+DeltaScale;
    if(smax>=size) smax=size-1;
  } else {
    smin=smax=atom->scale;
  }

  float max=0.0F; 
  register int i,j,k;
  int maxI=atom->scale,maxJ=atom->position,maxK=int(atom->freq*df);
  float Fs,Fc,SNorm,CNorm,phase,maxPhase=atom->phase,value;
  float maxSNorm=atom->SNorm,maxCNorm=atom->CNorm;

  for(i=smin ; i<=smax ; i++)
    for(j=tmin ; j<=tmax ; j++)
      for(k=fmin ; k<=fmax ; k++) {
	const float freq=float(k/df);
	value=findGaborPhase(i,j,freq,&phase,&Fs,&Fc,&CNorm,&SNorm);
	
	if(value>max) {
	  max=value;
	  maxI=i;
	  maxJ=j;
	  maxK=k;
	  maxCNorm=CNorm;
	  maxSNorm=SNorm;
	  maxPhase=phase;
	}
      }

  max=float(sqrt(max));
#ifndef NO_DEBUG
    cout << "dE= " << (100.0*(1.0-SQR(atom->modulus/max))) << "%\n";
#endif
    atom->modulus=max;
    atom->scale=maxI;
    atom->position=maxJ;
    atom->freq=float(maxK/df);
    atom->CNorm=maxCNorm;
    atom->SNorm=maxSNorm;
    atom->phase=maxPhase;
}

void MatchingPursuit::findTwoIterationGaborOneCPU(Atom *oldAtom,
						  Atom *maxAtom) {
  const int size=3*N;
  float *GaborTab=new float[size],*ExpTab=new float[size];
  Vector<double> Real(size),Imag(size),Exp(size);
  Vector<float>  fft(2*size),w(2*size+16);
  int start,stop,i;
 
  for(i=0 ; i<size ; i++)
    GaborTab[i]=ExpTab[i]=0.0F;

   switch(oldAtom->type) {
   case GABOR:
    getGabor(GaborTab,
	     oldAtom->scale,
	     oldAtom->position,
	     oldAtom->freq,
	     oldAtom->phase);
    break;
  case FOURIER:
    getFourier(GaborTab,oldAtom->freq,oldAtom->phase);
    break;
  case DIRAC:
    GaborTab[N+oldAtom->position]=((oldAtom->phase<0.5*M_PI) ? 1.0F : -1.0F);
    break;
  }

  for(i=0 ; i<size ; i++)
    fft[i]=(GaborTab[i]*=oldAtom->modulus);

  __ogg_fdrffti(size,w.getPtr(),ifact);
  __ogg_fdrfftf(size,fft.getPtr(),w.getPtr(),ifact);
  
  getStartAndStop(oldAtom->freq,oldAtom->scale, 
		  &start,&stop,size);

  Atom gab(N);
  gab.type=GABOR;

  float maxModulus=0.0F,maxPhase=0.0F;
  int index=0;
 
  for(i=startGabor ; i!=-1 ; i=gabors[i].next) {
      float phase,modulus;
      
      if(enableFFT(&gabors[i],2)) {
	int new_start,new_stop;
	
	if(setNewStartAndStop(start,stop,&new_start,&new_stop,
			      gabors[i].scale,gabors[i].freq,size)) {
	  modulus=findGaborPhase(Real.getPtr(),
				 Imag.getPtr(),
				 Exp.getPtr(),
				 fft.getPtr(),
				 gabors[i].scale,
				 gabors[i].position,
				 gabors[i].freq,
				 &phase,
				 &gabors[i].Fs,
				 &gabors[i].Fc,
				 gabors[i].CNorm,
				 gabors[i].SNorm,
				 new_start,
				 new_stop);
	  
	  gabors[i].phase=phase;
	  gabors[i].modulus=modulus;
	} else {
	  modulus=gabors[i].modulus;
	  phase=gabors[i].phase;
	}
      } else {
	modulus=findCrossGabor(oldAtom,
			       &gabors[i],
			       GaborTab,
			       ExpTab,
			       &phase);
      }
      
      if(modulus>maxModulus) {
	maxModulus=modulus;
	index=i;
	maxPhase=phase;
      }  
  } 
  
  gab.modulus=float(sqrt(maxModulus));
  gab.CNorm=gabors[index].CNorm;
  gab.SNorm=gabors[index].SNorm;
  gab.scale=gabors[index].scale;
  gab.position=gabors[index].position;
  gab.phase=maxPhase;
  gab.freq=gabors[index].freq;

  if(gab.modulus>maxAtom->modulus) 
    (*maxAtom)=gab;

  delete []GaborTab;
  delete []ExpTab;
}

void MatchingPursuit::subAtom(const Atom &atom) {
  const int size=3*N;
  Vector<float> ftmp(size);
  register int i;

  switch(atom.type) {
  case DIRAC:
      res[atom.position]+=atom.modulus*((atom.phase>0.5*M_PI) ? -1.0F : 1.0F);
    break;
  case FOURIER:
    getFourier(ftmp.getPtr(),atom.freq,atom.phase);
    for(i=0 ; i<size ; i++)
      res[i]-=atom.modulus*ftmp[i];
    break;
  case GABOR:
    getGabor(ftmp.getPtr(),atom.scale,atom.position,atom.freq,atom.phase);
    for(i=0 ; i<size ; i++) 
      res[i]-=atom.modulus*ftmp[i];
    break;
  }
}

float MatchingPursuit::energy() const {
  const int size=2*N;
  register int i;
  float sum=0.0F;

  for(i=N ; i<size ; i++)
    sum+=res[i]*res[i];
  return(sum);
}

float MatchingPursuit::signalEnergy() const {
  const int size=2*N;
  register int i;
  float sum=0.0F;
  
  for(i=N ; i<size ; i++)
    sum+=sig[i]*sig[i];
  return(sum);
}

float MatchingPursuit::fullenergy() const {
  const int size=3*N;
  register int i;
  float sum=0.0F;

  for(i=0 ; i<size ; i++)
    sum+=res[i]*res[i];
  return(sum);
}

static void find(float a[],int n,int k) {
  register int l=0,p=n-1,i,j;	
  float x,w;
  
  while(l<p) {
    x=a[k]; i=l; j=p;
    do {
      while(a[i]>x) i++;
      while(x>a[j]) j--;
      if(i<=j) {
	w=a[i]; 
	a[i]=a[j]; 
	a[j]=w;
	i++; 
	j--;
      }
    } while(i<=j);
    if(j<k) l=i;
    if(k<i) p=j;
  }
}

static float findmin(float a[],int k,int n) {
  register int i;
  float min;

  find(a,n,k);
  for(i=0,min=a[0] ; i<k ; i++)
    if(min>a[i])
      min=a[i];
  return min;
}

void MatchingPursuit::optimizeDictionary() {
  Vector<char>  mode(DicSize);
  register int i,j,k,oldIndex=-1;
  double t1,t2;

  if(!quiet)
    cout << "optimizing dictionary...\n";
  t1=Clock();

  if(fabs(AdaptiveConst)<1.0e-8) {
    k=DicSize;
    for(i=0 ; i<DicSize ; i++)
      mode[i]=1;
  } else {
    Vector<float> mod(DicSize);
    float Const;

    for(i=0 ; i<DicSize ; i++)
      mod[i]=gabors[i].modulus;
    
    const int dim=int((1.0-AdaptiveConst)*DicSize);
    Const=findmin(mod.getPtr(),dim,DicSize);
    for(i=0,k=0 ; i<DicSize ; i++)
      if(gabors[i].modulus>=Const) {
	mode[i]=1;
	k++;
      } else {
	mode[i]=0;
      }
    if(!quiet)
      cout << "modulus alpha       : " << Const << endl;
  }

  for(i=DicSize-1 ; i>=0 ; i--) 
    if(mode[i]) {
      gabors[i].next=-1;
      oldIndex=i;

      for(j=i-1 ; j>=0 ; j--)
	if(mode[j]) {
	  gabors[j].next=oldIndex;
	  oldIndex=j;
	}
      break;
    }

  startGabor=oldIndex;  
  t2=Clock();
  if(!quiet) {
    cout << "new dictionary size : " << k << " (" 
	 << ((float)DicSize/k) << "x)\n";
    cout << "time                : " << (t2-t1) << "sec\n\n";
  }
  /*
  if(debug==1) {
    ofstream file("dic.dat");
    if(!file) 
      return;
    if(!quiet)
      cout << "saving dictionary " << DicSize << " atoms\n";
    for(i=0 ; i<DicSize ; i++)
      file << gabors[i].modulus  << " " 
	   << gabors[i].scale    << " "
	   << gabors[i].position << " "
	   << gabors[i].freq     << " "
	   << gabors[i].CNorm    << " "
	   << gabors[i].SNorm    << " " 
	   << gabors[i].Fc       << " "
	   << gabors[i].Fs       << " "     
	   << gabors[i].phase    << " "
	   << gabors[i].next     << " "
	   << int(mode[i])       << endl;
    file.close();
    }*/
}

inline void MatchingPursuit::recalcParameter(Atom *gab) {
  if(gab->type==GABOR) {
    float Fs,Fc;
    gab->modulus=float(sqrt(findGaborPhase(gab->scale,
					   gab->position,
					   gab->freq,
					   &gab->phase,
					   &Fs,
					   &Fc,
					   &gab->CNorm,
					   &gab->SNorm)));
  }
}

void MatchingPursuit::mp(int maxIter) {
  const int size=3*N;
  register int i,k;
  double t1,t2,first_time=0.0;
  Atom gab(N),oldGab(N);
  
  MaxIter=TrueDim=maxIter;
  for(i=0 ; i<size ; i++)
    res[i]=sig[i];

  const float E0=energy(); //,EF0=fullenergy();

  if(E0<1.0e-8F) {
    cout << "flat signal !\n";
    return;
  }

  t1=Clock();
  if(atoms!=0)
    delete []atoms;
  atoms=new Atom[maxIter];

  for(k=0 ; k<maxIter ; k++) {
    gab.modulus=0.0F;
    findDirac(&gab);
    findFourier(&gab);

    if(k==0) {
      if(!quiet)
	cout << "computing first iteration...\n";
      double t1=Clock(),t2;
      if(splitLoop==1)
	findGaborOneCPU(&gab);
      else 
	findGabor(&gab);
      
      t2=Clock();
      const double tim=(t2-t1);
      first_time=tim;

      if(!quiet) {
	cerr << "time: " << tim << " sec.\n";
	if(tim>0.01) {
	  char buff[256];
	  sprintf(buff,"%10.3f atoms/sec\n",getDicSize()/tim);
	  cerr << buff;
	}
      }
      
      optimizeDictionary();
    } else {
      if(splitLoop==1) {
	findTwoIterationGaborOneCPU(&oldGab,&gab);
      } else
	findTwoIterationGabor(&oldGab,&gab);
    }

    recalcParameter(&gab);
    if(eSearch)
      optimizeGabors(&gab);

    subAtom(gab);
    atoms[k]=oldGab=gab;
    const float eps=100.0F*(1.0F-energy()/E0);
    if(!quiet) {
      //   cout <<"["<<k<<"]" << 
      //	   " energ res w skl "<<energy()<<" energ syg w skl "<<signalEnergy() <<" eps "<<eps<< endl;
      cout <<"[" << k << "] " << eps << endl; 
    }

    if(eps>=epsylon) {
      TrueDim=k+1;
      break;
    }
  }

  t2=Clock();
  if(!quiet) {
    float tim=float(t2-t1);
    
    cout << "\ntotal time                     : " << tim << endl;
    tim-=float(first_time);
    cout << "time (without first iteration) : " << tim << " ";
    if(fabs(tim)>0.01) {
      char buff[256];
      
      sprintf(buff,"(%10.3f atoms/sec)\n",
	      ((1.0-AdaptiveConst)*getDicSize()*(TrueDim-1))/tim );
      cout << buff;
    } else cout << endl;
    cout << endl;
  }
}

bool MatchingPursuit::save(const char *filename,int mode) {
  FILE_HEADER        file_header;
  SEG_HEADER         head;
  NEW_ATOM           atom;
  FILE               *file=0;
  decomposition_info dec_info;
  signal_info        sig_info;
  bool               append=false,ok=false;

  switch(mode) {
  case APPEND: 
    file=fopen(filename,"a+b");
    append=true;
    break;
  case NEWFILE:
    file=fopen(filename,"wb");
    break;
  }

  if(file==0)
    return false;
  
  if(append) {
    if(FileSize(file)!=0L) {
       if(checkBookVersion(file)==-1) {
	 cerr << "Incompatible format !\n";
	 fclose(file);
	 return false;
       } 
     } else {
       ok=true;
     }
   } else {
     ok=true;
   }

  if(ok) {
    initField(&file_header);
    addTextInfo(&file_header,"http://brain.fuw.edu.pl/~mp");
    dec_info.energy_percent=              epsylon;
    dec_info.max_number_of_iterations=    MaxIter;
    dec_info.dictionary_size=             DicSize;
    dec_info.dictionary_type=             (DicType==OCTAVE) ? 'D' : 'S';
    addDecompInfo(&file_header,&dec_info);

    sig_info.sampling_freq=               SamplingRate;
    sig_info.points_per_microvolt=        ConvRate;
    sig_info.number_of_chanels_in_file=   ChannelMaxNum;
    addSignalInfo(&file_header,&sig_info);
    addDate(&file_header);

    if(WriteFileHeader(&file_header,file)==-1) {
      cerr << "Cannot write file header !\n";
      freeAllFields(&file_header);
      fclose(file);
      return false;
    }
    
    freeAllFields(&file_header);
  }

  head.channel=             ChannelNumber;
  head.file_offset=         file_offset;
  head.book_size=           TrueDim;
  head.signal_size=         N;
  head.signal_energy=       signalEnergy();
  head.book_energy=         energy();
 
  if(WriteSegmentHeader(&head,file)==-1) {
    cerr << "Cannot write segment header !\n";
    fclose(file);
    return false;
  }
  for(int i=0 ; i<TrueDim ; i++) {
    atom.modulus=atoms[i].modulus;
    atom.scale=atoms[i].scale;
    atom.position=atoms[i].position;
    atom.frequency=float(0.5*N*atoms[i].freq/M_PI);
    atom.phase=atoms[i].phase; 
    atom.amplitude=float(atoms[i].modulus*makeAmplitude(3*N,atoms[i].freq,atoms[i].scale,
				                        atoms[i].phase));
    
    if(WriteNewAtom(&atom,file)==-1) {
      cerr << "Cannot save an atom !\n";
      fclose(file);
      return false;
    }
  }
   
  fclose(file);
  return true;
}

bool MatchingPursuit::saveSignal(const char *filename) {
  if(sig==0 || res==0)
    return false;

  FILE *file=fopen(filename,"wt");
  if(file==NULL) return false;
  for(int i=0 ; i<3*N ; i++)
    fprintf(file,"%d %g %g\n",i,res[i],sig[i]);
  fclose(file);
  return true;
}

void MatchingPursuit::reset() {
  const int size=3*N;
  register int i;
  for(i=0 ; i<size ; i++) 
    sig[i]=res[i]=0.0F;
}

void MatchingPursuit::norm() {
  const int size=3*N;
  register int i;
  float sum=0.0F;

  for(i=0 ; i<size ; i++) 
    sum+=sig[i];

  sum/=size;
  for(i=0 ; i<size ; i++)
    sig[i]-=sum;
}

void MatchingPursuit::showInfo(ostream &) const {
  if(quiet) 
    return;
  /*

    Jeszcze nie dziala tak jak trzeba.

  file << "maksymalna liczna iteracji        : " << getMaxIter()  << endl;
  file << "czestotliwosc probkowania         : " << getSampling() << endl;
  file << "stala konwersji p/uV              : " << getConvRate() << endl;
  file << "maksymana liczba kanalow          : " << getChannelMaxNum() << endl;
  file << "numer kanalu                      : " << getChannelNumber() << endl;
  file << "dodatkowe przeszukiwanie slownika : " << getESearch() << endl;
  file << "rozdzielczosc czasowa             : " << getDTime() << " puntkow\n";
  file << "rozdzielczosc czestotliwosciowa   : " <<  getDFreq() <<" puntkow\n";
  file << "rozdzielczosc w skalach           : " <<  getDScale()<<" puntkow\n";
  file << "rodzaj slowika                    : ";
  switch(getDicType()) {
  case OCTAVE: file << "oktawowy" << endl; break;
  case FULLSTOCH: file << "stochastyczny" << endl; break;
  case VBOX: file << "stochatyczny z rozdzielczosciami" << endl;
  }
  file << "rozmiar slownika                  : " << getDicSize() << endl;
  file << "redukcja slownika                 : " << getAlpha() << endl;
  file << "rekonstrukcja sygnalu             : " << getEpsylon() << endl;
  file << "rozmiar bazy                      : " << getBaseSize() << endl;
  */
}





