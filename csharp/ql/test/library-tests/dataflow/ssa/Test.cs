class Test
{
    int field;

    int f(int param1, System.Collections.Generic.IEnumerable<int> param2)
    {
        field = 3;
        int x = 1;
        int y;
        int z;
        if (param1 > 2)
        {
            x++;
            y = ++x;
            z = 3;
        }
        else
        {
            y = 2;
            y += 4;
            field = 10;
            z = 4;
        }
        use(z);
        while (x < y)
        {
            if (param1++ > 4)
            {
                break;
            }
            y -= 1;
        }
        use(field);
        for (int i = 0; i < 10; i++)
        {
            x += i;
        }
      ;
        foreach (var w in param2)
        {
            param1 += w;
        }
        return x + y;
    }

    void g(int @in, out int @out)
    {
        if (@in > 0)
        {
            @out = 0;
        }
        else
        {
            @out = 1;
        }
        use(field);
        field = 2;
        use(field);
        return;
    }

    void h(int x)
    {
        try
        {
            var temp = 0 / x;
        }
        catch (System.DivideByZeroException e)
        {
            use(e);
        }
    }

    void use<T>(T x) { }

    void phiReads(bool b1, bool b2, bool b3, bool b4, bool b5, bool b6)
    {
        var x = 0;

        if (b1)
        {
            use(x);
        }
        else if (b2)
        {
            use(x);
        }
        // phi_use for `x`

        if (b3)
        {
            use(x);
        }
        else if (b4)
        {
            use(x);
        }
        // phi_use for `x`, even though there is an actual use in the block
        use(x);


        if (b5)
        {
            use(x);
        }
        else
        {
            x = 1;
            use(x);
        }
        // no phi_use (normal phi instead)

        if (b6)
        {
            use(x);
        }
        // no phi_use for `x`, because not live
    }
}
