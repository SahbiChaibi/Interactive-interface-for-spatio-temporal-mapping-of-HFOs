/*
 * cleanup.c
 *
 * Description:
 * This translation unit implements routines associated cleaning up
 * threads.
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

#if !defined(_MSC_VER) && !defined(__cplusplus) && defined(__GNUC__)

#warning Compile __FILE__ as C++ or thread cancellation will not work properly.

#endif /* !_MSC_VER && !__cplusplus && __GNUC__ */

#include "pthread.h"
#include "implement.h"

_pthread_cleanup_t *
pthread_pop_cleanup (int execute)
     /*
      * ------------------------------------------------------
      * DOCPUBLIC
      *      This function pops the most recently pushed cleanup
      *      handler. If execute is nonzero, then the cleanup handler
      *      is executed if non-null.
      *
      * PARAMETERS
      *      execute
      *              if nonzero, execute the cleanup handler
      *
      *
      * DESCRIPTION
      *      This function pops the most recently pushed cleanup
      *      handler. If execute is nonzero, then the cleanup handler
      *      is executed if non-null.
      *      NOTE: specify 'execute' as nonzero to avoid duplication
      *                of common cleanup code.
      *
      * RESULTS
      *              N/A
      *
      * ------------------------------------------------------
      */
{
  _pthread_cleanup_t *cleanup;
  
  cleanup = (_pthread_cleanup_t *) pthread_getspecific (_pthread_cleanupKey);

  if (cleanup != NULL)
    {
      if (execute && (cleanup->routine != NULL))
        {

#ifdef _MSC_VER

          __try
	    {
	      /*
	       * Run the caller's cleanup routine.
	       */
	      (*cleanup->routine) (cleanup->arg);
	    }
          __except (EXCEPTION_EXECUTE_HANDLER)
	    {
	      /*
	       * A system unexpected exception had occurred
	       * running the user's cleanup routine.
	       * We get control back within this block.
	       */
	    }
      
#else /* _MSC_VER */

#ifdef __cplusplus

	  try
	    {
	      /*
	       * Run the caller's cleanup routine.
	       */
	      (*cleanup->routine) (cleanup->arg);
	    }
	  catch(...)
	    {
	      /*
	       * A system unexpected exception had occurred
	       * running the user's cleanup routine.
	       * We get control back within this block.
	       */
	    }

#else /* __cplusplus */
      
	  /*
	   * Run the caller's cleanup routine and FIXME: hope for the best.
	   */
	  (*cleanup->routine) (cleanup->arg);

#endif /* __cplusplus */

#endif /* _MSC_VER */

        }

#if !defined(_MSC_VER) && !defined(__cplusplus)

      pthread_setspecific (_pthread_cleanupKey, (void *) cleanup->prev);

#endif /* !_MSC_VER && !__cplusplus */

    }

  return (cleanup);

}                               /* _pthread_pop_cleanup */


void
pthread_push_cleanup (_pthread_cleanup_t * cleanup,
		      void (*routine) (void *),
		      void *arg)
     /*
      * ------------------------------------------------------
      * DOCPUBLIC
      *      This function pushes a new cleanup handler onto the thread's stack
      *      of cleanup handlers. Each cleanup handler pushed onto the stack is
      *      popped and invoked with the argument 'arg' when
      *              a) the thread exits by calling 'pthread_exit',
      *              b) when the thread acts on a cancellation request,
      *              c) or when the thrad calls pthread_cleanup_pop with a nonzero
      *                 'execute' argument
      *
      * PARAMETERS
      *      cleanup
      *              a pointer to an instance of pthread_cleanup_t,
      *
      *      routine
      *              pointer to a cleanup handler,
      *
      *      arg
      *              parameter to be passed to the cleanup handler
      *
      *
      * DESCRIPTION
      *      This function pushes a new cleanup handler onto the thread's stack
      *      of cleanup handlers. Each cleanup handler pushed onto the stack is
      *      popped and invoked with the argument 'arg' when
      *              a) the thread exits by calling 'pthread_exit',
      *              b) when the thread acts on a cancellation request,
      *              c) or when the thrad calls pthread_cleanup_pop with a nonzero
      *                 'execute' argument
      *      NOTE: pthread_push_cleanup, pthread_pop_cleanup must be paired
      *                in the same lexical scope.
      *
      * RESULTS
      *              pthread_cleanup_t *
      *                              pointer to the previous cleanup
      *
      * ------------------------------------------------------
      */
{
  cleanup->routine = routine;
  cleanup->arg = arg;

#if !defined(_MSC_VER) && !defined(__cplusplus)

  cleanup->prev = (_pthread_cleanup_t *) pthread_getspecific (_pthread_cleanupKey);

#endif /* !_MSC_VER && !__cplusplus */

  pthread_setspecific (_pthread_cleanupKey, (void *) cleanup);

}                               /* _pthread_push_cleanup */


