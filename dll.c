/*
 * dll.c
 *
 * Description:
 * This translation unit implements DLL initialisation.
 *
 * Pthreads-win32 - POSIX Threads Library for Win32
 * Copyright (C) 1998
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the Free
 * Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
 * MA 02111-1307, USA
 */

#include <malloc.h>
#include "pthread.h"
#include "implement.h"


/* 
 * Function pointer to TryEnterCriticalSection if it exists; otherwise NULL 
 */
BOOL (WINAPI *_pthread_try_enter_critical_section)(LPCRITICAL_SECTION) = NULL;

/*
 * We use this to double-check that TryEnterCriticalSection works.
 */
CRITICAL_SECTION cs;

/*
 * Handle to kernel32.dll 
 */
static HINSTANCE _pthread_h_kernel32;


#ifdef _MSC_VER
/* 
 * lpvReserved yields an unreferenced formal parameter;
 * ignore it
 */
#pragma warning( disable : 4100 )
#endif

#ifdef __cplusplus
/*
 * Dear c++: Please don't mangle this name. -thanks
 */
extern "C"
{
#endif /* __cplusplus */

  BOOL WINAPI DllMain( HINSTANCE, DWORD, LPVOID);

#ifdef __cplusplus
}
#endif /* __cplusplus */

BOOL WINAPI
DllMain (
	  HINSTANCE hinstDll,
	  DWORD fdwReason,
	  LPVOID lpvReserved
)
{
  BOOL result = TRUE;

  switch (fdwReason)
    {

    case DLL_PROCESS_ATTACH:
      /*
       * The DLL is being mapped into the process's address space
       */
      result = _pthread_processInitialize ();

      /* Load KERNEL32 and try to get address of TryEnterCriticalSection */
      _pthread_h_kernel32 = LoadLibrary(TEXT("KERNEL32.DLL"));
      _pthread_try_enter_critical_section =
	(BOOL (PT_STDCALL *)(LPCRITICAL_SECTION))
	GetProcAddress(_pthread_h_kernel32,
		       (LPCSTR) "TryEnterCriticalSection");

      if (_pthread_try_enter_critical_section != NULL)
        {
          InitializeCriticalSection(&cs);
          if ((*_pthread_try_enter_critical_section)(&cs))
            {
              LeaveCriticalSection(&cs);
            }
          else
            {
              /*
               * Not really supported (Win98?).
               */
              _pthread_try_enter_critical_section = NULL;
            }
          DeleteCriticalSection(&cs);
        }
      break;

    case DLL_THREAD_ATTACH:
      /*
       * A thread is being created
       */
      result = TRUE;
      break;

    case DLL_THREAD_DETACH:
    case DLL_PROCESS_DETACH:
      /*
       * A thread is exiting cleanly
       * NOTE: The "main" thread detaches using
       *               DLL_PROCESS_DETACH
       */
      {
	pthread_t self;

	if (_pthread_processInitialized)
	  {
	    self = (pthread_t) pthread_getspecific (_pthread_selfThreadKey);

	    /*
	     * Detached threads have their resources automatically
	     * cleaned up upon exit (others must be 'joined'
	     */
	    if (self != NULL &&
		self->detachState == PTHREAD_CREATE_DETACHED)
	      {

		pthread_setspecific (_pthread_selfThreadKey, NULL);

		_pthread_threadDestroy (self);
	      }

	    if (fdwReason == DLL_PROCESS_DETACH)
	      {
		/*
		 * The DLL is being unmapped into the process's address space
		 */
		_pthread_processTerminate ();

		(void) FreeLibrary(_pthread_h_kernel32);
	      }
	  }

	result = TRUE;
      }
      break;
    }
  return (result);

}				/* DllMain */
