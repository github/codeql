// semmle-extractor-options: /r:System.Linq.dll

using System;
using System.Linq;
using System.Collections.Generic;

class Literals
{
    int x = 0b1011;
    int y = 123_456;
    int z = 0b1000_0000;
}

class ExpressionBodiedMembers
{
    int field = 0;
    int Foo() => field;
    int P => 5;
    int Q
    {
        get => Foo();
        set => field = value;
    }
    ExpressionBodiedMembers() : this(1) { }
    ExpressionBodiedMembers(int x) => Foo();
    ~ExpressionBodiedMembers() => Foo();
}

class ThrowExpr
{
    int Throw(int i)
    {
        return i > 0 ? i : throw new ArgumentException("i");
    }
}

class OutVariables
{
    void F(out string x)
    {
        x = "tainted";
    }

    void G(string x, out string y)
    {
        y = x;
    }

    void G()
    {
        F(out string t1);
        F(out var t2);
        var t3 = t1;
        F(out t1);
        t3 = t1;
        t3 = t2;
        G("tainted", out var t4);
        var t5 = t4;
    }
}

class Tuples
{
    (int A, int B) F()
    {
        return (A: 1, B: 2);
    }

    void Expressions()
    {
        (var x, var y) = F();
        var z = F();
        (x, y) = F();
        x = F().A;
        (x, y, z.Item1) = (1, 2, 3);
        (x, y) = (x, y) = (1, 2);
        (var a, (var b, var c)) = (1, z);
        (a, (b, c)) = (b, (c, a));
        var (i, j) = ("", x);
    }

    string I(string x)
    {
        return (a: x, 2).a;
    }

    void TaintFlow()
    {
        var t1 = ("tainted", "X2");
        (var t2, var t3) = t1;
        var t4 = t3;
        var t5 = I(t1.Item1);
    }

    void TupleExprNode()
    {
        var m1 = (1, "TupleExprNode1");
        var m2 = (1, ("TupleExprNode2", 2));
    }

    void TupleMemberAccess()
    {
        var m1 = ("TupleMemberAccess1", 0).Item1;
        var m2 = (0, ("TupleMemberAccess2", 1)).Item2;
    }

    void DefUse()
    {
        (var m1, var m2) = ("DefUse1", (0, 1));
        string m3;
        int m4, m5;
        (m3, (m4, m5)) = (m1, m2);
        var m6 = m4;
        (var m7, (var m8, var m9)) = (m1, m2) = ("DefUse2", (0, 1));
        var m10 = m9;

        // Member assignment
        m2.Item2 = 0;
        var m11 = m2.Item1;

        // Standard assignment
        string m12;
        string m13 = m12 = "DefUse3";
    }
}

class LocalFunctions
{
    int Main()
    {
        int f1(int x) { return x + 1; }

        T f2<T, U>(T t, U u) { return t; }

        Func<int> f4 = f3; // Forward reference

        int f3() => 2;

        Func<int, int> f5 = x => x + 1;

        int f6(int x) => x > 0 ? 1 + f7(x - 1) : 0;

        int f7(int x) => f6(x);

        int f8()
        {
            int f9(int x) => f7(x);
            return f9(1);
        }

        Action a = () =>
        {
            int f9() => 0;
        };

        return f1(2);
    }

    void Generics()
    {
        int f<T>() => 1;
        T g<T>(T t) => t;

        U h<T, U>(T t, U u)
        {
            int f2<S>(S s, T _t) => f<T>();
            f<T>();
            return g(u);
        }

        h(0, 0);
        h("", true);
    }

    void GlobalFlow()
    {
        string src = "tainted";
        string f(string s) => g(s) + "";
        string g(string s) => s;
        string h(string s) { return s; }

        var sink1 = f(src);
        var sink2 = g(src);
        var sink3 = h(src);
    }
}

class Refs
{
    void F1()
    {
        int v1 = 2;
        ref int r1 = ref v1;
        var array = new int[10];
        r1 = 3;
        r1 = array[1];
        ref int r2 = ref array[3];
        ref int r3 = ref r1;
        v1 = F2(ref v1);
        ref int r4 = ref F2(ref r1);
        F2(ref r1) = 3;
    }

    ref int F2(ref int p)
    {
        ref int F3(ref int q) { return ref q; }
        return ref p;
    }

    delegate ref int RefFn(ref int p);
}

class Discards
{
    (int, double) f(out bool x)
    {
        x = false;
        return (0, 0.0);
    }

    void Test()
    {
        _ = f(out _);
        (_, _) = f(out _);
        (var x, _) = f(out _);
        (_, var y) = f(out var z);
    }
}

class Patterns
{
    void Test()
    {
        object o = null;
        if (o is int i1 && i1 > 0)
        {
            Console.WriteLine($"int {i1}");
        }
        else if (o is string s1)
        {
            Console.WriteLine($"string {s1}");
        }
        else if (o is double _)
        {
        }
        else if (o is var v1)
        {
        }

        switch (o)
        {
            case "xyz":
                break;
            case "" when 1 < 2:
                break;
            case "x" when o is string s4:
                Console.WriteLine($"x {s4}");
                break;
            case int i2 when i2 > 0:
                Console.WriteLine($"positive {i2}");
                break;
            case int i3:
                Console.WriteLine($"int {i3}");
                break;
            case string s2:
                Console.WriteLine($"string {s2}");
                break;
            case double _:
                Console.WriteLine("Double");
                break;
            case var v2:
                break;
            default:
                Console.WriteLine("Something else");
                break;
        }
    }
}

class ForeachStatements
{
    void Test()
    {
        var dict = new Dictionary<int, string>();
        var list = dict.Select(item => (item.Key, item.Value));

        foreach ((int a, string b) in list) { }

        foreach ((var a, var b) in list) { }

        foreach (var (a, b) in list) { }
    }
}

class ForLoops
{
    void Test()
    {
        for (int x = 0; x < 10 && x is int y; ++x)
        {
            Console.WriteLine(y);
        }
    }
}
