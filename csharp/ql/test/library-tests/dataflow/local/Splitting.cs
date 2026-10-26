class Splitting
{
    void M1(bool b, string tainted)
    {
        var x = tainted;
        if (b)
        {
            Check(x);
            if (x == null)
                return;
        }
        Check(x);
        if (b)
            Check(x);
    }

    void M2(bool b)
    {
        var x = "";
        if (b)
        {
            Check(x);
            x = "taint source";
        }
        Check(x);
        if (b)
            Check(x);
        else
            Check(x);
    }

    void M3(bool b)
    {
        var x = "";
        if (b)
            x = "a";
        x = "b";
        Check(x);
        Check(b ? x : "c");
        Check((object)x);
        Check(x = "d");
        if (b)
            return;
    }

    void M4(bool b)
    {
        var x = "";
        if (b)
            x = "abc";
        var y = new string[] { "a" };
        y[0] = "b";
        x = x + y[0];
        var z = x == "";
        z = !z;
        x = $"c{x}";
        x = (x, y).Item1;
        foreach (var s in y)
            Check(s);
        if (b)
            return;
    }

    string Field;
    static void Check<T>(T x) { }
}
