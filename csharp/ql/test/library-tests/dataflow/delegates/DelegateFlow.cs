using System;

class DelegateFlow
{
    void M1(int i) { }

    static void M2(Action<int> a)
    {
        a(0);
        a = _ => { };
        a(1);
    }

    void M3()
    {
        M2(_ => { });
        M2(M1);
    }

    void M4(Action<int> a)
    {
        M2(a);
    }

    void M5()
    {
        M4(_ => { });
        M4(M1);
    }

    void M6(Action<Action<int>> aa, Action<int> a)
    {
        aa(a);
    }

    void M7()
    {
        M6(a => { a(1); }, M1);
    }

    Action<int> Prop
    {
        get { return _ => { }; }
        set { value(0); }
    }

    void M8()
    {
        dynamic d = this;
        d.Prop = d.Prop;
    }

    static Func<Action<int>> F = () => _ => { };

    void M9()
    {
        F()(0);
    }

    Action<int> M10()
    {
        return _ => { };
    }

    void M11()
    {
        M10()(0);
    }

    public delegate void EventHandler();

    public event EventHandler Click;

    public void M12()
    {
        Click += M11;
        Click();
        M13(M9);
    }

    public void M13(EventHandler eh)
    {
        Click += eh;
        Click();
    }

    public void M13()
    {
        void M14(MyDelegate d) => d();
        M14(new MyDelegate(M9));
        M14(new MyDelegate(new MyDelegate(M11)));
        M14(M12);
        M14(() => { });
    }

    public void M14()
    {
        void LocalFunction(int i) { };
        M2(LocalFunction);
    }

    public void M15()
    {
        Func<int> f = () => 42;
        new Lazy<int>(f);
        f = () => 43;
        new Lazy<int>(f);
    }

    public delegate void MyDelegate();

    public unsafe void M16(delegate*<Action<int>, void> fnptr, Action<int> a)
    {
        fnptr(a);
    }

    public unsafe void M17()
    {
        M16(&M2, (i) => { });
    }

    public unsafe void M18()
    {
        delegate*<Action<int>, void> fnptr = &M2;
        fnptr((i) => { });
    }

    void M19(Action a, bool b)
    {
        if (b)
            a = () => {};
        a();
    }

    void M20(bool b) => M19(() => {}, b);
}
