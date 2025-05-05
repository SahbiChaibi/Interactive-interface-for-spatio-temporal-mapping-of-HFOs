// 1999 03 24

#ifndef FILE_FORMATS_H
#define FILE_FORMATS_H

#include <stdio.h>

class SignalStream {
protected:
  int   Channels,shift;
  float SamplingFrequency,Calibration;
  long Position;
  FILE *file;
  long filelength();
  long MaxOffset;
  
public:
  SignalStream();
  virtual ~SignalStream() { if(file!=0) fclose(file); }
  virtual int  getChannels() const  { return Channels; }
  virtual int  open(const char *)=0;
  virtual void close()=0;
  virtual int  seek(long)=0;
  virtual int  read(float *,long)=0;
  virtual int  read(float *)=0;
  
  void  setChannels(int chn) { Channels=chn; }
  void  setSamplingFrequency(float freq) { SamplingFrequency=freq; }
  float getSamplingFrequency() const    { return SamplingFrequency; } 
  void  setCalibration(float calib) { Calibration=calib; }
  float getCalibration() const { return Calibration; }
  long  Time2Pos(float);
  float Pos2Time(long);
  void  info();
  long  getMaxOffset() { return MaxOffset; }
};

inline long SignalStream::Time2Pos(float sec) {
  return long(sec*SamplingFrequency);
}

inline float SignalStream::Pos2Time(long pos) {
  return (SamplingFrequency<=0.0F) ? -1.0F : pos/SamplingFrequency;
}

class RawSignalStream : public SignalStream {
  short *buff;

public:
  RawSignalStream(int shift_=0)  { buff=0; MaxOffset=0L; shift=shift_; }
  ~RawSignalStream() { if(buff!=0) delete []buff; }
  int  open(const char *);
  void close();
  int  seek(long);
  int  read(float *,long);
  int  read(float *);
};

class RawFloatSignalStream : public SignalStream {
public:
  RawFloatSignalStream(int shift_=0)  { MaxOffset=0L; shift=shift_; }
  ~RawFloatSignalStream() { ; }
  int  open(const char *);
  void close();
  int  seek(long);
  int  read(float *,long);
  int  read(float *);
};

class AsciiSignalStream : public SignalStream {
public:
  AsciiSignalStream(int shift_=0)  { MaxOffset=0L; shift=shift_; }
  ~AsciiSignalStream() { ; }
  int  open(const char *);
  void close();
  int  seek(long);
  int  read(float *,long);
  int  read(float *);
};

#endif
















