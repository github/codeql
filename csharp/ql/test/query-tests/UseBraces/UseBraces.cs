using System;
using System.IO;

class UseBraces
{
    static void f() { }
    static void g() { }
    static void h() { }
    static void Main(string[] args)
    {
        int x = 0, y;
        var branches = new int[10];
        var py = new StreamReader("foo");

        // If-then statement

        if (1 == 1)
        {
            f();
        }
        g();  // GOOD

        if (1 == 1)
            f();
        g();    // GOOD

        if (1 == 1)
            f();
        g();  // BAD

        if (1 == 1)
            f(); g();  // BAD

        // If-then-else statement

        if (1 + 2 == 3)
        {
            f();
        }
        else
        {
            g();
        }

        g();  // GOOD

        if (1 == 2)
            f();
        else
            g();
        f();    // GOOD

        if (x > 1)
        {
            f();
        }
        else
            f();
        g();  // BAD

        if (x > 1)
        {
            f();
        }
        else
            f(); g();  // BAD

        // While statement

        while (x > 1)
        {
            f();
        }
        g();    // GOOD

        while (x > 1)
            f();
        g();

        while (x > 1)
            f();
        g();    // BAD
        g();    // GOOD

        while (x > 1)
            f(); g();    // BAD

        while (x > 1)
            if (x != null) x = 1;

        // Do-while statement

        do
            f();
        while (x > 1);
        g();  // GOOD

        // For statement
        for (int i = 0; i < 10; ++i)
        {
            f();
        }
        g();

        for (int i = 0; i < 10; ++i)
            f();
        g();

        for (int i = 0; i < 10; ++i)
            f();
        g();        // BAD

        for (int i = 0; i < 10; ++i)
            f(); g();     // BAD

        // Foreach statement

        foreach (var b in branches)
            py.Dispose();
        f();

        foreach (var b in branches)
        {
            py.Dispose();
        }
        f();

        foreach (var b in branches)
            f();
        g();      // BAD

        foreach (var b in branches)
            f(); g();   // BAD

        // Nested ifs
        if (x > 1)
            if (x > 1)
                f();
        g();

        if (x > 1)
            ;
        else
        if (x > 1)
            f();
        g();

        if (x > 1)
            ;
        else if (x > 1)
            f();
        g();  // BAD
    }
}
