/* 
 * test.h
 *
 * Useful definitions and declarations for tests.
 */

#ifndef _PTHREAD_TEST_H_
#define _PTHREAD_TEST_H_

#include <pthread.h>
#include <stdio.h>

char * error_string[] = {
  "ZERO",
  "EPERM",
  "ENOFILE_or_ENOENT",
  "ESRCH",
  "EINTR",
  "EIO",
  "ENXIO",
  "E2BIG",
  "ENOEXEC",
  "EBADF",
  "ECHILD",
  "EAGAIN",
  "ENOMEM",
  "EACCES",
  "EFAULT",
  "UNKNOWN_15",
  "EBUSY",
  "EEXIST",
  "EXDEV",
  "ENODEV",
  "ENOTDIR",
  "EISDIR",
  "EINVAL",
  "ENFILE",
  "EMFILE",
  "ENOTTY",
  "UNKNOWN_26",
  "EFBIG",
  "ENOSPC",
  "ESPIPE",
  "EROFS",
  "EMLINK",
  "EPIPE",
  "EDOM",
  "ERANGE",
  "UNKNOWN_35",
  "EDEADLOCK_or_EDEADLK",
  "UNKNOWN_37",
  "ENAMETOOLONG",
  "ENOLCK",
  "ENOSYS",
  "ENOTEMPTY",
  "EILSEQ",
};

/*
 * The Mingw32 assert macro calls the CRTDLL _assert function
 * which pops up a dialog. We want to run in batch mode so
 * we define our own assert macro.
 */
#ifdef NDEBUG

#define assert(e) ((void)0)

#else /* NDEBUG */

#ifdef assert
# undef assert
#endif

#ifndef ASSERT_TRACE
#define ASSERT_TRACE 0
#endif

#define assert(e) \
  ((e) ? ((ASSERT_TRACE) ? fprintf(stderr, \
                                   "Assertion succeeded: (%s), file %s, line %d\n", \
			           #e, __FILE__, (int) __LINE__), \
	                           fflush(stderr) : \
                            (void) 0) : \
         (fprintf(stderr, "Assertion failed: (%s), file %s, line %d\n", \
                  #e, __FILE__, (int) __LINE__), exit(1)))

#endif /* NDEBUG */


#endif
