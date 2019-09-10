class Types
{
    class A
    {
        public virtual void M() { }

        public void CallM() => this.M();
    }

    class B<T> : A { }

    class C : B<int> { }

    class D : B<string>
    {
        public override void M() => Sink(this);
    }

    static void M1()
    {
        new C().M(); // no flow
        new C().CallM(); // no flow (FALSE POSITIVE)
        M2(new C()); // flow
        M3(new C()); // no flow (FALSE POSITIVE)
        M4(new C()); // flow
        M5(new C()); // flow
        M6(new C()); // flow
        M7(new C()); // flow
        M8(new C()); // no flow (FALSE POSITIVE)
        M9(new C()); // flow

        new D().M(); // flow
        new D().CallM(); // flow
        M2(new D()); // no flow (FALSE POSITIVE)
        M3(new D()); // flow
        M4(new D()); // no flow (FALSE POSITIVE)
        M5(new D()); // flow
        M6(new D()); // flow
        M7(new D()); // flow
        M8(new D()); // flow
        M9(new D()); // no flow (FALSE POSITIVE)

        object o = null; // flow
        Sink(o);
    }

    static void M2(A a)
    {
        if (a is C c)
            Sink(c);
    }

    static void M3(A a)
    {
        switch (a)
        {
            case D d:
                Sink(d);
                break;
        }
    }

    static void M4(A a) => Sink((C)a);

    static void M5<T>(T x) => Sink(x);

    static void M6<T>(T x) where T : A => Sink(x);

    static void M7<T>(T x) where T : class => Sink(x);

    static void M8<T>(T x)
    {
        dynamic d = x;
        d.M();
    }

    static void M9(A a)
    {
        if (a is B<int> b)
            Sink(b);
    }

    static void Sink<T>(T x) { }
}
