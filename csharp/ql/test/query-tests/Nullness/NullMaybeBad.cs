using System;

class Bad
{
    void DoPrint(object o)
    {
        Console.WriteLine(o.ToString()); // $ Alert[cs/dereferenced-value-may-be-null]
    }

    void M()
    {
        DoPrint("Hello");
        DoPrint(null); // $ Source[cs/dereferenced-value-may-be-null]
    }
}
