using System;
using System.Threading;

class Deadlock
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
            lock (lock2)    // Deadlock here
            {
            }
        }
    }

    public void thread2()
    {
        lock (lock2)
        {
            Console.Out.WriteLine("Thread 2 acquired lock2");
            Thread.Sleep(10);
            Console.Out.WriteLine("Thread 2 waiting on lock1");
            lock (lock1)    // Deadlock here
            {
            }
        }
    }
}
