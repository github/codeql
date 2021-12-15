using System;

class RedundantToString
{
    public void M(object o)
    {
        Console.WriteLine(o.ToString()); // BAD
        Console.WriteLine(o); // GOOD

        Console.WriteLine($"Hello: {o.ToString()}"); // BAD
        Console.WriteLine($"Hello: {o}"); // GOOD
    }
}
