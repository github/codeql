public class A
{
    public void M1()
    {
        var c = new C();
        var b = B.Make(c);
        Sink(b.c); // flow
    }

    public void M2()
    {
        var b = new B();
        b.Set(new C1());
        Sink(b.Get()); // flow
        Sink((new B(new C())).Get()); // flow
    }

    public void M3()
    {
        var b1 = new B();
        B b2;
        b2 = SetOnB(b1, new C2());
        Sink(b1.c); // no flow
        Sink(b2.c); // flow
    }

    public void M4()
    {
        var b1 = new B();
        B b2;
        b2 = SetOnBWrap(b1, new C2());
        Sink(b1.c); // no flow
        Sink(b2.c); // flow
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
        var a = new A();
        C1 c1 = new C1();
        c1.a = a;
        M6(c1);
    }
    public void M6(C c)
    {
        if (c is C1)
        {
            Sink(((C1)c).a); // flow
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
        b.Set(new C());
    }
    public void M8()
    {
        var b = new B();
        M7(b);
        Sink(b.c); // flow
    }

    public class D
    {
        public B b;
        public D(B b, bool x)
        {
            b.c = new C();
            this.b = x ? b : new B();
        }
    }

    public void M9()
    {
        var b = new B();
        var d = new D(b, R());
        Sink(d.b); // flow x2
        Sink(d.b.c); // flow
        Sink(b.c); // flow
    }

    public void M10()
    {
        var b = new B();
        var l1 = new MyList(b, new MyList(null, null));
        var l2 = new MyList(null, l1);
        var l3 = new MyList(null, l2);
        Sink(l3.head); // no flow, b is nested beneath at least one .next
        Sink(l3.next.head); // flow, the precise nesting depth isn't tracked
        Sink(l3.next.next.head); // flow
        Sink(l3.next.next.next.head); // no flow
        for (var l = l3; l != null; l = l.next)
        {
            Sink(l.head); // flow
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
}
