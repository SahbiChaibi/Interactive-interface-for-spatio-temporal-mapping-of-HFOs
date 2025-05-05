#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "GaborFactory.h"

const  int MAXARGSIZE=256;
extern int quiet;

class StrToArgv {
  char *argv[MAXARGSIZE];
  int argc;

public:
  StrToArgv(const char string[]);
  ~StrToArgv();

  int    getargc() const { return argc; }
  char **getargv() { return argv; }
};

StrToArgv::StrToArgv(const char string[]) {
  char buf[MAXARGSIZE];
  int i=0,m;                   
  
  argc=0;
  for( ; ; ) {
    while(isspace(string[i]) && string[i]) i++;
    if(sscanf(string+i,"%s",buf)<1 || argc>=MAXARGSIZE) 
      break;     
    m=strlen(buf);
    argv[argc]=new char[m+1];
    strcpy(argv[argc],buf);
    argc++;
    i+=m;
  }
}

StrToArgv::~StrToArgv() {
  for(int i=0 ; i<argc ; i++)
    delete []argv[i];
}

static int  opterr=1,optind=1,optopt,sp=1;
static char *optarg;

#define ERR(STR, CHR) if(opterr) fprintf(stdout,"%s%c\n",STR,CHR);

int Getopt(int argc,char **argv,char *opts) {
  register int c;				
  register char *cp;

  if(sp==1) { 
    if(optind>=argc || argv[optind][0]!='-' || argv[optind][1]=='\0')
      return(EOF);
    else if(strcmp(argv[optind],"--")==0) {
      optind++;
      return(EOF);
    }
  }
  
  optopt=c=argv[optind][sp];
  if(c==':' || (cp=strchr(opts,c))==0) {
    ERR(": illegal option -- ", c);
    if(argv[optind][++sp] == '\0') {
      optind++;
      sp=1;
    }
    return('?');
  }
  if(*++cp==':') {
    if(argv[optind][sp+1]!='\0')
      optarg=&argv[optind++][sp+1];
    else if(++optind>=argc) {
      ERR(": option requires an argument -- ", c);
      sp=1;
      return('?');
    }
    else
      optarg=argv[optind++];
    sp=1;
  } else {
    if(argv[optind][++sp]=='\0') {
      sp=1;
      optind++;
    }
    optarg=NULL;
  }
  return(c);
}

#undef ERR

void Shell::help() {
  char *argv[]={ "-?" };
  int argc=1;

  out << "\n";
  loadsig(argc,argv);
  out << endl;
  mp(argc,argv);
  out << endl;
  save(argc,argv);
  out << endl;
  reinit(argc,argv);
  out << endl;
  out << "reset\n";
  out << endl;
  out << "norm\n";
  out << endl;
  savesignal(argc,argv);
  out << endl;
  border(argc,argv);
  out << endl;
  makeChannel(argc,argv);
  out << endl;
}

bool Shell::loadsig(int argc,char *argv[]) {
  char filename[256]="dane.dat";
  int opcja,maxChn=1,chn=1,offset=0,type=ASCII,pos=0,ref1=-1,ref2=-1,shift=0;
  float Conv=1.0F,Samp=1.0F;

  opterr=optind=0; sp=1;
  while((opcja=Getopt(argc,argv,"O:c:h:#:?t:C:F:p:e:f:s:"))!=EOF)
    switch(opcja) {
    case 's':
      shift=atoi(optarg);
      break;
    case 'e':
      ref1=atoi(optarg);
      break;
    case 'f':
      ref2=atoi(optarg);
      break;
    case 'p':
      if(strcmp(optarg,"right")==0)
	pos=2;
      else if(strcmp(optarg,"left")==0)
	pos=1;
      else if(strcmp(optarg,"center")==0)
	pos=0;
      break;
    case 'C':
      Conv=float(atof(optarg));
      break;
    case 'F':
      Samp=float(atof(optarg));
      break;
    case 'O': 
      strcpy(filename,optarg);
      break;
    case 'c':
      chn=atoi(optarg);
      break;
    case 'h':
      maxChn=atoi(optarg);
      break;
    case '#':
      offset=atoi(optarg);
      break;
    case 't':
      if(strcmp(optarg,"ascii")==0)
	type=ASCII;
      else if(strcmp(optarg,"float")==0)
	type=BINARY_FLOAT;
      else if(strcmp(optarg,"short")==0)
	type=BINARY_SHORT;
      break;
    case '?':
    default:
      out << "loadsig -O filename [-c channel] [-h maxchannls]\n" 
	  << "        [-# offset] [-t ascii|float|short]\n"
	  << "        [-F sampling] [-C conv]\n"
	  << "        [-e ref1]\n"
	  << "        [-f ref2]\n"
	  << "        [-s shift (B)]\n"
	  << "        [-p left|center|right]\n";
      return true;
    }

  return MatchingPursuit::load(filename,type,maxChn,chn,offset,
			       Samp,Conv,pos,ref1,ref2,shift);
}

