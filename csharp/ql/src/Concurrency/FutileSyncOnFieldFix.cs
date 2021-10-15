using System;

class Adder
{
    dynamic total = 0;

    private readonly Object mutex = new Object();

    public void AddItem(int item)
    {
        lock (mutex)    // Fixed
        {
            total = total + item;
        }
    }
}
