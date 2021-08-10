using System;

public class Program
{
    public static void Main()
    {
        var x = (1, 2);
        Console.WriteLine(x.GetType());
        x = new ValueTuple<int, int>(1, 2);
        Console.WriteLine(x.GetType());

        var y = (1, 2, 3, 4, 5, 6, 7);
        Console.WriteLine(y.GetType());

        var z = (1, 2, 3, 4, 5, 6, 7, 8);
        Console.WriteLine(z.GetType());

        var w = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
        Console.WriteLine(w.GetType());
    }
}