bool Shell::makeChannel(int argc,char *argv[]) {
  char filename[256]="dane.dat",outfile[256]="book.b";
  int opcja,maxChn=1,chn=1,offset=0,type=ASCII,Border=3,
      ref1=-1,ref2=-1,shift=0,newseed=0;
  float Conv=1.0F,Samp=1.0F;
  int maxOffset=-1;

  opterr=optind=0; sp=1;
  while((opcja=Getopt(argc,argv,"O:c:h:#:?t:C:F:p:e:f:M:I:is:"))!=EOF)
    switch(opcja) {
    case 'i':
      newseed=1;
      break;
    case 'I':
      strcpy(outfile,optarg);
      break;
    case 'M':
      maxOffset=atoi(optarg);
      break;
    case 's':
      shift=atoi(optarg);
      break;
    case 'e':
      ref1=atoi(optarg);
      break;
    case 'f':
      ref2=atoi(optarg);
      break;
    case 'p':
      if(strcmp(optarg,"zero")==0)
	Border=0;
      else if(strcmp(optarg,"periodic")==0)
	Border=1;
      else if(strcmp(optarg,"shift")==0)
	Border=2;
      else if(strcmp(optarg,"natural")==0)
	Border=3;
      break;
    case 'C':
      Conv=float(atof(optarg));
      break;
    case 'F':
      Samp=float(atof(optarg));
      break;
    case 'O': 
      strcpy(filename,optarg);
      break;
    case 'c':
      chn=atoi(optarg);
      break;
    case 'h':
      maxChn=atoi(optarg);
      break;
    case '#':
      offset=atoi(optarg);
      break;
    case 't':
      if(strcmp(optarg,"ascii")==0)
	type=ASCII;
      else if(strcmp(optarg,"float")==0)
	type=BINARY_FLOAT;
      else if(strcmp(optarg,"short")==0)
	type=BINARY_SHORT;
      break;
    case '?':
    default:
      out << "channel -O filename [-c channel] [-h maxchannls]\n" 
	  << "        [-# offset] [-t ascii|float|short]\n"
	  << "        [-F sampling] [-C conv]\n"
	  << "        [-e ref1]\n"
	  << "        [-f ref2]\n"
	  << "        [-s shift (B)]\n"
	  << "        [-I book.b]\n"
	  << "        [-M max-offset]\n"
	  << "        [-i]\n"
	  << "        [-p zero|periodic|shift|natural]\n";
      return true;
    }

  return MatchingPursuit::makechannel(filename,outfile,type,maxChn,chn,offset,
				      maxOffset,Samp,Conv,Border,ref1,ref2,
				      shift,newseed);
}

bool Shell::mp(int argc,char *argv[]) {
  if(setMP(argc,argv)==false)
    return true;
  MatchingPursuit::setepsylon(MatchingPursuit::DefaultEps);
  MatchingPursuit::mp(MatchingPursuit::DefaultIter);
  return true;
}

bool Shell::setMP(int argc,char *argv[]) {
  bool noexit=false;
  int  opcja;

  opterr=optind=0; sp=1;
  while((opcja=Getopt(argc,argv,"i:e:?"))!=EOF)
    switch(opcja) {
    case 'i': 
      MatchingPursuit::DefaultIter=atoi(optarg);
      noexit=true;
      break;
    case 'e':
      MatchingPursuit::DefaultEps=float(atof(optarg));
      noexit=true;
      break;
    case '?':
    default:
      out << "mp/set [-i maxIter] [-e eps]\n"; 
      return false;
    }

  /*  if(noexit) {
    if(!quiet) {
      out << "Max number of iterations : " 
	  <<  MatchingPursuit::DefaultIter << endl;
      out << "Reconstruction accuracy  : "
	  <<  MatchingPursuit::DefaultEps << endl;
    }
}
  */
  showInfo(out);
 
  return true;
}

bool Shell::save(int argc,char *argv[]) {
  char filename[256]="book.b";
  int newFile=NEWFILE;
  int opcja;

  opterr=optind=0; sp=1;
  while((opcja=Getopt(argc,argv,"O:as?"))!=EOF)
    switch(opcja) {
    case 'O':
      strcpy(filename,optarg);
      break;
    case 's':
      newFile=NEWFILE;
      break;
    case 'a':
      newFile=APPEND;
      break;
    case '?':
    default:
      out << "save [-O filename] [-a] [-s]\n";
      return true;
    }

  return MatchingPursuit::save(filename,newFile);
}

