using System;
using System.Collections.Generic;

namespace Methods
{

    public class TestRef
    {

        static void Swap(ref int x, ref int y)
        {
            int temp = x;
            x = y;
            y = temp;
        }

        void Main()
        {
            int i = 1, j = 2;
            Swap(ref i, ref j);
            System.Console.WriteLine("{0} {1}", i, j);
            Console.WriteLine("{0} {1}", i, j);
        }
    }

    public class TestOut
    {

        public static void Divide(int x, int y, out int result, out int remainder)
        {
            result = x / y;
            remainder = x % y;
        }

        void Main()
        {
            int res, rem;
            Divide(10, 3, out res, out rem);
            Console.WriteLine("{0} {1}", res, rem);// Outputs "3 1"
        }
    }

    public class Console
    {

        public static void Write(string fmt, params object[] args) { }
        public static void WriteLine(string fmt, params object[] args) { }
    }

    class TestOverloading
    {

        static void F()
        {
            Console.WriteLine("F()");
        }

        static void F(object x)
        {
            Console.WriteLine("F(object)");
        }

        static void F(int x)
        {
            Console.WriteLine("F(int)");
        }

        static void F(double x)
        {
            Console.WriteLine("F(double)");
        }

        static void F<T>(T x)
        {
            Console.WriteLine("F<T>(T)");
        }

        static void F(double x, double y)
        {
            Console.WriteLine("F(double, double)");
        }

        void Main()
        {
            F();
            F(1);
            F(1.0);
            F("abc");
            F((double)1);
            F((object)1);
            F<int>(1);
            F(1, 1);
        }

    }

    public static class Extensions
    {

        public static int ToInt32(this string s)
        {
            return Int32.Parse(s);
        }

        public static bool ToBool(this string s, Func<string, bool> f)
        {
            return f(s);
        }

        public static T[] Slice<T>(this T[] source, int index, int count)
        {
            if (index < 0 || count < 0 || source.Length - index < count)
                throw new ArgumentException();
            T[] result = new T[count];
            Array.Copy(source, index, result, 0, count);
            return result;
        }

        public static int CallToInt32() => ToInt32("0");
    }

    static class TestExtensions
    {

        static void Main()
        {
            string[] strings = { "1", "22", "333", "4444" };
            foreach (string s in strings.Slice(1, 2))
            {
                System.Console.WriteLine(s.ToInt32());
            }

            Extensions.ToInt32("");

            Extensions.ToBool("true", bool.Parse);
        }

    }

    class TestDefaultParameters
    {
        void Method1(int x, int y)
        {
        }

        void Method2(int a, int b, int c = 1, int d = 2, string e = "a" + "b")
        {
        }

        public TestDefaultParameters(int x)
        {
        }

        public TestDefaultParameters(string x = "abc", double y = new Double())
        {
        }

        delegate int Del(string a, int b = 12, double c = new Double());

        public int this[int x, int y = 0]
        {
            get { return x + y; }
            set { }
        }
    }

    static class TestDefaultExtensionParameters
    {
        public static int Plus(this int left, int right = 0)
        {
            return left + right;
        }

        public static System.Collections.Generic.IEnumerable<T> SkipTwo<T>(this System.Collections.Generic.IEnumerable<T> list, int i = 1)
        {
            return list;
        }

        public static System.Collections.Generic.IEnumerable<int> SkipTwoInt(this System.Collections.Generic.IEnumerable<int> list, int i = 1)
        {
            return list.SkipTwo<int>(i);
        }
    }

    public class TestCollidingMethods<T>
    {
        public void M(T p1, int p2) { }
        public void M(int p1, int p2) { }

        public void Calls()
        {
            var x = new TestCollidingMethods<int>();
            x.M(1, 1);

            var y = new TestCollidingMethods<double>();
            y.M(1.0, 1);
            y.M(1, 1);
        }

        public class Nested
        {
            public Nested(int p1) { }
            public Nested(T p1)
            {
                var x = new TestCollidingMethods<int>.Nested(1);
                var y = new TestCollidingMethods<double>.Nested(1.0);
                var z = new TestCollidingMethods<double>.Nested(1);
            }
        }
    }
}
