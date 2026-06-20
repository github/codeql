using System;
using System.Text;

class RedundantToString
{
    public void M(object o)
    {
        Console.WriteLine(o.ToString()); // $ Alert
        Console.WriteLine(o); // GOOD

        Console.WriteLine($"Hello: {o.ToString()}"); // $ Alert
        Console.WriteLine($"Hello: {o}"); // GOOD

        Console.WriteLine("Hello: " + o.ToString()); // $ Alert
        Console.WriteLine("Hello: " + o); // GOOD

        var sb = new StringBuilder();
        sb.Append(o.ToString()); // $ Alert
        sb.Append(o); // GOOD
        sb.AppendLine(o.ToString()); // GOOD

        Console.WriteLine($"Hello: {base.ToString()}"); // GOOD
    }
}
