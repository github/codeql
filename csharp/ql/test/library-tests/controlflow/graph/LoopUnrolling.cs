using System;
using System.Collections.Generic;
using System.Linq;

class LoopUnrolling
{
    void M1(string[] args)
    {
        if (args.Length == 0)
            return;
        foreach (var arg in args) // unroll
            Console.WriteLine(arg);
    }

    void M2()
    {
        var xs = new string[] { "a", "b", "c" };
        foreach (var x in xs) // unroll
            Console.WriteLine(x);
    }

    void M3(string args)
    {
        foreach (var arg in args) // no unroll
            foreach (var arg0 in args) // unroll
                Console.WriteLine(arg0);
    }

    void M4()
    {
        var xs = new string[0];
        foreach (var x in xs) // no unroll
            Console.WriteLine(x);
    }

    void M5()
    {
        var xs = new string[] { "a", "b", "c" };
        var ys = new string[] { "0", "1", "2" };
        foreach (var x in xs) // unroll
            foreach (var y in ys) // unroll
                Console.WriteLine(x + y);
    }

    void M6()
    {
        var xs = new string[] { "a", "b", "c" };
        foreach (var x in xs) // unroll
        {
        Label: Console.WriteLine(x);
            goto Label;
        }
    }

    void M7(bool b)
    {
        var xs = new string[] { "a", "b", "c" };
        foreach (var x in xs) // unroll
        {
            if (b)
                Console.WriteLine(x);
            if (b)
                Console.WriteLine(x);
        }
    }

    void M8(List<string> args)
    {
        if (!args.Any())
            return;
        args.Clear();
        foreach (var arg in args) // no unroll
            Console.WriteLine(arg);
    }

    void M9()
    {
        var xs = new string[2, 0];
        foreach (var x in xs) // unroll [MISSING]
        {
            foreach (var y in x) // no unroll
            {
                Console.WriteLine(y);
            }
        }
    }

    void M10()
    {
        var xs = new string[0, 2];
        foreach (var x in xs) // no unroll
        {
            foreach (var y in x) // no unroll
            {
                Console.WriteLine(y);
            }
        }
    }

    void M11()
    {
        var xs = new string[2, 2];
        foreach (var x in xs) // unroll
        {
            foreach (var y in x) // unroll [MISSING]
            {
                Console.WriteLine(y);
            }
        }
    }
}
