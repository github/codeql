using System;

namespace Namespace
{
    interface Interface
    {
        int Property { get; set; }

        int Fn(int p);
    }

    class Class
    {
        delegate void D();

        event D e;

        static void Main(string[] args)
        {
        }

        public static explicit operator int(Class c) => 0;
        public static int operator +(Class c1, Class c2) => 0;
    }

    [My]
    enum Enum
    {
        [My] E1, E2, E3
    }

    class MyAttribute : Attribute
    {
    }
}
