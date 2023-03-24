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

    public class Class10
    {
        unsafe public void M1(delegate* unmanaged<System.IntPtr, void> f) => throw null;
    }

    public interface IInterface2<T> where T : IInterface2<T>
    {
        static abstract T operator +(T left, T right);
        static virtual T operator -(T left, T right) => throw null;
        static abstract T operator *(T left, T right);
        static virtual T operator /(T left, T right) => throw null;
        static abstract explicit operator short(T n);
        static abstract explicit operator int(T n);
        void M1();
        void M2();
    }

    public interface IInterface3<T> where T : IInterface3<T>
    {
        static abstract T operator +(T left, T right);
        static virtual T operator -(T left, T right) => throw null;
        static abstract explicit operator short(T n);
        void M1();
    }

    public class Class11 : IInterface2<Class11>, IInterface3<Class11>
    {
        public static Class11 operator +(Class11 left, Class11 right) => throw null;
        public static Class11 operator -(Class11 left, Class11 right) => throw null;
        static Class11 IInterface2<Class11>.operator *(Class11 left, Class11 right) => throw null;
        static Class11 IInterface2<Class11>.operator /(Class11 left, Class11 right) => throw null;
        public void M1() => throw null;
        void IInterface2<Class11>.M2() => throw null;
        public static explicit operator short(Class11 n) => 0;
        static explicit IInterface2<Class11>.operator int(Class11 n) => 0;
    }

    public unsafe class MyUnsafeClass
    {
        public static void M1(delegate*<void> f) => throw null;
        public static void M2(int*[] x) => throw null;
        public static char* M3() => throw null;
        public static void M4(int x) => throw null;
    }

    public enum Enum1
    {
        None1,
        Some11,
        Some12
    }

    public enum Enum2
    {
        None2 = 2,
        Some21 = 1,
        Some22 = 3
    }

    public enum Enum3
    {
        Some32,
        Some31,
        None3
    }

    public enum Enum4
    {
        Some41 = 7,
        None4 = 2,
        Some42 = 6
    }

    public enum EnumLong : long
    {
        Some = 223372036854775807,
        None = 10
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