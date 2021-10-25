public class TestClass
{
    public void ifs(long w)
    {
        int x = 0;
        long y = 50;

        use(y);
        use(w);

        if (x > 0)
        {
            y = 20;
            use(y);
        }
        else
        {
            y = 30;
            w = 10;
            use(w);
        }

        use(y);
        use(w);

        if (x < 0)
        {
            y = 40;
            w = 20;
        }
        else
            return;

        use(y);
        use(w);

        if (x == 0)
        {
            y = 60;
        }

        use(y);

        var z = x;
        use(z);

        outMethod(out z);
        use(z);

        refMethod(ref z);
        use(z);

        Field = w;
        use(Field);

        Prop = x;
        use(Prop);

        int i = 0;
        System.Action act = () => { i = 1; };
        use(i);

        Field2 = 0;
        use(Field2);

        Field3 = 0;
        TestClass tc = null;
        tc.Field3 = 1;
        use(Field3);

        i = 0;
        i++;
        use(i);

        i = 0;
        i--;
        use(i);

        var x1 = 0;
        while (refMethod(ref x1) && Field2 > 0) { }
        use(x1);

        var x2 = 0;
        refOutMethod(
          ref x2,
          out x2);
        use(x2);

        var x3 = 0;
        int x4;
        refOutMethod(
          ref x3,
          out x4);
        use(x3);
        use(x4);

        var x5 = 0;
        while (x5 > 10)
        {
            use(x5);
            x5 = x5 + 1;
        }

        x5 += 1;
        use(x5);

        return;
    }

    void M() { Field2 = 0; }

    public static void use<T>(T u) { return; }

    public static void outMethod(out int i) { i = 42; return; }

    public static bool refMethod(ref int i) { i = 1; return false; }

    public static void refOutMethod(ref int i, out int j) { j = i; i = 1; }

    public long Field;

    public int Field2;

    public int Field3;

    public int Prop { get; set; }

    TestClass(int i)
      : this("" + i)
    {
        i = 0;
    }

    TestClass(double d)
      : this(d.ToString())
    {
        d = 0.0;
    }

    TestClass(string s) { }

    void Enumerable(System.Collections.Generic.IEnumerable<string> ie)
    {
        foreach (var x in ie)
        {
            use(x);
            use(x);
        }
        return;
    }

    int Field4;
    void FieldM1()
    {
        Field4 = 0;
        use(Field4);
        use(Field4);
    }

    void FieldM2()
    {
        use(Field4);
        use(Field4);
    }

    int Field5;
    void Captured(int i)
    {
        use(i);
        i = 0;
        System.Action a = () =>
        {
            i = 1;
            use(i);
            System.Action a1 = () =>
            {
                use(i);
                use(i);
            };
        };
        a();
        use(i);

        Field5 = 0;
        use(Field5);
        a = () =>
        {
            Field5 = 1;
            use(Field5);
        };
        a();
        use(Field5);
    }
}
