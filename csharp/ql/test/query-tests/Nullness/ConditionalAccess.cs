using System;
using System.ComponentModel;

class ConditionalAccessTest
{
    void M1(object o)
    {
        var t = o?.GetType();
        Console.WriteLine(t.FullName); // $ Alert[cs/dereferenced-value-may-be-null]
    }
}
