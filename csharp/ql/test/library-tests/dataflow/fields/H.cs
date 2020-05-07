public class H
{
    class A
    {
        public object FieldA;
    }

    class B
    {
        public object FieldB;
    }

    A Clone(A a)
    {
        var ret = new A();
        ret.FieldA = a.FieldA;
        return ret;
    }

    void M1(object o)
    {
        var a = new A();
        a.FieldA = new object();
        var clone = Clone(a);
        Sink(clone.FieldA); // flow
        
        a = new A();
        a.FieldA = o;
        clone = Clone(a);
        Sink(clone.FieldA); // no flow
    }

    B Transform(A a)
    {
        var b = new B();
        b.FieldB = a.FieldA;
        return b;
    }

    void M2(object o)
    {
        var a = new A();
        a.FieldA = new object();
        var b = Transform(a);
        Sink(b.FieldB); // flow

        a = new A();
        a.FieldA = o;
        b = Transform(a);
        Sink(b.FieldB); // no flow
    }

    void TransformArg(A a, B b1, B b2)
    {
        b1.FieldB = a.FieldA;
    }

    void M3(object o)
    {
        var a = new A();
        var b1 = new B();
        var b2 = new B();
        a.FieldA = new object();
        TransformArg(a, b1, b2);
        Sink(b1.FieldB); // flow
        Sink(b2.FieldB); // no flow

        a = new A();
        b1 = new B();
        b2 = new B();
        a.FieldA = o;
        TransformArg(a, b1, b2);
        Sink(b1.FieldB); // no flow
        Sink(b2.FieldB); // no flow
    }

    void SetArgs(A a, object o, B b1, B b2)
    {
        a.FieldA = o;
        TransformArg(a, b1, b2);
    }

    void M4(object o)
    {
        var a = new A();
        var b1 = new B();
        var b2 = new B();
        SetArgs(a, new object(), b1, b2);
        Sink(a.FieldA); // flow
        Sink(b1.FieldB); // flow
        Sink(b2.FieldB); // no flow

        a = new A();
        b1 = new B();
        b2 = new B();
        SetArgs(a, o, b1, b2);
        Sink(a.FieldA); // no flow
        Sink(b1.FieldB); // no flow
        Sink(b2.FieldB); // no flow
    }

    B TransformWrap(A a)
    {
        var temp = new B();
        temp.FieldB = a;
        return Transform((A)temp.FieldB);
    }

    void M5(object o)
    {
        var a = new A();
        a.FieldA = new object();
        var b = TransformWrap(a);
        Sink(b.FieldB); // flow

        a = new A();
        a.FieldA = o;
        b = TransformWrap(a);
        Sink(b.FieldB); // no flow
    }

    object Get(A a)
    {
        return Transform(a).FieldB;
    }

    void M6(object o)
    {
        var a = new A();
        a.FieldA = new object();
        Sink(Get(a)); // flow

        a = new A();
        a.FieldA = o;
        Sink(Get(a)); // no flow
    }

    object Through(object o)
    {
        var a = new A();
        a.FieldA = o as A;
        return Transform(a).FieldB;
    }

    void M7()
    {
        var a = Through(new A());
        Sink(a); // flow
        var b = Through(new B());
        Sink(b); // no flow
    }

    void SetNested(A a, object o)
    {
        var b = new B();
        b.FieldB = o;
        a.FieldA = b;
    }

    void M8()
    {
        var a = new A();
        var o = new object();
        SetNested(a, o);
        var b = (B) a.FieldA;
        Sink(b); // flow (from `new B()` inside `SetNested`)
        Sink(b.FieldB); // flow
    }

    public static void Sink(object o) { }
}