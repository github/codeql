using System;

public class Guards
{
    public string Field;
    public Guards Property { get; set; }

    void M1(string s)
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

    void M2(string s)
    {
        if (s != null)
        {
            Console.WriteLine(s); // null guarded
        }
    }

    void M3(string x, string y)
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

    void M6(string s)
    {
        while (s != null)
        {
            Console.WriteLine(s); // null guarded
            s = null;
            Console.WriteLine(s); // not null guarded
        }
    }

    void M7(string s)
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

    void M10(string s1, string s2)
    {
        var b1 = s1.Equals(s2); // not null guarded
        var b2 = s1?.Equals(s1); // null guarded
    }
}
