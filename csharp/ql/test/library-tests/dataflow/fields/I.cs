public class I
{
    object Field1;
    object Field2;
    public I()
    {
        Field1 = Source<object>(1);
        Field2 = Source<object>(2);
    }

    private void M()
    {
        var o = Source<object>(3);
        var i = new I();
        i.Field1 = o;
        i.Field2 = o;
        i.Field2 = null;
        Sink(i.Field1); // $ hasValueFlow=3
        Sink(i.Field2); // no flow

        i = new I();
        i.Field2 = null;
        Sink(i.Field1); // $ hasValueFlow=1
        Sink(i.Field2); // no flow

        i = new I() { Field2 = null };
        Sink(i.Field1); // $ hasValueFlow=1
        Sink(i.Field2); // no flow

        i = new I();
        o = Source<object>(4);
        i.Field1 = o;
        i.Field2 = o;
        M2(i);
    }

    private void M2(I i)
    {
        i.Field2 = null;
        Sink(i.Field1); // $ hasValueFlow=4
        Sink(i.Field2); // no flow

    }

    public static void Sink(object o) { }

    static T Source<T>(object source) => throw null;
}
