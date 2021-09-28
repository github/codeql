using System;
using System.Linq;

class ModulusAnalysis
{
    const int c1 = 42;
    const int c2 = 43;

    void M(int i, bool cond1, bool cond2, bool cond3, int x, int y, int[] arr, int otherSeven)
    {
        var eq = i + 3;

        var mul = eq * c1 + 3; // congruent 3 mod 42

        int seven = 7;
        if (mul % c2 == seven)
        {
            System.Console.WriteLine(mul); // congruent 7 mod 43, 3 mod 42
        }

        if (otherSeven == 7)
        {
            if (mul % c2 == otherSeven)
            {
                System.Console.WriteLine(mul); // congruent 3 mod 42, 7 mod 43 missing
            }
        }

        var j = cond1
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

        var l = arr.Length * 4 - 11; // congruent 1 mod 4
        System.Console.WriteLine(l);

        l = GetArray().Length * 4 - 11;
        System.Console.WriteLine(l); // congruent 1 mod 4

        if (cond2)
        {
            j = i * 4 + 3;
        }
        else
        {
            j = i * 8 + 7;
        }
        System.Console.WriteLine(j); // congruent 3 mod 4 (cond = true) or 7 mod 8 (cond = false)

        if (cond2)
        {
            System.Console.WriteLine(j); // congruent 3 mod 4
        }
        else
        {
            System.Console.WriteLine(j); // congruent 7 mod 8
        }

        var t = 64;
        System.Console.WriteLine(t & 32); // congruent 0 mod 32
        System.Console.WriteLine(t & 16); // congruent 0 mod 16
        t = 1;
        System.Console.WriteLine(t << 2); // congruent 0 mod 4

        if ((x & 15) == 3)
        {
            System.Console.WriteLine(x); // congruent 3 mod 16
        }

        j = cond3
            ? i * 4 + 3
            : i * 8 + 7;
        if (!cond3)
            System.Console.WriteLine(j); // congruent 7 mod 8
    }

    void For(int cap)
    {
        for (var i = 0; i < cap; i++)
            System.Console.WriteLine(i);

        for (var j = 0; j < cap; j += 1)
            System.Console.WriteLine(j);

        for (var k = 0; k < cap; k += 3)
            System.Console.WriteLine(k); // congruent 0 mod 3
    }

    int[] GetArray() { return new int[42]; }
}