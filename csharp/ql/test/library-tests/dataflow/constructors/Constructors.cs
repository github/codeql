public class Constructors
{
    public class C_no_ctor
    {
        private object s1 = Source<object>(1);

        void M1()
        {
            C_no_ctor c = new C_no_ctor();
            c.M2();
        }

        public void M2()
        {
            Sink(s1); // $ hasValueFlow=1
        }
    }

    public class C_with_ctor
    {
        private object s1 = Source<object>(1);

        void M1()
        {
            C_with_ctor c = new C_with_ctor();
            c.M2();
        }

        public C_with_ctor() { }

        public void M2()
        {
            Sink(s1); // $ hasValueFlow=1
        }
    }

    public class C1
    {
        public object Obj;

        public C1(object o) => Obj = o;
    }

    public class C2(object o21param, object o22param)
    {
        public object Obj21 = o21param;

        public object Obj22 => o22param;

        public object Obj23 => Obj21;

        public void SetObj(object o)
        {
            o22param = o;
        }

        private void SetObjOut(out object o1, object o2)
        {
            o1 = o2;
        }

        public void SetObjViaOut(object o)
        {
            SetObjOut(out o22param, o);
        }
    }

    public void M1()
    {
        var o = Source<object>(1);
        var c1 = new C1(o);
        Sink(c1.Obj); // $ hasValueFlow=1
    }

    public void M2()
    {
        var o21 = Source<object>(2);
        var o22 = Source<object>(3);
        var c2 = new C2(o21, o22);
        Sink(c2.Obj21); // $ hasValueFlow=2
        Sink(c2.Obj22); // $ hasValueFlow=3
        Sink(c2.Obj23); // $ hasValueFlow=2
    }

    public void M3()
    {
        var c2 = new C2(new object(), new object());
        Sink(c2.Obj21); // No flow
        Sink(c2.Obj22); // No flow
        Sink(c2.Obj23); // No flow
        var taint = Source<object>(4);
        c2.SetObj(taint);
        Sink(c2.Obj22); // $ hasValueFlow=4
    }

    public void M4()
    {
        var c2 = new C2(new object(), new object());
        var taint = Source<object>(5);
        c2.SetObjViaOut(taint);
        Sink(c2.Obj22); // $ hasValueFlow=5
    }

    public class C3(object o31param)
    {
        public object Obj31 => o31param;
    }

    public void M5()
    {
        var o31 = Source<object>(6);
        var c3 = new C3(o31);
        Sink(c3.Obj31); // $ hasValueFlow=6
    }

    public class C4
    {
        public object Obj1 { get; init; }
        public object Obj2 { get; }

        public C4(object oc1, object oc2)
        {
            Obj1 = oc1;
            Obj2 = oc2;
        }
    }

    public void M6()
    {
        var o1 = Source<object>(7);
        var o2 = Source<object>(8);
        var c4 = new C4(o1, o2);
        Sink(c4.Obj1); // $ hasValueFlow=7
        Sink(c4.Obj2); // $ hasValueFlow=8
    }

    public record R1(object Obj1, object Obj2);

    public void M7()
    {
        var o1 = Source<object>(9);
        var o2 = Source<object>(10);
        var r1 = new R1(o1, o2);
        Sink(r1.Obj1); // $ hasValueFlow=9
        Sink(r1.Obj2); // $ hasValueFlow=10
    }

    public static void Sink(object o) { }

    public static T Source<T>(object source) => throw null;
}
