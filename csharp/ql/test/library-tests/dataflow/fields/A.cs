public class A
{
    public void M1()
    {
        var c = Source<C>(1);
        var b = B.Make(c);
        Sink(b.c); // $ hasValueFlow=1
    }

    public void M2()
    {
        var b = new B();
        b.Set(Source<C1>(2.1));
        Sink(b.Get()); // $ hasValueFlow=2.1
        Sink((new B(Source<C>(2.2))).Get()); // $ hasValueFlow=2.2
    }

    public void M3()
    {
        var b1 = new B();
        B b2;
        b2 = SetOnB(b1, Source<C2>(3));
        Sink(b1.c);
        Sink(b2.c); // $ hasValueFlow=3
    }

    public void M4()
    {
        var b1 = new B();
        B b2;
        b2 = SetOnBWrap(b1, Source<C2>(4));
        Sink(b1.c);
        Sink(b2.c); // $ hasValueFlow=4
    }

    public B SetOnBWrap(B b1, C c)
    {
        var b2 = SetOnB(b1, c);
        return R() ? b1 : b2;
    }

    public B SetOnB(B b1, C c)
    {
        if (R())
        {
            B b2 = new B();
            b2.Set(c);
            return b2;
        }
        return b1;
    }

    public void M5()
    {
        var a = Source<A>(5);
        C1 c1 = new C1();
        c1.a = a;
        M6(c1);
    }
    public void M6(C c)
    {
        if (c is C1)
        {
            Sink(((C1)c).a); // $ hasValueFlow=5
        }
        C cc;
        if (c is C2)
        {
            cc = (C2)c;
        }
        else
        {
            cc = new C1();
        }
        if (cc is C1)
        {
            Sink(((C1)cc).a); // no flow, stopped by cast to C2
        }
    }

    public void M7(B b)
    {
        b.Set(Source<C>(7));
    }
    public void M8()
    {
        var b = new B();
        M7(b);
        Sink(b.c); // $ hasValueFlow=7
    }

    public class D
    {
        public B b;
        public D(B b, bool x)
        {
            b.c = Source<C>(9.1);
            this.b = x ? b : Source<B>(9.2);
        }
    }

    public void M9()
    {
        var b = Source<B>(9.3);
        var d = new D(b, R());
        Sink(d.b); // $ hasValueFlow=9.2 $ hasValueFlow=9.3
        Sink(d.b.c); // $ hasValueFlow=9.1
        Sink(b.c); // $ hasValueFlow=9.1
    }

    public void M10()
    {
        var b = Source<B>(10);
        var l1 = new MyList(b, new MyList(null, null));
        var l2 = new MyList(null, l1);
        var l3 = new MyList(null, l2);
        Sink(l3.head); // no flow, b is nested beneath at least one .next
        Sink(l3.next.head); // flow, the precise nesting depth isn't tracked
        Sink(l3.next.next.head); // $ hasValueFlow=10
        Sink(l3.next.next.next.head); // no flow
        for (var l = l3; l != null; l = l.next)
        {
            Sink(l.head); // $ hasValueFlow=10
        }
    }

    public static void Sink(object o) { }
    public bool R() { return this.GetHashCode() % 10 > 5; }

    public class C { }
    public class C1 : C
    {
        public A a;
    }
    public class C2 : C { }

    public class B
    {
        public C c;
        public B() { }
        public B(C c)
        {
            this.c = c;
        }
        public void Set(C c) { this.c = c; }
        public C Get() { return this.c; }
        public static B Make(C c)
        {
            return new B(c);
        }
    }

    public class MyList
    {
        public B head;
        public MyList next;
        public MyList(B head, MyList next)
        {
            this.head = head;
            this.next = next;
        }
    }

    static T Source<T>(object source) => throw null;
}
