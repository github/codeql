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
        Sink(a1.FieldA.FieldB);

        a.FieldA.FieldB = new B();
        Sink(a);

        var a2 = new A();
        b.FieldB.FieldA = a2.FieldB.FieldA;
        Sink(b);
    }

    public static void Sink<T>(T t) { }

}
