using System;

public class Guards
{
    public string? Field;
    public Guards? Property { get; set; }

    void M1(string? s)
    {
        if (!!(s == null))
            return;
        if (s.Length > 0)
        { // null guarded
            Console.WriteLine(s); // null guarded
        }
        else
        {
            Console.WriteLine("<empty string>");
        }
    }

    void M2(string? s)
    {
        if (s != null)
        {
            Console.WriteLine(s); // null guarded
        }
    }

    void M3(string? x, string? y)
    {
        if (!string.IsNullOrEmpty(x) & !(y == null))
            Console.WriteLine(x + y); // null guarded

        if (x == null || y == null) { }
        else Console.WriteLine(x + y); // null guarded

        if (!(x == null || y == null))
            Console.WriteLine(x + y); // null guarded

        if (!!!(x != null && y != null)) { }
        else Console.WriteLine(x + y); // null guarded

        if (Field != null)
            Console.WriteLine(new Guards().Field); // not null guarded

        if (Field != null)
            Console.WriteLine(this.Field);
    }

    void M4(Guards g)
    {
        if (g.Field == null)
            return;
        Console.WriteLine(g.Field); // null guarded
    }

    void M5(Guards g)
    {
        if (g.Property.Property.Field == null)
            throw new Exception();
        Console.WriteLine(g.Property.Property.Field); // null guarded
        Console.WriteLine(g.Property.Field); // not null guarded
    }

    void M6(string? s)
    {
        while (s != null)
        {
            Console.WriteLine(s); // null guarded
            s = null;
            Console.WriteLine(s); // not null guarded
        }
    }

    void M7(string? s)
    {
        if (s?.Length == 0)
            Console.WriteLine(s); // null guarded
        if (s?.Length > 0)
            Console.WriteLine(s); // null guarded
        if (s?.Length >= 0)
            Console.WriteLine(s); // null guarded
        if (s?.Length < 10)
            Console.WriteLine(s); // null guarded
        if (s?.Length <= 10)
            Console.WriteLine(s); // null guarded
        if (s?.Length != null)
            Console.WriteLine(s); // null guarded
        else
            Console.WriteLine(s); // not null guarded
        if (s?.Length - 1 != 0)
            Console.WriteLine(s); // not null guarded
        else
            Console.WriteLine(s); // null guarded
        if (s == "")
            Console.WriteLine(s); // null guarded
        else
            Console.WriteLine(s); // not null guarded
    }

    void M8(Guards g)
    {
        if (g.Property.Property.Field == null)
            throw new Exception();
        g.Property = null;
        Console.WriteLine(g.Property.Property.Field); // not null guarded
        Console.WriteLine(g.Property.Field); // not null guarded
    }

    void M9(Guards g)
    {
        var dummy = g.Property.Property.Field
          ?? g.Property.Property.Field;  // not null guarded
        dummy = g.Property.Property.Field ?? throw null;
        Console.WriteLine(g.Property.Property.Field); // null guarded
        g.Property = null;
        Console.WriteLine(g.Property.Property.Field); // not null guarded
        Console.WriteLine(g.Property.Field); // not null guarded
    }

    void M10(string? s1, string? s2)
    {
        var b1 = s1.Equals(s2); // not null guarded
        var b2 = s1?.Equals(s1); // null guarded
    }

    int M11(string? s)
    {
        if (s is null)
            return s.Length; // not null guarded
        return s.Length; // null guarded
    }

    int M12(string? s)
    {
        if (s is string _)
            return s.Length; // null guarded
        return s.Length; // not null guarded
    }

    string M13(object? o)
    {
        if (o is string s)
            return s; // not null (but not a guard)
        return o.ToString(); // not null guarded
    }

    string M14(object? o)
    {
        switch (o)
        {
            case Action<object> _:
                return o.ToString(); // null guarded
            case Action<string> a:
                return a.ToString(); // not null (but not a guard)
            case "":
                return o.ToString(); // null guarded
            case null:
                return o.ToString(); // not null guarded
            default:
                return o.ToString(); // null guarded
        }
    }

    void M15(string? x)
    {
        if (!string.IsNullOrWhiteSpace(x))
            Console.WriteLine(x); // null guarded
    }

    bool NullTest1(object? o) => o == null;

    bool NullTest2(object? o)
    {
        if (o is null)
            return true;
        return false;
    }

    bool NullTest3(object? o) => o == null ? true : false;

    bool NotNullTest4(object? o) => !NullTest3(o);

    bool NullTestWrong(object? o) => o == null ? true : true;

    void M16(string? s)
    {
        if (!NullTest1(s))
            Console.WriteLine(s); // null guarded
        if (!NullTest2(s))
            Console.WriteLine(s); // null guarded
        if (!NullTest3(s))
            Console.WriteLine(s); // null guarded
        if (NotNullTest4(s))
            Console.WriteLine(s); // null guarded
        if (!NullTestWrong(s))
            Console.WriteLine(s); // not null guarded
    }

    void M17(object? o, string[] args)
    {
        if (o != null)
        {
            o.ToString(); // null guarded
            foreach (var arg in args)
            {
                o.ToString(); // null guarded
            }
        }
    }

    void M18(bool b1)
    {
        var b2 = true;
        if (b1)
            b2 = false;
        switch (b2)
        {
            case true:
                return;
                return;
        }
    }

    void M19(bool b1)
    {
        var b2 = false;
        if (b1)
            b2 = true;
        switch (b2)
        {
            case true:
                return;
                return;
        }
    }

    void M20(bool b)
    {
        var i = 0;
        if (b)
            i = 1;
        switch (i)
        {
            case 1:
                return;
                return;
        }
    }

    enum E { A, B, C }
    void M21(bool b)
    {
        var e = E.A;
        if (b)
            e = E.B;
        switch (e)
        {
            case E.B:
                return;
                return;
        }
    }

    void M22(object? o1, object? o2)
    {
        if (o1?.GetType() == o2.GetType())
            o1.ToString(); // null guarded
        if (o1?.GetType() == o2?.GetType())
            o1.ToString(); // not null guarded
    }

    string M23(object? o)
    {
        return o switch
        {
            Action<object> _ =>
                o.ToString(), // null guarded
            Action<string> a =>
                a.ToString(), // not null (but not a guard)
            "" =>
                o.ToString(), // null guarded
            null =>
                o.ToString(), // not null guarded
            _ =>
                o.ToString() // null guarded
        };
    }

    int M24(bool b1)
    {
        var b2 = true;
        if (b1)
            b2 = false;
        return b2 switch
        {
            true => 0,
            _ => 1
        };
    }

    int M25(bool b1)
    {
        var b2 = false;
        if (b1)
            b2 = true;
        return b2 switch
        {
            true => 0,
            _ => 1
        };
    }

    int M26(bool b)
    {
        var i = 0;
        if (b)
            i = 1;
        return i switch
        {
            1 => 0,
            _ => 1
        };
    }

    int M27(bool b)
    {
        var e = E.A;
        if (b)
            e = E.B;
        return e switch
        {
            E.B => 0,
            _ => 1
        };
    }

    void M28(bool b)
    {
        string s = b ? null : "";
        if (s != null && !b)
            Console.WriteLine(s.Length); // null guarded
    }
}

