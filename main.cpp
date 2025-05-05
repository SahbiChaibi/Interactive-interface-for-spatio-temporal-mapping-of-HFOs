// 2000-02-19

#include <iostream.h>
#include <fstream.h>
#include <stdio.h>
#include <string.h>
#ifndef WIN32
#include <signal.h>
#endif
#include "GaborFactory.h"

extern int debug,quiet;

class CXXShell : public Shell {
public:
  CXXShell(int sig=512,int dic=70000,istream &in=cin,ostream &out=cout) :
    Shell(sig,dic,in,out) { ; }
  int exec();
}; 

int CXXShell::exec() {
  const int BUFFSIZE=256;
  char buff[BUFFSIZE],comm[BUFFSIZE],options[BUFFSIZE];

  if(!quiet) {
    out << "MP4> ";
    out.flush();
  }

  while(in.getline(buff,BUFFSIZE)) {
    comm[0]=options[0]='\0';
    int n=sscanf(buff,"%s %[^\n]s",comm,options);
    if(n==0)
      continue;
    else if(n==1) {
      options[0]='\0';
    }

    if(strlen(comm)!=0) {
      if(comm[0]=='#')
	continue;

      if(strcmp(comm,"exit")==0 || strcmp(comm,"quit")==0)
	break;
      else if(strcmp(comm,"sys")==0) {
	system(options);
      } else {
	if(exec_command(comm,options)==-1)
	  out << "ERROR !\n";
      }
    }

    if(!quiet) {
      out << "MP4> "; 
      out.flush();
    }
  }
  return 0;
}

int main(int argc,char *argv[]) {
  const int DEFAULT_SIG_SIZE=512,DEFAULT_DIC_SIZE=100000;
  char *filename=0;
  int i,code;

  for(i=1 ; i<argc ; i++)
    if(strcmp(argv[i],"--help")==0 || strcmp(argv[i],"-help")==0) {
      cout << argv[0] << " [--help] [-help] [-debug] [-q] [filename]\n";
      return 0;
    } else if(strcmp(argv[i],"-debug")==0 || strcmp(argv[i],"--debug")==0) {
      debug=1;
    } else if(strcmp(argv[i],"-q")==0) {
      quiet=1;
    } else {
      filename=argv[i];
    }

#ifndef WIN32
  signal(SIGCLD,SIG_IGN);
#endif

  if(!quiet) {
    cout << "\nMatching Pursuit IV (version 2001-03-20)\n\n";
    cout << "Compiled: " << __DATE__ << " " << __TIME__ << endl;
#ifdef __VERSION__
    cout << "Compiler: "<< __VERSION__ << endl;
#endif
    cout << endl;
  }

  if(filename!=0) {
    ifstream stream(filename);
    if(!stream) {
      cerr << "file not found !\n";
      return 1;
    }

    CXXShell *shell=new CXXShell(DEFAULT_SIG_SIZE,DEFAULT_DIC_SIZE,stream);
    code=shell->exec();
    delete shell;
    return code;
  }

  CXXShell *shell=new CXXShell(DEFAULT_SIG_SIZE,DEFAULT_DIC_SIZE);
  code=shell->exec();
  delete shell;
  return code;
}


