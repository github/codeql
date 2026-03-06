using System;

public static class MyExtensions
{
    extension(object obj)
    {
        public B Prop1
        {
            get
            {
                return A.Source<B>(1);
            }
            set
            {
                A.Sink(value); // $ hasValueFlow=2 hasValueFlow=102
            }
        }

        public B Prop2
        {
            get
            {
                A.Sink(obj); // $ hasValueFlow=6 hasValueFlow=106
                return new B();
            }
            set
            {
                A.Sink(obj); // $ hasValueFlow=7 hasValueFlow=107
            }
        }

        public static B StaticProp1
        {
            get
            {
                return A.Source<B>(10);
            }
            set
            {
                A.Sink(value); // $ hasValueFlow=11 hasValueFlow=111
            }
        }

        public B M1()
        {
            return A.Source<B>(3);
        }

        public void M2()
        {
            A.Sink(obj); // $ hasValueFlow=4 hasValueFlow=104
        }

        public static B M3(B b)
        {
            return b;
        }

        public static object operator +(object a, object b)
        {
            A.Sink(a); // $ hasValueFlow=8 hasValueFlow=108
            return new object();
        }

        public static object operator -(object a, object b)
        {
            return A.Source<B>(9);
        }

        public T GenericMethod<T>(T t)
        {
            return t;
        }
    }

    extension(B b)
    {
        public B B1()
        {
            return b;
        }

        public void B2()
        {
            A.Sink(b); // $ hasValueFlow=12 hasValueFlow=112
        }
    }

    extension<T>(T t) where T : class
    {
        public void GenericM1()
        {
            A.Sink(t); // $ hasValueFlow=13 hasValueFlow=113
        }

        public S GenericM2<S>(S other)
        {
            return other;
        }
    }
}

public class A
{
    public void Test1()
    {
        var obj = new object();
        var b1 = obj.Prop1;
        Sink(b1); // $ hasValueFlow=1

        var b2 = MyExtensions.get_Prop1(obj);
        Sink(b2); // $ hasValueFlow=1
    }

    public void Test2()
    {
        var obj = new object();
        obj.Prop1 = Source<B>(2);

        var b = Source<B>(102);
        MyExtensions.set_Prop1(obj, b);
    }

    public void Test3()
    {
        var obj = new object();
        var b1 = obj.M1();
        Sink(b1); // $ hasValueFlow=3

        var b2 = MyExtensions.M1(obj);
        Sink(b2); // $ hasValueFlow=3
    }

    public void Test4()
    {
        var b1 = Source<B>(4);
        b1.M2();

        var b2 = Source<B>(104);
        MyExtensions.M2(b2);
    }

    public void Test5()
    {
        var b1 = Source<B>(5);
        var b2 = b1.B1();
        Sink(b2); // $ hasValueFlow=5

        var b3 = MyExtensions.B1(b1);
        Sink(b3); // $ hasValueFlow=5
    }

    public void Test6()
    {
        var b1 = Source<B>(6);
        var b2 = b1.Prop2;

        var b3 = Source<B>(106);
        var b4 = MyExtensions.get_Prop2(b3);
    }

    public void Test7()
    {
        var b1 = Source<B>(7);
        b1.Prop2 = new B();

        var b2 = Source<B>(107);
        MyExtensions.set_Prop2(b2, new B());
    }

    public void Test8()
    {
        var b1 = Source<B>(8);
        var b2 = Source<B>(1);
        var b3 = b1 + b2;

        var b4 = Source<B>(108);
        var b5 = MyExtensions.op_Addition(b4, b2);
    }

    public void Test9()
    {
        var b1 = Source<B>(0);
        var b2 = Source<B>(1);
        var b3 = b1 - b2;
        Sink(b3); // $ hasValueFlow=9

        var b4 = MyExtensions.op_Subtraction(b1, b2);
        Sink(b4); // $ hasValueFlow=9
    }

    public void Test10()
    {
        var b1 = object.StaticProp1;
        Sink(b1); // $ hasValueFlow=10

        var b2 = MyExtensions.get_StaticProp1();
        Sink(b2); // $ hasValueFlow=10
    }

    public void Test11()
    {
        var b1 = Source<B>(11);
        object.StaticProp1 = b1;

        var b2 = Source<B>(111);
        MyExtensions.set_StaticProp1(b2);
    }

    public void Test12()
    {
        var b1 = Source<B>(12);
        b1.B2();

        var b2 = Source<B>(112);
        MyExtensions.B2(b2);
    }

    public void Test13()
    {
        var b1 = Source<B>(13);
        b1.GenericM1();

        var b2 = Source<B>(113);
        MyExtensions.GenericM1(b2);
    }

    public void Test14()
    {
        var obj = new object();
        var b1 = Source<B>(14);
        var b2 = obj.GenericM2(b1);
        Sink(b2); // $ hasValueFlow=14

        var b3 = MyExtensions.GenericM2(obj, b1);
        Sink(b3); // $ hasValueFlow=14
    }

    public static T Source<T>(object source) => throw null;
    public static void Sink(object o) { }
}

public class B { }
