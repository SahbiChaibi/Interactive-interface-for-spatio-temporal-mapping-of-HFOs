// 2000-02-19

#include <string.h>
#include "FileFormats.h"

#ifndef INTELSWP
#ifdef __GNUC__
extern "C" void swab(const void *, void *,size_t); 
#endif

static int ReadFloat(FILE *fptr,float *n) {
  unsigned char *cptr,tmp;

  if(fread(n,4,1,fptr) != 1)
    return(-1);
  cptr=(unsigned char *)n;
  tmp=cptr[0];
  cptr[0]=cptr[3];
  cptr[3]=tmp;
  tmp=cptr[1];
  cptr[1]=cptr[2];
  cptr[2]=tmp;
  return(0);
}

#endif

long SignalStream::filelength() {
  if(file==0) return 0L;
  fseek(file,0L,SEEK_END);
  const long pos=ftell(file)-shift;
  fseek(file,0L,SEEK_SET);
  return pos;
}

SignalStream::SignalStream() { 
  Channels=0; 
  SamplingFrequency=128.0F; 
  Position=0L; 
  file=0; 
  shift=0;
}

void SignalStream::info() {
  fprintf(stdout,
	  "Sampling Frequency: %f\n"
	  "Calibration:        %f\n"
	  "Channels:           %d\n",SamplingFrequency,
	  Calibration,Channels);
}

// ---------------------------------------------------------------------

int RawSignalStream::open(const char *filename) {
  close();
  if((file=fopen(filename,"rb"))==NULL) 
    return -1;
  buff=new short[Channels];
  MaxOffset=filelength()/(Channels*sizeof(short));
  return 0;
}

void RawSignalStream::close() {
  if(file!=0) {
    fclose(file); 
    file=0;
  }
  if(buff!=0) {
    delete []buff;
    buff=0;
  }
}

int RawSignalStream::seek(long pos) {
  if(Channels==0) 
    return -1;
  const long maxPos=filelength()/(Channels*sizeof(short));
  if(pos<0L || pos>maxPos) 
    return -1;
  fseek(file,pos*Channels*sizeof(short)+shift,SEEK_SET);
  return 0;
}

int RawSignalStream::read(float s[]) {
  if(fread((void *)buff,Channels*sizeof(short),1,file)!=1)
    return -1;
#ifdef NOINTEL
  swab((const void *)buff,(void *)buff,Channels*sizeof(short));
#endif
  for(int i=0 ; i<Channels ; i++)
    s[i]=float(buff[i]);
  return 0;
}

int RawSignalStream::read(float s[],long pos) {
  if(seek(pos)==-1)
    return -1;
  return read(s);
}

// -------------------------------------------------------------------

int RawFloatSignalStream::open(const char *filename) {
  close();
  if((file=fopen(filename,"rb"))==NULL) 
    return -1;
  MaxOffset=filelength()/(Channels*sizeof(float));
  return 0;
}

void RawFloatSignalStream::close() {
  if(file!=0) {
    fclose(file); 
    file=0;
  }
}

int RawFloatSignalStream::seek(long pos) {
  if(Channels==0) 
    return -1;
  const long maxPos=filelength()/(Channels*sizeof(float));
  if(pos<0L || pos>maxPos) 
    return -1;
  fseek(file,pos*Channels*sizeof(float)+shift,SEEK_SET);
  return 0;
}

int RawFloatSignalStream::read(float s[]) {
#ifdef INTELSWP
  if(fread((void *)s,Channels*sizeof(float),1,file)!=1) return -1;
#else
  for(int i=0 ; i<Channels ; i++)
    if(ReadFloat(file,&s[i])==-1)
      return -1;
#endif
  return 0;
}

int RawFloatSignalStream::read(float s[],long pos) {
  if(seek(pos)==-1) return -1;
  return read(s);
}

// ----------------------------------------------------------------------

void AsciiSignalStream::close() {
  if(file!=0) {
    fclose(file); 
    file=0;
  }
  MaxOffset=0;
}

int AsciiSignalStream::open(const char *filename) {
  if((file=fopen(filename,"rt"))==NULL) 
    return -1;
  
  MaxOffset=0L;
  while(!feof(file)) {
    fscanf(file,"%*[^\n]\n");
    MaxOffset++;
  }

  fseek(file,0L,SEEK_SET);
  return 0;
}

int AsciiSignalStream::seek(long pos) {
  if(pos<0L || pos>MaxOffset)
    return -1;
  fseek(file,shift,SEEK_SET);
  for(long i=0 ; i<pos ; i++)
    fscanf(file,"%*[^\n]\n");
  return 0;
}

int AsciiSignalStream::read(float s[]) {
  const int max=Channels-1;
  for(int i=0 ; i<max ; i++)
    if(fscanf(file,"%f ",&s[i])!=1)
      return -1;
  if(fscanf(file,"%f\n",&s[max])!=1)
    return -1;
  return 0;
}

int AsciiSignalStream::read(float s[],long pos) {
  if(seek(pos)==-1)
    return -1;
  return read(s);
}


