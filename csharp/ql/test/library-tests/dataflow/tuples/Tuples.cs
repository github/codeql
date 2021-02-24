using System;

class Tuples
{
    static void M1()
    {
        var x = (a: "taint source", (1, "taint source"));
        var (a, (b, c)) = x;
        Sink(a);                // Tainted
        Sink(b);
        Sink(c);                // Tainted

        (a, (b, c)) = x;
        Sink(a);                // Tainted
        Sink(b);
        Sink(c);                // Tainted

        (var p, var q) = x;
        Sink(p);                // Tainted
        Sink(q.Item1);
        Sink(q.Item2);          // Tainted

        Sink(x.Item1);          // Tainted
        Sink(x.a);              // Tainted
        Sink(x.Item2.Item1);
        Sink(x.Item2.Item2);    // Tainted
    }

    static void M2()
    {
        var x = ("taint source", 2, 3, 4, 5, 6, 7, 8, 9, "taint source");
        Sink(x.Item1);          // Tainted
        Sink(x.Item2);
        Sink(x.Item10);         // Tainted
    }

    static void M3()
    {
        var x = (ValueTuple<string, int, int>)("taint source", 2, 3);
        Sink(x.Item1);          // Tainted
        Sink(x.Item2);

        var y = (ValueTuple<object, int, int>)("taint source", 2, 3);
        Sink(y.Item1);          // Tainted, not found
        Sink(y.Item2);
    }

    static void M4()
    {
        var x = ("taint source", 2, 3);
        switch (x)
        {
            case ValueTuple<string, int, int> t when t.Item2 > 10:
                break;
            case var (a, b, _):
                Sink(a);        // Tainted, not found
                Sink(b);
                break;
        }
    }

    record R1(string i, int j) { };

    static void M5()
    {
        var r = new R1("taint source", 1);
        Sink(r.i);          // Tainted

        var (a, b) = r;
        Sink(a);            // Tainted, not found
        Sink(b);

        switch (r)
        {
            case var (x, y):
                Sink(x);        // Tainted, not found
                Sink(y);
                break;
        }
    }

    static void Sink<T>(T x) { }
}

namespace System.Runtime.CompilerServices
{
    public class IsExternalInit { }
}