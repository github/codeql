using System;
using System.Linq;

class ModulusAnalysis
{
    const int c1 = 42;
    const int c2 = 43;

    void M(int i, bool cond, int x, int y, int[] arr)
    {
        var eq = i + 3;

        var mul = eq * c1 + 3; // congruent 3 mod 42

        if (mul % c2 == 7)
        {
            System.Console.WriteLine(mul); // congruent 7 mod 43, 3 mod 42
        }

        var j = cond
            ? i * 4 + 3
            : i * 8 + 7;
        System.Console.WriteLine(j); // congruent 3 mod 4

        if (x % c1 == 3 && y % c1 == 7)
        {
            System.Console.WriteLine(x + y); // congruent 10 mod 42
        }

        if (x % c1 == 3 && y % c1 == 7)
        {
            System.Console.WriteLine(x - y); // congruent 38 mod 42
        }

        var l = arr.Length * 4 - 11;
        System.Console.WriteLine(l);
    }
}