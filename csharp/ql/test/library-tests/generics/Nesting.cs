public class A<T1>
{
    public void MA1(T1 x) { }
    public void MA2<T2>(T1 x, T2 y) { }

    public class B<T3>
    {
        public void MB1(T1 x, T3 y) { }
        public void MB2<T4>(T1 x, T3 y, T4 z) { }
    }

    public class C
    {
        public void MC1(T1 x) { }
        public void MC2<T5>(T1 x, T5 y) { }

        public class D<T6>
        {
            public void MD1(T1 x, T6 y) { }
            public void MD2<T7>(T1 x, T6 y, T7 z) { }
        }
    }

    void Construct()
    {
        var a1 = new A<int>();
        a1.MA1(0);
        a1.MA2(0, "");

        var a2 = new A<string>();
        a2.MA1("");
        a2.MA2("", 0);

        var b1 = new A<int>.B<string>();
        b1.MB1(0, "");
        b1.MB2(0, "", false);

        var b2 = new A<string>.B<int>();
        b2.MB1("", 0);
        b2.MB2("", 0, false);

        var c1 = new A<int>.C();
        c1.MC1(0);
        c1.MC2(0, false);

        var c2 = new A<string>.C();
        c2.MC1("");
        c2.MC2("", false);

        var d1 = new A<int>.C.D<bool>();
        d1.MD1(0, false);
        d1.MD2(0, false, "");

        var d2 = new A<string>.C.D<decimal>();
        d2.MD1("", 0m);
        d2.MD2("", 0m, false);
    }
}