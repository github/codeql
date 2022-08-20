using System;

class Tuples
{
    static void M1()
    {
        var o1 = Source<object>(1);
        var o2 = Source<object>(2);

        var x = (a: o1, (1, o2));
        var (a, (b, c)) = x;
        Sink(a);                // $ hasValueFlow=1
        Sink(b);
        Sink(c);                // $ hasValueFlow=2

        (a, (b, c)) = x;
        Sink(a);                // $ hasValueFlow=1
        Sink(b);
        Sink(c);                // $ hasValueFlow=2

        (var p, var q) = x;
        Sink(p);                // $ hasValueFlow=1
        Sink(q.Item1);
        Sink(q.Item2);          // $ hasValueFlow=2

        Sink(x.Item1);          // $ hasValueFlow=1
        Sink(x.a);              // $ hasValueFlow=1
        Sink(x.Item2.Item1);
        Sink(x.Item2.Item2);    // $ hasValueFlow=2
    }

    static void M2()
    {
        var o1 = Source<object>(3);
        var o2 = Source<object>(4);

        var x = (o1, 2, 3, 4, 5, 6, 7, 8, 9, o2);
        Sink(x.Item1);          // $ hasValueFlow=3
        Sink(x.Item2);
        Sink(x.Item10);         // $ hasValueFlow=4
    }

    static void M3()
    {
        var o = Source<string>(5);
        var x = (ValueTuple<string, int, int>)(o, 2, 3);
        Sink(x.Item1);          // $ hasValueFlow=5
        Sink(x.Item2);

        var y = (ValueTuple<object, int, int>)(o, 2, 3);
        Sink(y.Item1);          // $ MISSING: hasValueFlow=5
        Sink(y.Item2);
    }

    static void M4(string s)
    {
        var o1 = Source<string>(6);
        var o2 = Source<string>(7);
        var x = (o1, (2, o2), 3);
        switch (x)
        {
            case ValueTuple<string, (int, string), int> t when t.Item3 > 1:
                Sink(t.Item1);          // $ hasValueFlow=6
                Sink(t.Item2.Item2);    // $ hasValueFlow=7
                Sink(t.Item2.Item1);
                break;
            case var (a, (b, c), _):
                Sink(a);        // $ hasValueFlow=6
                Sink(c);        // $ hasValueFlow=7
                Sink(b);
                break;
        }

        var o3 = Source<string>(8);
        var y = (s, (2, s), 3);
        switch (y)
        {
            case (var a, var (b, c), _) when a == o3:
                Sink(y.Item1);          // $ MISSING: hasValueFlow=8
                Sink(y.Item2.Item2);    // $ MISSING: hasValueFlow=8
                Sink(c);                // $ MISSING: hasValueFlow=8
                Sink(y.Item2.Item1);
                Sink(b);
                break;
        }

        if (x is var (p, (q, r), _))
        {
            Sink(p);        // $ hasValueFlow=6
            Sink(r);        // $ hasValueFlow=7
            Sink(q);
        }
    }

    record R1(string i, int j) { };

    static void M5()
    {
        var o = Source<string>(9);
        var r = new R1(o, 1);
        Sink(r.i);          // $ hasValueFlow=9

        var (a, b) = r;
        Sink(a);            // $ MISSING: hasValueFlow=9
        Sink(b);

        switch (r)
        {
            case var (x, y):
                Sink(x);        // $ MISSING: hasValueFlow=9
                Sink(y);
                break;
        }
    }

    static void M6()
    {
        var o = Source<object>(9);

        int y1 = 0;
        (object x1, y1) = (o, 1);
        Sink(x1);               // $ hasValueFlow=9

        var x2 = new object();
        (x2, int y2) = (o, 1);
        Sink(x2);               // $ hasValueFlow=9

        var x3 = 0;
        (x3, object y3) = (1, o);
        Sink(y3);               // $ hasValueFlow=9

        var y4 = new object();
        (int x4, y4) = (1, o);
        Sink(y4);               // $ hasValueFlow=9
    }

    public static void Sink(object o) { }

    static T Source<T>(object source) => throw null;
}

namespace System.Runtime.CompilerServices
{
    public class IsExternalInit { }
}