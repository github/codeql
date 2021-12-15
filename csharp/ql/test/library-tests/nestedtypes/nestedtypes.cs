using System;
using System.IO;
using System.Collections.Generic;

namespace NestedTypes
{

    public class Base
    {

        protected struct S { }

        private interface I { }

        delegate I MyDelegate(S s);

        protected void F()
        {
            Console.WriteLine("Base.F");
        }

        public static class C { }

    }

    class Derived : Base
    {

        public class Nested
        {

            public void G()
            {
                Derived d = new Derived();
                d.F();  // ok
            }

        }

    }

    class Test
    {

        static void Main()
        {
            Derived.Nested n = new Derived.Nested();
            n.G();
        }

    }

    class Outer<T>
    {

        class Inner<U>
        {

            public static void F(T t, U u) { }

        }

        static void F(T t)
        {
            Outer<T>.Inner<string>.F(t, "abc"); // These two statements have
                                                //Inner<string>.F(t, "abc");  // the same effect, but the second fails to compile with Mono

            Outer<int>.Inner<string>.F(3, "abc"); // This type is different
            Type type = typeof(Outer<>.Inner<>);
        }

    }

    class Outer2<T>
    {

        class Inner2<T>
        {

            public T t;

        }

    }
}
