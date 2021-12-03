interface I
{
    void g();
}

class C : I
{
    public void f(int x) { }

    // BAD: This method is a forwarder
    public void f()
    {
        f(1);
    }

    // GOOD: This forwarder implements an interface
    void I.g()
    {
        g(1);
    }

    void g(int x) { }

    // GOOD: Not a forwarder
    void h<T>(int a)
    {
        h<T>();
    }

    // GOOD: Not a forwarder
    void h<T>(double b)
    {
        h<T>();
    }

    void h<T>() { }

    void i<T>() { }

    // BAD: Forwarding method
    void i<T>(int a)
    {
        i<T>();
    }
}
