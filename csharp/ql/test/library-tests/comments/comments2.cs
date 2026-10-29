// Start of comment2.cs
// Unassociated

using System;
using System.Collections; // Unassociated
using System.Collections.Generic;

// Unassociated

/// C2
class C2
{
    int field1; // field1
    int field2; // field2

    // C2

    // f
    void f()
    {
        // {...}

        f();  // ...;

        // ...;
        g(2);
    }

    void g(int x)
    {
        // ...;
        int y = 0;
        // {...}
        int z = 0;

        // {...}
    }

    // C3
    class C3
    {
        // C3
    }

    // C2

    // S1
    string S1
    {
        // S1

        get { return ""; } // {...}
        set // S1
        {
            // {...}
        } // {...}
    }
    // S1

    // Values
    enum Values
    {
        // Values

        // First
        First,  // First
        Second, // Second

        // Values
        //

        // Third
        Third

        // Values
    }

    // C2 Constructor
    C2() // C2 Constructor
    {
        // {...}
    }

    // ~C2
    ~C2() // ~C2
    {
    }

    // +
    public static int operator +(C2 x, C2 b) // +
    {
        return 2;
    }

    void f(
      int x,  // x
      int y // y
      )
    {
    }

    // D
    public delegate void D(); // D
                              // D

    // E
    public event D E; // E
                      // E

    void gen()
    {
        var t1 = new GenericClass<int>();
        var t2 = GenericFn<int>();
        var t3 = new GenericClass<double>();
        var t4 = GenericFn<double>();
    }

    // GenericClass<>
    class GenericClass<T>
    {
        int f;  // f
    }

    // GenericFn
    int GenericFn<T>()
    {
        int x = 0; // x
        return 0;
    }
}

// End of comment2.cs
