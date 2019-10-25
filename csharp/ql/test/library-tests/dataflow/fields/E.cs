public class E
{
    struct S
    {
        public object Field;
    }

    static S CreateS(object o)
    {
        var ret = new S();
        ret.Field = o;
        return ret;
    }

    static void NotASetter(S s, object o)
    {
        s.Field = o;
    }

    private void M()
    {
        var o = new object();
        var s = CreateS(o);
        Sink(s.Field); // flow

        s = new S();
        NotASetter(s, o);
        Sink(s.Field); // no flow
    }

    public static void Sink(object o) { }
}
