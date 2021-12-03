using System;
using System.Runtime.CompilerServices;

class Program
{
    static object lock1 = new Object(), lock2 = new Object();

    static void Main()
    {
        lock (lock1)
        {
            System.Threading.Monitor.Wait(lock1); // GOOD
        }

        lock (lock1)
        {
            lock (lock1)
            {
                System.Threading.Monitor.Wait(lock1); // GOOD
            }
        }

        lock (lock1)
        {
            System.Threading.Monitor.Wait(lock2); // BAD
        }

        lock (lock1)
        {
            lock (lock2)
            {
                System.Threading.Monitor.Wait(lock2); // BAD
            }
        }

        lock (lock1)
        {
            lock (lock2)
            {
                System.Threading.Monitor.Wait(lock1); // BAD
            }
        }
    }

    [MethodImpl(MethodImplOptions.Synchronized)]
    void Lock2()
    {
        System.Threading.Monitor.Wait(lock1);  // BAD
        System.Threading.Monitor.Wait(this);   // GOOD
        System.Threading.Monitor.Wait(typeof(Program)); // BAD
        System.Threading.Monitor.Wait(typeof(Int32)); // BAD
        lock (lock1)
        {
            System.Threading.Monitor.Wait(lock1); // BAD
        }
    }

    [MethodImpl(MethodImplOptions.Synchronized)]
    static void Lock3()
    {
        lock (lock1)
        {
            System.Threading.Monitor.Wait(lock1); // BAD
        }
        System.Threading.Monitor.Wait(lock1); // BAD
        System.Threading.Monitor.Wait(typeof(Program)); // GOOD
        System.Threading.Monitor.Wait(typeof(Int32)); // BAD
    }

    void Lock4()
    {
        lock (this)
        {
            System.Threading.Monitor.Wait(typeof(Program)); // BAD
            System.Threading.Monitor.Wait(this);  // GOOD
            System.Threading.Monitor.Wait(lock1); // BAD
        }

        lock (typeof(Program))
        {
            System.Threading.Monitor.Wait(typeof(Program)); // GOOD
            System.Threading.Monitor.Wait(this);  // BAD
            System.Threading.Monitor.Wait(lock1); // BAD
            System.Threading.Monitor.Wait(typeof(Int32));  // BAD
        }
    }
}
