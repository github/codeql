public class NullCoalescing
{
    public void M1()
    {
        var i = Source<int?>(1);
        int? x = null;
        x = x ?? i;
        Sink(x); // $ hasValueFlow=1
    }

    public void M2()
    {
        var i = Source<int?>(2);
        int? x = null;
        x ??= i;
        Sink(x); // $ hasValueFlow=2
    }

    public void M3(int? x)
    {
        var i = Source<int?>(3);
        x = x ?? i;
        Sink(x); // $ hasValueFlow=3
    }

    public void M4(int? x)
    {
        var i = Source<int?>(4);
        x ??= i;
        Sink(x); // $ hasValueFlow=4
    }

    public static void Sink(object o) { }
    static T Source<T>(object source) => throw null;
}
