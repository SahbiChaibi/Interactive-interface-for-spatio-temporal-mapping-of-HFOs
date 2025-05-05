#ifndef VECTOR_H
#define VECTOR_H

template<class T> class Vector {
  T *ptr;
  int size;

public:
  Vector() { ptr=0; size=0; }
  Vector(int size_) : size(size_) { ptr=new T[size]; }
  ~Vector() { if(ptr!=0) delete []ptr; }

  void resize(int size_) { 
    if(size_!=size) {
      if(ptr!=0)
	delete []ptr;

      size=size_;
      ptr=new T[size];
    }
  }

  T &operator[](int k) { return *(ptr+k); }
  T *getPtr() { return ptr; }
  int getsize() const { return size; }
};

#endif
