using System;

class Foo
{
    Object a, b, c;

    void f()
    {
        lock (a) lock (b) { }
        lock (b) lock (a) { }
        lock (b) lock (a) { }
        lock (a) lock (b) { }
        lock (b) lock (c) { }
        lock (c) lock (b) { }
        lock (a) lock (a) { }
        lock (a) lock (a) { }
    }
}