bool Shell::reinit(int argc,char *argv[]) {
  int opcja,dicSize=100000,seed=1,sigsize=getBaseSize(),type=FULLSTOCH;
  bool enable=true;
  float samp=1.0F,dt=0.1F,df=0.1F,ds=0.1F;
  bool ok[3]={ false, false, false };

  opterr=optind=0; sp=1;
  while((opcja=Getopt(argc,argv,"O:R:i?t:D:e:F:T:S:f:"))!=EOF)
    switch(opcja) {
    case 'f':
      samp=(float)atof(optarg);
      break;
    case 'F':
      df=(float)atof(optarg); ok[0]=true;
      break;
    case 'T':
      dt=(float)atof(optarg); ok[1]=true;
      break;
    case 'S':
      ds=(float)atof(optarg); ok[2]=true;
      break;
    case 'e':
      if(strcmp(optarg,"+")==0)
	enable=true;
      else if(strcmp(optarg,"-")==0)
	enable=false;
      break;
    case 'D':
      MatchingPursuit::setAlpha(float(atof(optarg)));
      break;
    case 't':
      if(strcmp(optarg,"fullstoch")==0)
	type=FULLSTOCH;
      else if(strcmp(optarg,"octave")==0)
	type=OCTAVE;
      else if(strcmp(optarg,"box")==0)
	type=VBOX;
      else {
	cout << "bad dictionary name !\n";
	return false;
      }
      break;
    case 'R':
      dicSize=atoi(optarg);
      break;
    case 'i':
      seed=(unsigned short)time(0);
      break;
    case 'O':
      sigsize=atoi(optarg);

//    ok[0]=ok[1]=ok[2]=true;
     
      break;
    case '?':
    default:
      out << "reinit [-O dimbase] [-R dicsize] [-i] "
	  << "[-t fullstoch|octave|box]\n"
	  << "       [-D adaptive] [-e +|-]\n"
	  << "       [-f sampling]\n"
	  << "       [-T dtime]\n"
	  << "       [-S dscale]\n"
	  << "       [-F dfreq]\n";
      return true;
    }

  if(ok[0]) {
    DF=2.0F*df/samp;
  }
  
  if(ok[1]) {
    DT=dt/(sigsize/samp);
  }
  
  if(ok[2]) {
    DS=ds/(sigsize/samp);
  }
  
  if(!quiet) {
    out << "\nDF " << (100.0*DF) << " % (" << (0.5*DF*samp) << " Hz)\n"
	<< "DT " << (100.0*DT) << " % (" << (DT*sigsize/samp) 
	<< " sec)\n"
	<< "DS " << (100.0*DS) << " % (" << (DS*sigsize/samp) 
        << " sec)\n\n";
    genDictionary(true);
  }   
 
  GaborFactory::make(sigsize);
  GaborDictionary::make(sigsize,dicSize,type,seed);
  MatchingPursuit::enableOptimizeGabor(enable);
  if(!quiet)
    cout<<"Dictionary size: "<<DicSize<<endl;
  
  return true;
}

bool Shell::savesignal(int argc,char *argv[]) {
  char filename[256]="signal.dat";
  int  opcja;

  opterr=optind=0; sp=1;
  while((opcja=Getopt(argc,argv,"O:?"))!=EOF)
    switch(opcja) {
    case 'O':
      strcpy(filename,optarg);
      break;
    case '?':
    default:
      out << "type -O filename\n";
      return true;
    }
  return MatchingPursuit::saveSignal(filename);
}

bool Shell::border(int argc,char *argv[]) {
  const char comment[]="border [-shift] [-periodic]\n";
  int mode=2;

  for(int i=0 ; i<argc ; i++)
    if(strcmp(argv[i],"-shift")==0)
      mode=1;
    else if(strcmp(argv[i],"-periodic")==0)
      mode=2;
    else if(strcmp(argv[i],"-?")==0) {
      out << comment;
      return true;
    } else {
      out << comment;
      return false;
    }

  GaborFactory::shiftSig(mode);
  return true;
}

int Shell::exec_command(const char *command,const char *options) {
  bool error=false;

  StrToArgv args(options);
  if(strcmp(command,"loadsig")==0) {
    error=!loadsig(args.getargc(),args.getargv());
  } else if(strcmp(command,"mp")==0) {
    error=!mp(args.getargc(),args.getargv());
  } else if(strcmp(command,"save")==0) {
    error=!save(args.getargc(),args.getargv());
  } else if(strcmp(command,"reinit")==0) {
    error=!reinit(args.getargc(),args.getargv());
  } else if(strcmp(command,"reset")==0) {
    reset();
  } else if(strcmp(command,"norm")==0) {
    norm();  
  } else if(strcmp(command,"help")==0) {
    help();
  } else if(strcmp(command,"type")==0) {
    error=!savesignal(args.getargc(),args.getargv());
  } else if(strcmp(command,"border")==0) {
    error=!border(args.getargc(),args.getargv());
  } else if(strcmp(command,"set")==0) {
    setMP(args.getargc(),args.getargv());
  } else if(strcmp(command,"channel")==0) {
    error=!makeChannel(args.getargc(),args.getargv());
  } else {
    out << "command " << command  << " not found\n";
  }
  return error ? -1 : 0;
}
