/*
 * File: 
 *
 * Test Synopsis:
 * - Test pthread_cond_broadcast.
 *
 * Test Method (Validation or Falsification):
 * - Validation
 *
 * Requirements Tested:
 * - 
 *
 * Features Tested:
 * - 
 *
 * Cases Tested:
 * - 
 *
 * Description:
 * - Test broadcast with NUMTHREADS (=5) waiting CVs.
 *
 * Environment:
 * - 
 *
 * Input:
 * - None.
 *
 * Output:
 * - File name, Line number, and failed expression on failure.
 * - No output on success.
 *
 * Assumptions:
 * - 
 *
 * Pass Criteria:
 * - Process returns zero exit status.
 *
 * Fail Criteria:
 * - Process returns non-zero exit status.
 */

#include "test.h"
#include <sys/timeb.h>

/*
 * Create NUMTHREADS threads in addition to the Main thread.
 */
enum {
  NUMTHREADS = 5
};

typedef struct bag_t_ bag_t;
struct bag_t_ {
  int threadnum;
  int started;
  /* Add more per-thread state variables here */
};

static bag_t threadbag[NUMTHREADS + 1];

typedef struct cvthing_t_ cvthing_t;

struct cvthing_t_ {
  pthread_cond_t notbusy;
  pthread_mutex_t lock;
  int shared;
};

static cvthing_t cvthing = {
  PTHREAD_COND_INITIALIZER,
  PTHREAD_MUTEX_INITIALIZER,
  0
};

static pthread_mutex_t start_flag = PTHREAD_MUTEX_INITIALIZER;

static struct timespec abstime = { 0, 0 };

static int awoken;

void *
mythread(void * arg)
{
  bag_t * bag = (bag_t *) arg;

  assert(bag == &threadbag[bag->threadnum]);
  assert(bag->started == 0);
  bag->started = 1;

  /* Wait for the start gun */
  assert(pthread_mutex_lock(&start_flag) == 0);
  assert(pthread_mutex_unlock(&start_flag) == 0);

  assert(pthread_mutex_lock(&cvthing.lock) == 0);

  while (! cvthing.shared > 0)
    assert(pthread_cond_timedwait(&cvthing.notbusy, &cvthing.lock, &abstime) == 0);

  assert(cvthing.shared > 0);

  awoken++;

  assert(pthread_mutex_unlock(&cvthing.lock) == 0);

  return 0;
}

int
main()
{
  int failed = 0;
  int i;
  pthread_t t[NUMTHREADS + 1];

#if defined(__MINGW32__)
  struct timeb currSysTime;
#else
  struct _timeb currSysTime;
#endif
  const DWORD NANOSEC_PER_MILLISEC = 1000000;

  cvthing.shared = 0;

  assert((t[0] = pthread_self()) != NULL);

  assert(cvthing.notbusy == PTHREAD_COND_INITIALIZER);

  assert(cvthing.lock == PTHREAD_MUTEX_INITIALIZER);

  assert(pthread_mutex_lock(&start_flag) == 0);

  _ftime(&currSysTime);

  abstime.tv_sec = currSysTime.time;
  abstime.tv_nsec = NANOSEC_PER_MILLISEC * currSysTime.millitm;

  abstime.tv_sec += 5;

  assert((t[0] = pthread_self()) != NULL);

  awoken = 0;

  for (i = 1; i <= NUMTHREADS; i++)
    {
      threadbag[i].started = 0;
      threadbag[i].threadnum = i;
      assert(pthread_create(&t[i], NULL, mythread, (void *) &threadbag[i]) == 0);
    }

  /*
   * Code to control or munipulate child threads should probably go here.
   */

  assert(pthread_mutex_unlock(&start_flag) == 0);

  /*
   * Give threads time to start.
   */
  Sleep(2000);

  assert(pthread_mutex_lock(&cvthing.lock) == 0);

  cvthing.shared++;

  assert(pthread_mutex_unlock(&cvthing.lock) == 0);

  assert(pthread_cond_broadcast(&cvthing.notbusy) == 0);

  /*
   * Give threads time to complete.
   */
  Sleep(2000);

  /* 
   * Cleanup the CV.
   */
  
  assert(pthread_mutex_destroy(&cvthing.lock) == 0);

  assert(cvthing.lock == NULL);

  assert(pthread_cond_destroy(&cvthing.notbusy) == 0);

  assert(cvthing.notbusy == NULL);

  /*
   * Standard check that all threads started.
   */
  for (i = 1; i <= NUMTHREADS; i++)
    { 
      failed = !threadbag[i].started;

      if (failed)
	{
	  fprintf(stderr, "Thread %d: started %d\n", i, threadbag[i].started);
	}
    }

  assert(!failed);

  /*
   * Check any results here.
   */

  assert(awoken == NUMTHREADS);

  /*
   * Success.
   */
  return 0;
}


