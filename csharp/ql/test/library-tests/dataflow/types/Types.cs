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
        new C().CallM(); // no flow
        M2(new C()); // flow
        M3(new C()); // no flow
        M4(new C()); // flow
        M5(new C()); // flow
        M6(new C()); // flow
        M7(new C()); // flow
        M8(new C()); // no flow
        M9(new C()); // flow

        new D().M(); // flow
        new D().CallM(); // flow
        M2(new D()); // no flow
        M3(new D()); // flow
        M4(new D()); // no flow
        M5(new D()); // flow
        M6(new D()); // flow
        M7(new D()); // flow
        M8(new D()); // flow
        M9(new D()); // no flow

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

    abstract class E<T>
    {
        E<T> Field;
        public abstract void M();

        void M2(E<T> e)
        {
            this.Field = e;
            this.M();
        }

        class E1 : E<C>
        {
            void M3()
            {
                this.M2(new E1()); // no flow
            }

            public override void M() { }
        }

        class E2 : E<D>
        {
            void M3()
            {
                this.M2(new E2()); // flow
            }

            public override void M()
            {
                Sink(this.Field);
            }

            void M10()
            {
                var a = new A();
                var e2 = new E2();
                Sink(Through(a)); // flow
                Sink(Through(e2)); // flow
                Sink((E2)Through(a)); // no flow
                Sink((A)Through(e2)); // no flow
            }
        }
    }

    static object Through(object x) => x;

    class FieldA
    {
        public object Field;

        public virtual void M() { }

        public void CallM() => this.M();

        static void M1(FieldB b, FieldC c)
        {
            b.Field = new object();
            b.CallM(); // no flow
            c.Field = new object();
            c.CallM(); // flow
        }
    }

    class FieldB : FieldA { }

    class FieldC : FieldA
    {
        public override void M() => Sink(this.Field);
    }
}
