public class F
{
    object Field1;
    object Field2;

    static F Create(object o1, object o2) => new F() { Field1 = o1, Field2 = o2 };

    private void M()
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

    public static void Sink(object o) { }

    static T Source<T>(object source) => throw null;
}
