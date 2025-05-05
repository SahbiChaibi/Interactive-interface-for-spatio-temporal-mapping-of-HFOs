TMAKE_LFLAGS    = -s
TMAKE_CXXFLAGS  = -pedantic -O6 -fno-exceptions -DINTELSWP -DNO_DEBUG -DLINUX -malign-double -ffast-math
TMAKE_CFLAGS	= -Wall -O6 -march=pentiumpro -DINTELSWP -DNODEBUG -malign-double -ffast-math

LIBS            = -lpthread
OBJECTS_DIR     = ./obj
TEMPLATE	= app 
CONFIG		= warn_on
DESTDIR         = ./bin
TARGET		= mp4
TMAKE_LFLAGS    = -s 

HEADERS         = FileFormats.h \
                  GaborFactory.h \
                  Vector.h \
                  new_io.h
SOURCES         = FileFormats.cpp \
                  GaborFactory.cpp \
                  Shell.cpp \
                  new_io.c \
	   	  orgfft.c main.cpp iosignal.cpp
