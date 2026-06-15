class BarrierFlow
{
    static object Source(object source) => throw null;

    public static void Sink(object o) { }


    void M1()
    {
        var x = Source(1);

        Sink(x); // $ hasValueFlow=1
    }

    void M2()
    {
        var x = Source(2);

        if (x != "safe")
        {
            Sink(x); // $ hasValueFlow=2
        }
    }

    void M3()
    {
        var x = Source(3);

        if (x == "safe")
        {
            Sink(x);
        }
    }

    void M4()
    {
        var x = Source(4);

        if (x != "safe")
        {
            x = "safe";
        }

        Sink(x);
    }

    void M5()
    {
        var x = Source(5);

        if (x == "safe")
        {
        }
        else
        {
            x = "safe";
        }

        Sink(x);
    }

    void M6(bool b)
    {
        var x = Source(6);

        if (b)
        {
            if (x != "safe1")
            {
                return;
            }
        }
        else
        {
            if (x != "safe2")
            {
                return;
            }
        }

        Sink(x);
    }
}
