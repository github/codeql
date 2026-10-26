using System;

unsafe class FunctionPointerFlow
{
    public static void Log1(int i) { }
    public static void Log2(int i) { }
    public static void Log3(int i) { }
    public static void Log4(int i) { }
    public static void Log5(int i) { }
    public static void Log6(int i) { }

    public static void M2(delegate*<int, void> a)
    {
        a(1);
        a = &Log3;
        a(2);
    }

    public void M3()
    {
        M2(&Log1);
    }

    public static void M4(delegate*<int, void> a)
    {
        M2(a);
    }

    public void M5()
    {
        M4(&Log2);
    }

    public delegate*<int, void> M6()
    {
        return &Log4;
    }

    public void M7()
    {
        M6()(0);
    }

    public void M8()
    {
        static void LocalFunction(int i) { };
        M2(&LocalFunction);
    }

    private static delegate*<int, void> field = &Log5;

    public void M9()
    {
        field(1);
    }

    public void M10(delegate*<delegate*<int, void>, void> aa, delegate*<int, void> a)
    {
        aa(a);
    }

    public void M11()
    {
        M10(&M4, &Log6);
    }

    public void M16(delegate*<Action<int>, void> aa, Action<int> a)
    {
        aa(a);
    }

    public static void M17(Action<int> a)
    {
        a(0);
        a = _ => { };
        a(0);
    }

    public void M18()
    {
        M16(&M17, (i) => { });
    }
}
