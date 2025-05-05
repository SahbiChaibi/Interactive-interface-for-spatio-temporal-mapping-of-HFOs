// 2000-02-19/20

#include <time.h>
#include "FileFormats.h"
#include "Vector.h"
#include "GaborFactory.h"

extern int quiet;

bool MatchingPursuit::load(const char *filename,int mode,
			   int maxChn,int chn,int offset,
			   float samp,float conv,int pos,
			   int ref1,int ref2,int shift) {
  const int NONE=0,ONEA=1,ONEB=2,TWO=3,size=2*N;
  int i,ref;

  chn--;
  ref1--;
  ref2--;

  if(ref1<0 && ref2<0)
    ref=NONE;
  else if(ref1<0 && ref2>=0)
    ref=ONEB;
  else if(ref1>=0 && ref2<0)
    ref=ONEA;
  else 
    ref=TWO;
    
  ChannelMaxNum=maxChn;
  ChannelNumber=chn;

  SamplingRate=samp;
  ConvRate=conv;
  
  SignalStream *str;
  switch(mode) {
  case BINARY_FLOAT: 
    str=new RawFloatSignalStream(shift); 
    break;
  case BINARY_SHORT: 
    str=new RawSignalStream(shift); 
    break;
  case ASCII:
    str=new AsciiSignalStream(shift); 
    break;
  default:
    return false;
  }

  Vector<float> stmp(maxChn);

  str->setChannels(maxChn);
  if(str->open(filename)==-1) {
#ifndef NO_DEBUG
    cerr << "can't open file\n";
#endif
    return false;
  }

  if(str->read(stmp.getPtr(),offset)==-1) {
    delete str;
#ifndef NO_DEBUG
    cerr << "can't read file\n";
#endif
    return false;
  }

  switch(ref) {
  case ONEA: 
    stmp[chn]-=stmp[ref1];
    break;
  case ONEB:
    stmp[chn]-=stmp[ref2];
    break;
  case TWO:
    stmp[chn]-=0.5F*(stmp[ref1]+stmp[ref2]);
    break;
  }

  switch(pos) {
  case 0:
    sig[N]=stmp[chn];
    break;
  case 1:
    sig[0]=stmp[chn];
    break;
  case 2:
    sig[2*N]=stmp[chn];
    break;
  }

  for(i=N+1 ; i<size ; i++) {
    if(str->read(stmp.getPtr())==-1) {
      delete str;
#ifndef NO_DEBUG
      cerr << "can't read file " << i << endl;
#endif
      return false;
    }

    switch(ref) {
    case ONEA: 
      stmp[chn]-=stmp[ref1];
      break;
    case ONEB:
      stmp[chn]-=stmp[ref2];
      break;
    case TWO:
      stmp[chn]-=0.5F*(stmp[ref1]+stmp[ref2]);
      break;
    }

    switch(pos) {
    case 0:
      sig[i]=stmp[chn];
      break;
    case 1:
      sig[i-N]=stmp[chn];
      break;
    case 2:
      sig[i+N]=stmp[chn];
      break;
    }
  }
    
  setSignal(sig);
  delete str;
  return true;
}

static int getMaxOffset(const char *filename,int mode,int shift,int maxChn) {
  SignalStream *str;
  int maxOffset;

  switch(mode) {
  case BINARY_FLOAT: 
    str=new RawFloatSignalStream(shift); 
    break;
  case BINARY_SHORT: 
    str=new RawSignalStream(shift); 
    break;
  case ASCII:
    str=new AsciiSignalStream(shift); 
    break;
  default:
    return -1;
  }

  str->setChannels(maxChn);
  if(str->open(filename)==-1) {
    delete str;
    return -1;
  }
  
  maxOffset=str->getMaxOffset();
 
  delete str;
  return maxOffset;
}

bool MatchingPursuit::makechannel(const char *filename,const char *outfile,
				  int mode,int maxChn,int chn,int offset,
				  int maxoffset,float samp,float conv,int pos,
				  int ref1,int ref2,int shift,int newseed) {
  const int maxOffset=getMaxOffset(filename,mode,shift,maxChn)/N-1;

  if(maxOffset<=0)
    return false;

  if(maxoffset<=0)
    maxoffset=maxOffset;
  else if(maxoffset>maxOffset)
    maxoffset=maxOffset;

  if(offset>maxoffset)
    return false;

  if(!quiet) {
    cout << "min offset      : " << offset << endl 
	 << "max offset      : " << maxoffset << endl;
    cout << "num of segments : " << (maxoffset-offset+1) << endl; 
  }

  reset();
  for(int i=offset ; i<=maxoffset ; i++) {
    if(newseed==1) 
      GaborDictionary::reinit((unsigned short)time(0));
   
    if(!quiet) {
      cout << "offset: " << i << " (" << (maxoffset-i) << ")\n";
    }

    if(pos==1) {          // symetric 
      if(!load(filename,mode,maxChn,chn,i*N,samp,conv,0,ref1,ref2,shift))
	return false;
      shiftSig(2);
    } else if(pos==2) {   // shift
      if(i==offset) {
	if(!load(filename,mode,maxChn,chn,i*N,samp,conv,0,ref1,ref2,shift))
	  return false;
	if(i+1<=maxoffset) {
	  if(!load(filename,mode,maxChn,chn,(i+1)*N,samp,conv,2,ref1,ref2,shift))
	    return false;
	} 
      } else {
	shiftSig(1);
        if(i+1<=maxoffset )  
	if(!load(filename,mode,maxChn,chn,(i+1)*N,samp,conv,2,ref1,ref2,shift))
	  return false;
      }
    } else if(pos==3) {  // natural
      reset();
      if(i-1>=offset) {
	if(!load(filename,mode,maxChn,chn,(i-1)*N,samp,conv,1,ref1,ref2,shift))
	  return false;
      }
      if(i+1<=maxoffset) {
	if(!load(filename,mode,maxChn,chn,(i+1)*N,samp,conv,2,ref1,ref2,shift))
	  return false;
      }
      if(!load(filename,mode,maxChn,chn,i*N,samp,conv,0,ref1,ref2,shift))
	return false;
    } else {           // zero
      reset();
      if(!load(filename,mode,maxChn,chn,i*N,samp,conv,0,ref1,ref2,shift))
	return false;
    }

    setepsylon(DefaultEps);
    mp(DefaultIter);
    if(!save(outfile,APPEND))
      return false;
  }
  return true;
}




