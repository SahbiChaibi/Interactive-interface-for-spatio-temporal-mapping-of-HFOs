/*
 * count1.c
 *
 * Description:
 * Test some basic assertions about the number of threads at runtime.
 */

#include "test.h"

#define NUMTHREADS (60)

static pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
static pthread_t threads[NUMTHREADS];
static unsigned numThreads = 0;

void *
myfunc(void *arg)
{
  pthread_mutex_lock(&lock);
  numThreads++;
  pthread_mutex_unlock(&lock);

  Sleep(1000);
  return 0;
}
int
main()
{
  int i;
  int maxThreads = sizeof(threads) / sizeof(pthread_t);

  /*
   * Spawn NUMTHREADS threads. Each thread should increment the
   * numThreads variable, sleep for one second.
   */
  for (i = 0; i < maxThreads; i++)
    {
      assert(pthread_create(&threads[i], NULL, myfunc, 0) == 0);
    }
  
  /*
   * Wait for all the threads to exit.
   */
  for (i = 0; i < maxThreads; i++)
    {
      assert(pthread_join(threads[i], NULL) == 0);
    }

  /* 
   * Check the number of threads created.
   */
  assert(numThreads == maxThreads);
  
  /*
   * Success.
   */
  return 0;
}
