using System;
using System.Threading;

class DeadlockFixed
{
    private readonly Object lock1 = new Object();
    private readonly Object lock2 = new Object();

    public void thread1()
    {
        lock (lock1)
        {
            Console.Out.WriteLine("Thread 1 acquired lock1");
            Thread.Sleep(10);
            Console.Out.WriteLine("Thread 1 waiting on lock2");
            lock (lock2)
            {
            }
        }
    }

    public void thread2()
    {
        lock (lock1)    // Fixed
        {
            Console.Out.WriteLine("Thread 2 acquired lock1");
            Thread.Sleep(10);
            Console.Out.WriteLine("Thread 2 waiting on lock2");
            lock (lock2)    // Fixed
            {
            }
        }
    }
}
