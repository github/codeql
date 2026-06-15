using System;
using System.IO;
using System.Collections.Generic;

namespace Delegates
{
    delegate double FooDelegate(ref string param, out bool condition, params string[] args);

    delegate int D1(int i, double d);

    class A
    {

        public static int M1(int a, double b) { return (int)(a + b); }

    }

    class B
    {

        delegate int D2(int c, double d);

        public static int M1(int f, double g) { return f - (int)g; }

        public static void M2(int k, double l) { }

        public static int M3(int g) { return -g + (+g); }

        public static void M4(int g) { }

    }

    delegate bool Predicate<T>(T value);

    public class X
    {

        public static bool F(int i) { return i < 2; }

        public static bool G(string s) { return false; }

    }

    delegate void D(int x);

    class C
    {

        public static void M1(int i) { }
        public static void M2(int i) { }
        public void M3(int i) { }

    }

    class Test
    {

        static void Main()
        {
            D cd1 = new D(C.M1); // instantiation with a static method
            D cd2 = C.M2; // direct assignment
            D cd3 = cd1 + cd2; // combination
            D cd4 = cd3 + cd1;
            D cd5 = cd4 - cd3; // removal
            cd4 += cd5; // another style for combination
            cd4 -= cd1; // another style for removal

            C c = new C();
            D cd6 = new D(c.M3); // instantiation with an instance method
            D cd7 = new D(cd6); // instantiation with an existing delegate variable

            cd1(-40); // invocation
            int x = 0;
            cd7(34 + x);

            Predicate<int> pi = new Predicate<int>(X.F); // generic instantiation
            Predicate<string> ps = X.G; // direct generic assignment

            bool b = pi(3) & ps(""); // generic invocation

            System.Threading.ContextCallback d; // assembly delegate
        }

    }

    unsafe class E
    {
        Action<int> Field;
        Action<int> Property { get; set; }
        delegate*<int, void> FieldPtr;
        delegate*<int, void> PropertyPtr { get; set; }

        unsafe void M()
        {
            this.Field(0);
            this.Property(0);
            Field(0);
            Property(0);
            this.FieldPtr(0);
            this.PropertyPtr(0);
            FieldPtr(0);
            PropertyPtr(0);
        }
    }
}
