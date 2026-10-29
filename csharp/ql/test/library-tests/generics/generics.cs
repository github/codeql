using System;
using System.IO;
using System.Collections.Generic;

namespace generics
{
    public delegate T GenericDelegate<T>(ref T t);

    public class A
    {
    }

    public class A<T>
    {

        public delegate U GenericDelegateInGenericClass<U>(T t, U u);

        public T bar<X>(X x, T t) where X : new() { A<T> a; return t; }

    }

    public class B<T> where T : class
    {

        internal A<T> at;

        string name;

        public void foo() { }

        public void fooParams(params T[] ts) { }

        public static void staticFoo() { }

        public string Name { get { return name; } set { name = value; } }

        public event GenericDelegate<T> myEvent;

        public static B<T> operator ++(B<T> a)
        {
            return new B<T>();
        }

        ~B() { }
        void f<X>() where X : class { new B<X>(); }
    }

    public class Outer<T1, T2>
    {

        public class Inner<U1, U2> where U1 : T1
        {

            public T1 t;
            public Func<U1, T1> myFunc;
            public void MyMethod<W1, W2>(W1 a, W2 b, U2 c, T2 d) => throw null;
        }
    }

    public class Grid<T> where T : struct
    {

        const int NumRows = 26;
        const int NumCols = 10;

        T[,] cells = new T[NumRows, NumCols];

        public int this[int i]
        {
            get { return i; }
        }

        public T this[char c, int col]
        {
            get
            {
                c = Char.ToUpper(c);
                if (c < 'A' || c > 'Z')
                {
                    throw new ArgumentException();
                }
                if (col < 0 || col >= NumCols)
                {
                    throw new IndexOutOfRangeException();
                }
                return cells[c - 'A', col];
            }
            set
            {
                c = Char.ToUpper(c);
                if (c < 'A' || c > 'Z')
                {
                    throw new ArgumentException();
                }
                if (col < 0 || col >= NumCols)
                {
                    throw new IndexOutOfRangeException();
                }
                cells[c - 'A', col] = value;
            }
        }

    }

    class Test
    {

        void Main()
        {
            B<String> bs = new B<String>();
            bs.at = new A<String>();
            bs.foo();
            bs.fooParams("a", "b");

            B<Object>.staticFoo();

            bs.Name = "";
            bs.myEvent += new GenericDelegate<string>(f);
            bs++;

            Grid<int> g = new Grid<int>();
            int j = g['e', 1];

            new Outer<object, int>.Inner<string, int>().t = 3;
            new Outer<object, bool>.Inner<object, string>().MyMethod<double, int>(1.0, 2, "3", true);

            new A<string>().bar(2, "");
            new A<int>().bar(new Test(), 2);
        }

        string f(ref string s) { return s; }

    }

    class Subtle
    {

        public void fs<X>(int i) { }

        public void fs<X>(int i, int j) { }

        public void fs(int i) { }

    }

    class Param<T>
    {
        enum E { x };
    }

    class ConstructedMethods
    {
        void CM1<T>() { }
        T CM2<T>(T t) { return t; }

        class Class<T1>
        {
            public T2 CM3<T2>(T2 t, T1 t1) { return t; }
        }

        void NonCM() { }

        void CM()
        {
            CM1<int>();
            CM1<double>();
            CM2(4);
            CM2(2.0);
            new Class<int>().CM3(1.0, 2);
            new Class<double>().CM3(1.0, 2.0);
        }
    }

    interface Interface<T>
    {
        void set(T t);
    }

    class Inheritance<T> : Interface<T>
    {
        public void set(T t) { }
    }

    class InheritanceTest
    {
        Inheritance<int> member;
    }

    interface Interface2<in T1, out T2>
    {
        T2 M(T1 x);
    }
}
