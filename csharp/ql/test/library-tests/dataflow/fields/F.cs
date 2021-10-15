public class F
{
    object Field1;
    object Field2;

    static F Create(object o1, object o2) => new F() { Field1 = o1, Field2 = o2 };

    private void M()
    {
        var o = new object();
        var f = Create(o, null);
        Sink(f.Field1); // flow
        Sink(f.Field2); // no flow

        f = Create(null, o);
        Sink(f.Field1); // no flow
        Sink(f.Field2); // flow

        f = new F() { Field1 = o };
        Sink(f.Field1); // flow
        Sink(f.Field2); // no flow

        f = new F() { Field2 = o };
        Sink(f.Field1); // no flow
        Sink(f.Field2); // flow
    }

    public static void Sink(object o) { }
}
