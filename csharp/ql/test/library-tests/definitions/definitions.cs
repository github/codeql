using System;
using System.Collections.Generic;

namespace N1
{
    static class StaticClass
    {
        public static void ExtensionMethod(this C1 c1, params object[] args)
        {
        }
    }

    enum Enumeration
    {
        e1 = 1, e2 = 2, e3
    }

    class C1
    {
        public C1(params int[] args) { }

        int field1;

        public int property1
        {
            get { return field1; }
            set { field1 = value; }
        }

        void f1(params int[] args)
        {
            var qualifier = this;

            // MethodCallUse
            f1();
            f1(1);
            f1(1, 2);

            this.f1();
            this.f1(1);
            this.f1(1, 2);

            this.ExtensionMethod();
            this.ExtensionMethod(1);
            this.ExtensionMethod(1, 2);

            GenericFn(1);
            this.GenericFn(2);

            // ConstructorCallUse
            new C1();
            new C1(1);
            new C1(1, 2);

            // VariableUse
            int x = 2, y = x, z = field1, w = args[0];
            Enumeration e = Enumeration.e1;

            // PropertyUse
            property1 = property1 + 1;

            // VariableTypeUse
            C1[] array = null;
            S1? nullable = null;

            // MethodUse
            Action<int> m1 = GenericFn<int>;
        }

        void VariableTypeUse(C1 c1)
        {
            C1 c2 = null;
        }

        void GenericFn<T>(T t) { }
    }

    struct S1
    {
        S1 M(S1[] ss)
        {
            try
            {
                string timestamp = DateTime.Now.ToString("HH:mm:ss");
            }
            catch (Exception e)
            {
                foreach (var s in ss)
                {
                }
            }
            var temp = typeof(S1[]);
            return new S1();
        }
    }

    class A
    {
        public delegate void EventHandler();

        public event EventHandler Click;

        protected virtual void M()
        {
            Click += M;
            void LocalFunction() { };
            Click += LocalFunction;
            Click();
        }
    }

    interface I1
    {
        void M2<T>() where T : A;
    }

    interface I2<T> where T : class { }

    interface I3 : I2<object> { }

    class B<T> : A, I1, I2<A> where T : A
    {
        protected override void M()
        {
            base.M();
        }

        void I1.M2<T>() { }

        struct S<T2> : I3 where T2 : struct { }

        (I1, B<A>) Tuple() => throw new Exception();

        B<A> this[A a] { get { return default(B<A>); } }
    }

    unsafe class C
    {
        enum E { }
        E* Pointer() => throw new Exception(sizeof(E*).ToString());
    }

    interface I4
    {
        event A.EventHandler EH;
        A M();
        I3 P { get; }
        S1 this[A.EventHandler eh] { get; }
    }

    class C4 : I4
    {
        event A.EventHandler I4.EH { add { } remove { } }
        A I4.M() => throw new Exception();
        I3 I4.P => throw new Exception();
        S1 I4.this[A.EventHandler eh] { get { return (S1)new S1(); } }

        public class Nested<T>
        {
            public static Nested<T> Create() { return new Nested<T>(); }
        }
    }

    class C5
    {
        N1.C4.Nested<I4> f = C4.Nested<I4>.Create();
        C1 c1;

        void M()
        {
            N1.C1 c = new N1.C1();
            c.property1 = c.property1;
            var c5 = new C5() as C5;
            c5.c1.property1 = 0;
            var temp = c5 is N1.C4.Nested<I4>;
        }
    }

    class C6
    {
        public static explicit operator C5([My()] C6 c)
        {
            return null;
        }

        C5 M()
        {
            return (C5)this;
        }

        public static C6 operator +(C6 x, C6 y) => x;
    }

    class MyAttribute : Attribute { }

    class C7
    {
        public static void M() { }

        void M2()
        {
            C7.M();
        }
    }

    class C8
    {
        void F()
        {
            C8 c8a = null;
            if (c8a is C8 c8b)
                c8a = c8b;
            switch (c8a)
            {
                case C8 c8c when c8c != null:
                    c8a = c8c;
                    break;
            }
        }
    }
}
