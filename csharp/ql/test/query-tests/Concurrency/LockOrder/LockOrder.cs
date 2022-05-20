using System;

class LocalTest
{
    // BAD: b is flagged.
    Object a, b, c;

    void F()
    {
        lock (a) lock (b) lock(c) { }
    }

    void G()
    {
        lock (a) lock (c) lock(b) { }
    }

    void H()
    {
        lock (a) lock(c) { }
    }
}

class GlobalTest
{
    // BAD: b is flagged.
    static Object a, b, c;

    void F()
    {
        lock (a) G();
    }

    void G()
    {
       lock (b) H();
       lock (c) I();
    }

    void H()
    {
        lock (c) { }
    }

    void I()
    {
        lock (b) { }
    }
}

class LambdaTest
{
    // BAD: a is flagged.
    static Object a, b;

    void F()
    {
        Action lock_a = () => { lock(a) { } };
        Action lock_b = () => { lock(b) { } };

        lock(a) lock_b();
        lock(b) lock_a();
    }
}
