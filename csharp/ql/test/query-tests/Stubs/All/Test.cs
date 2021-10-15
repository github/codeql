using System;

namespace Test
{
    public class Class1
    {
        public struct Struct1
        {
            public ValueTuple<int> t1;
            public (int, int) t2;

            public int i;
            public const int j = 42;

            public void Method(Struct1 s = new Struct1()) => throw null;
        }

        public interface Interface1
        {
            void Method1();
        }

        internal protected interface Interface2
        {
            void Method2();
            int this[int i] { get; }
        }

        private protected interface Interface3
        {
            void Method3();
        }

        public class Class11 : Interface1, Interface2, Interface3
        {
            public Class11(int i) => throw null;

            public void Method1() => throw null;

            void Interface2.Method2() => throw null;

            int Interface2.this[int i] => throw null;

            void Interface3.Method3() => throw null;
        }

        public delegate void Delegate1<T>(T i, int j);

        public event Delegate1<int> Event1 { add { } remove { } }

        public class Class12 : Class11
        {
            public Class12(int i, float j) : base(1) => throw null;
        }

        public class GenericType<T>
        {
            public class X { }
        }

        public GenericType<int>.X Prop { get; }

        public abstract class Class13
        {
            protected internal virtual void M() => throw null;
            public virtual void M1<T>() where T : Class13 => throw null;
            public abstract void M2();
        }

        public abstract class Class14 : Class13
        {
            protected internal override void M() => throw null;
            public override void M1<T>() => throw null;
            public abstract override void M2();
        }

    }

    internal class Class2
    {
        public void M() => throw null;
    }

    public class Class3
    {
        public object Item { get; set; }
        [System.Runtime.CompilerServices.IndexerName("MyItem")]
        public object this[string index] { get { return null; } set { } }
    }

    public class Class4
    {
        unsafe public void M(int* p) => throw null;
    }

    public interface IInterface1
    {
        void M1() => throw null;
        void M2();
    }

    public class Class5 : IInterface1
    {
        public void M2() => throw null;
    }

    public class Class6<T> where T : class, IInterface1
    {
        public Class6(int i) => throw null;

        public virtual void M1<T>() where T : class, IInterface1, new() => throw null;
    }

    public class Class7 : Class6<Class5>
    {
        public Class7(int i) : base(i) => throw null;

        public override void M1<T>() where T : class => throw null;
    }

    public class Class8
    {
        public const int @this = 10;
    }

    public class Class9
    {
        private Class9(int i) => throw null;

        public class Nested : Class9
        {
            internal Nested(int i) : base(i) => throw null;
        }

        public Class9.Nested NestedInstance { get; } = new Class9.Nested(1);
    }
}

namespace A1
{
    namespace B1
    {

    }

    public class C1 { }
}

namespace A2
{
    namespace B2
    {
        public class C2 { }
    }
}

namespace A3
{
    public class C3 { }
}

namespace A4
{
    namespace B4
    {
        public class D4 { }
    }

    public class C4 { }
}