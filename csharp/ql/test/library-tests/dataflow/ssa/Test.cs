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
}
