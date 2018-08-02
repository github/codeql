using System;

class Tuples
{
    int Field;
    int Property { get; set; }

    void M()
    {
        (int x, (bool b, string s)) = (0, (false, ""));
        Use(x);
        Use(b);
        Use(s);
        (x, (b, s)) = GetTuple();
        Use(x);
        Use(b);
        Use(s);
        (int f1, (bool f1, string f3)) tuple = GetTuple();
        Use(tuple);
        (Property, Field) = (2, 3);
        Use(Property);
        Use(Field);
        (x, (b, x)) = (4, (false, 5));
        Use(x);
        var t = new Tuples();
        (Field, t.Field) = (6, 7);
        Use(Field);
        Use(t.Field);
    }

    (int, (bool, string)) GetTuple()
    {
        return (0, (false, ""));
    }

    static void Use<T>(T u) { }
}

// semmle-extractor-options: /r:System.Diagnostics.Process.dll /r:System.Linq.dll /r:System.Linq.Expressions.dll /r:System.Linq.Queryable.dll /r:System.ComponentModel.Primitives.dll
