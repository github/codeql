using System;

class Foo
{
    Object o = new Object(), o2 = new Object();

    void f(Object o2)
    {
    }

    void test()
    {
        lock (o) // $ Alert
        {
            o = new Foo();    // BAD
        }

        lock (o) // $ Alert
        {
            f(o = null);    // BAD
        }

        lock (o2)
        {
            o = new Foo();  // GOOD
        }

        lock (o2) // $ Alert
        {
            GetNewObject(out o2); // BAD
        }
    }

    static void GetNewObject(out object o)
    {
        o = new Object();
    }
}

