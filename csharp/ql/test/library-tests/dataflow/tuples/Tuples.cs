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
        Sink(a);            // $ hasValueFlow=9
        Sink(b);

        switch (r)
        {
            case var (x, y):
                Sink(x);        // $ hasValueFlow=9
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

    static void M7()
    {
        var o1 = Source<string>(10);
        var o2 = Source<string>(11);
        var x = (o1, (2, o2), 3);
        switch (x)
        {
            case (var a1, (var b1, var c1), _):
                Sink(a1);        // $ hasValueFlow=10
                Sink(c1);        // $ hasValueFlow=11
                Sink(b1);
                break;
        }

        var o3 = Source<string>(12);
        var o4 = Source<string>(13);
        var y = (o3, (2, o4), 3);
        if (y is (var a2, var (b2, c2), _))
        {
            Sink(a2);        // $ hasValueFlow=12
            Sink(c2);        // $ hasValueFlow=13
            Sink(b2);
        }

        var o5 = Source<string>(14);
        var o6 = Source<string>(15);
        var z = (o5, (2, o6), 3);
        if (z is (var a3, (var b3, var _) t, _))
        {
            Sink(a3);        // $ hasValueFlow=14
            Sink(t.Item2);   // $ hasValueFlow=15
            Sink(b3);
        }
    }

    record R2(string X1, string Y1);

    static void M8()
    {
        var o1 = Source<string>(16);
        var o2 = Source<string>(17);
        var r = new R2(o1, o2);
        // Implicit call to the compiler-generated Deconstruct method of R2
        var (x1, y1) = r;
        Sink(x1);             // $ hasValueFlow=16
        Sink(y1);             // $ hasValueFlow=17
    }

    record R3(string X2, string Y2)
    {
        public void Deconstruct(out string y2, out string x2)
        {
            x2 = X2;
            y2 = Y2;
        }
    }

    static void M9()
    {
        var o1 = Source<string>(18);
        var o2 = Source<string>(19);
        var r = new R3(o1, o2);
        // Implicit call to the custom Deconstruct method of R3
        var (x, y) = r;
        Sink(x);           // $ hasValueFlow=19
        Sink(y);           // $ hasValueFlow=18
    }

    record R4(string X3, string Y3);

    static void M10()
    {
        var o1 = Source<string>(20);
        var o2 = Source<string>(21);
        var r = new R4(o1, o2);
        // Explicit call to the compiler-generated Deconstruct method of R4
        r.Deconstruct(out var x3, out var y3);
        Sink(x3);         // $ hasValueFlow=20
        Sink(y3);         // $ hasValueFlow=21
    }

    static void M11()
    {
        var o1 = Source<string>(22);
        var o2 = Source<string>(23);
        var r = new R4(o1, o2);
        var (x, y) = ("1", "2");
        // Using tuple deconstruction with an existing tuple variable.
        (x, y) = r;
        Sink(x);           // $ hasValueFlow=22
        Sink(y);           // $ hasValueFlow=23
    }

    static void M12()
    {
        var o1 = Source<string>(24);
        var o2 = Source<string>(25);
        var r = new R4(o1, o2);
        // Ignoring certain tuple elements.
        (var x, var _) = r;
        Sink(x);           // $ hasValueFlow=24
    }

    static void M13()
    {
        var o1 = Source<string>(26);
        var o2 = Source<string>(27);
        var r = new R4(o1, o2);
        // Pattern matching with tuple deconstruction.
        if (r is var (x, y))
        {
            Sink(x);           // $ hasValueFlow=26
            Sink(y);           // $ hasValueFlow=27
        }
    }

    static void M14()
    {
        var o1 = Source<string>(28);
        var o2 = Source<string>(29);
        var r = new R4(o1, o2);
        // Pattern matching with positional pattern deconstruction in an is expression.
        if (r is (var x, var y))
        {
            Sink(x);           // $ hasValueFlow=28
            Sink(y);           // $ hasValueFlow=29
        }
    }

    static void M15()
    {
        var o1 = Source<string>(30);
        var o2 = Source<string>(31);
        var r = new R4(o1, o2);

        switch (r)
        {
            // Pattern matching with tuple deconstruction in a switch statement.
            case var (x, y):
                Sink(x);           // $ hasValueFlow=30
                Sink(y);           // $ hasValueFlow=31
                break;
        }
    }

    static void M16()
    {
        var o1 = Source<string>(32);
        var o2 = Source<string>(33);
        var r = new R4(o1, o2);
        // Pattern matching with positional pattern deconstruction in a switch statement.
        switch (r)
        {
            case (var x, var y):
                Sink(x);           // $ hasValueFlow=32
                Sink(y);           // $ hasValueFlow=33
                break;
        }
    }

    class C
    {
        private string x;
        private string y;

        public C(string x, string y)
        {
            this.x = x;
            this.y = y;
        }

        public void Deconstruct(out string x, out string y)
        {
            x = this.x;
            y = this.y;
        }
    }

    static void M17()
    {
        var o1 = Source<string>(34);
        var o2 = Source<string>(35);
        var c = new C(o1, o2);
        // Implicit call to the custom Deconstruct method of C.
        var (x, y) = c;
        Sink(x);           // $ hasValueFlow=34
        Sink(y);           // $ hasValueFlow=35
    }

    public record GenericRecord<T1, T2>(T1 t1, T2 t2);

    static void M18()
    {
        var o1 = Source<string>(36);
        var o2 = Source<string>(37);
        var r = new GenericRecord<string, string>(o1, o2);
        // Implicit call to the compiler-generated Deconstruct method of GenericRecord.
        var (x, y) = r;
        Sink(x);           // $ hasValueFlow=36
        Sink(y);           // $ hasValueFlow=37
    }

    class D
    {
        public string X;
        public string Y;
        public void Deconstruct(out string x, out string y)
        {
            x = X;
            y = Y;
        }
    }

    class E : D { }

    static void M100()
    {
        var o1 = Source<string>(38);
        var o2 = Source<string>(39);
        var e = new E { X = o1, Y = o2 };

        // Implicit call to the inherited Deconstruct method of D through E.
        var (x, y) = e;
        Sink(x);           // $ hasValueFlow=38
        Sink(y);           // $ hasValueFlow=39
    }

    public static void Sink(object o) { }

    static T Source<T>(object source) => throw null;
}

namespace System.Runtime.CompilerServices
{
    public class IsExternalInit { }
}
