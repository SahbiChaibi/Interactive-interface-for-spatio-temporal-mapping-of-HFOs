#!/bin/sh
echo static program
awk ' $1=="LFLAGS" { print $0," -static" }\
      $1=="TARGET" { print $0 ".static" }\
      $1=="LIBS"   { print "LIBS	= -lpthread" } \
      $1!="TARGET" && $1!="LFLAGS" && $1!="LIBS" { print $0 } ' Makefile > Makefile.static
echo Done.
