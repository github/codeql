public class F
{
    object Field1;
    object Field2;

    static F Create(object o1, object o2) => new F() { Field1 = o1, Field2 = o2 };

    private void M1()
    {
        var o = Source<object>(1);
        var f = Create(o, null);
        Sink(f.Field1); // $ hasValueFlow=1
        Sink(f.Field2); // no flow

        f = Create(null, Source<object>(2));
        Sink(f.Field1); // no flow
        Sink(f.Field2); // $ hasValueFlow=2

        f = new F() { Field1 = Source<object>(3) };
        Sink(f.Field1); // $ hasValueFlow=3
        Sink(f.Field2); // no flow

        f = new F() { Field2 = Source<object>(4) };
        Sink(f.Field1); // no flow
        Sink(f.Field2); // $ hasValueFlow=4
    }

    private void M2()
    {
        var o = Source<object>(2);
        object @null = null;
        var a = new { X = o, Y = @null };
        Sink(a.X); // $ hasValueFlow=2
        Sink(a.Y); // no flow
    }

    public static void Sink(object o) { }

    static T Source<T>(object source) => throw null;
}
