using System;

class Program
{
    Object lck = new Object();

    void f()
    {
        lock (this)  // $ Alert // Not OK
        {
        }

        lock (lck)   // OK
        {
        }
    }
}
