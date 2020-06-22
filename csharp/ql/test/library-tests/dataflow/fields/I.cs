public class I
{
    object Field1;
    object Field2;
    public I()
    {
        Field1 = new object();
        Field2 = new object();
    }

    private void M()
    {
        var o = new object();
        var i = new I();
        i.Field1 = o;
        i.Field2 = o;
        i.Field2 = null;
        Sink(i.Field1); // flow
        Sink(i.Field2); // no flow

        i = new I();
        i.Field2 = null;
        Sink(i.Field1); // flow
        Sink(i.Field2); // no flow

        i = new I() { Field2 = null };
        Sink(i.Field1); // flow
        Sink(i.Field2); // no flow

        i = new I();
        o = new object();
        i.Field1 = o;
        i.Field2 = o;
        M2(i);
    }

    private void M2(I i)
    {
        i.Field2 = null;
        Sink(i.Field1); // flow
        Sink(i.Field2); // no flow

    }

    public static void Sink(object o) { }
}
