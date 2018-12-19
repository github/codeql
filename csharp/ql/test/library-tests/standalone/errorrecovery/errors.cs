/*
  This contains various errors which would normally result in an extraction failure.

  semmle-extractor-options: --standalone
*/

// Error: Missing reference
using NoSuchAssembly1;
using static NoSuchAssembly2.NoSuchClass;

using System;

namespace ErrorRecovery
{
    class C1
    {
        // Error: f1 has type null
        ErrorType f1;

        public void m1()
        {
            // Error: Unknown target.
            // Error: type of unknownType is unknown
            var unknownType = f1.run(f1);

            // Error: syntax error
            1 + 2
        }
    }

  // Error: syntax error
  1+2

  // Error: Duplicate class
  class C1
    {
        void m1(int p)
        {
        }

        void m2()
        {
            C1 c1 = new C1();
            c1.m1();
            c1.m2();
            Console.WriteLine("Hello");
        }
    }

    class C2
    {
        C1 c1;  // Error: C1 is ambiguous
        C2 c2 = new C2(5);  // Error: Wrong constructor arguments

        ErrorType f(ErrorType x)
        {
            return x;
        }

        // Error: Syntax error
        int f2(int x
        {
            return x;
        }
    }

    class C3
    {
        virtual void M();
    }

    class C4
    {
        virtual void M(int p1, string p2, bool p3 = true, bool p4 = false)
        {
            var x = 1;
            var x = p1;
        }
    }

    class C5 : C3
    {
        int P => 2 + 3;
        int F = 3 + 4;
        override void M { }
    }

    class C5 : C4
    {
        int P => 2 + 3;
        int F = 3 + 4;
        virtual void M { }
        Func<int, int, int> a = (x1, x2) => x;
        Func<int, int, int> a = (y1, y2) => y;
    }

    namespace A
    {
        namespace B { }
    }

    namespace C
    {
        namespace B { }
    }
}
