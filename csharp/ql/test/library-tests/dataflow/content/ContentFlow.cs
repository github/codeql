using System;

public class ContentFlow
{
    public class A
    {
        public A FieldA;
        public B FieldB;
    }
    public class B
    {
        public A FieldA;
        public B FieldB;
    }

    public void M(A a, B b)
    {
        var a1 = new A();
        Sink(Through(a1.FieldA.FieldB));

        a.FieldA.FieldB = new B();
        Sink(Through(a));

        var a2 = new A();
        b.FieldB.FieldA = a2.FieldB.FieldA;
        Sink(Through(b));

        Sink(Through(Out()));

        In(new A().FieldA.FieldB);
    }

    public static void Sink<T>(T t) { }

    public T Through<T>(T t)
    {
        Sink(t);
        return t;
    }

    public void In<T>(T t)
    {
        Sink(t);
    }

    public B Out()
    {
        var a = new A();
        return a.FieldA.FieldB;
    }
}
