using System;

class Bad3
{
    void Hello(string first, string last)
    {
        Console.WriteLine("Hello {0} {1}", first); // $ Alert
        Console.WriteLine("Hello {1} {2}", first, last); // $ Alert
    }
}
