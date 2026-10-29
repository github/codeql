using System;
using System.IO;
using System.Collections.Generic;

namespace Fields
{
    class A
    {

        public static int X = 1, Y, Z = 100;
    }

    public class B
    {
        public static int X = 1;
        public static int Y;
        public static int Z = 100;
    }

    public class C<V>
    {

        static int count = 0;

        public C() { count++; }

        public static int Count { get { return count; } }

    }

    public class Application
    {

        public static volatile bool finished;
        static double x = Math.Sqrt(2.0);
        int i = 100;
        string s = "Hello";

        void Main()
        {
            Decimal d = Decimal.MaxValue;
            C<int> x1 = new C<int>();
            Console.WriteLine(C<int>.Count);
            C<double> x2 = new C<double>();
            Console.WriteLine(C<int>.Count);
        }

    }

    public class Color
    {

        public static readonly Color Black = new Color(0, 0, 0);
        public static readonly Color White = new Color(255, 255, 255);

        public Color(byte r, byte g, byte b) { }

    }

    public class TestBindings
    {

        static int a = b + 1;
        static int b = a + 1;

    }

}

namespace Constants
{
    public class A
    {
        public const int X = B.Z + 1;
        public const int Y = 10;
    }

    public class B
    {
        public const int Z = A.Y + 1;
    }

    public class C
    {
        public const int Foo = 1;
        public long? x;
        public C()
        {
            x = Foo;
            dynamic dyn = Foo;
            D d = Foo;
            C c = new C { x = Foo };
        }
    }

    public class D
    {
        public D(int d)
        {
        }
        static public implicit operator D(int d) { return new D(d); }
    }
}
