using System;

class Folding
{
    static void Main(string[] args)
    {
        double d1 = (double)7;
        double d2 = 7.0 / 8.0;
        double d3 = 7 / 8;
        double d4 = (double)(7 / 8);

        float f1 = (float)7;
        float f2 = 7.0f / 8.0f;
        float f3 = 7 / 8;
        float f4 = (float)(7 / 8);

        int i1 = (int)7.0;
        int i2 = 7 / 8;
        int i3 = (int)(7.0 / 8.0);

        Console.WriteLine(d1);
        Console.WriteLine(d2);
        Console.WriteLine(d3);
        Console.WriteLine(d4);

        Console.WriteLine(f1);
        Console.WriteLine(f2);
        Console.WriteLine(f3);
        Console.WriteLine(f4);

        Console.WriteLine(i1);
        Console.WriteLine(i2);
        Console.WriteLine(i3);
    }
}
