using System;

class Program
{
    Object lck = new Object();

    void f()
    {
        lock (this)  // Not OK
        {
        }

        lock (lck)   // OK
        {
        }
    }
}
