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

    private void M1()
    {
        var o = Source<object>(1);
        var s = CreateS(o);
        Sink(s.Field); // $ hasValueFlow=1

        s = new S();
        NotASetter(s, o);
        Sink(s.Field); // no flow
    }

    ref struct RefS
    {
        public object Field;
        public ref object RefField;

        public RefS(object o1, ref object o2)
        {
            Field = o1;
            RefField = ref o2;
        }
    }

    static void PartialSetter(RefS s, object o)
    {
        s.Field = o;
        s.RefField = o;
    }

    private void M2()
    {
        var o1 = new object();
        var o2 = new object();
        var refs = new RefS(o1, ref o2);
        var taint = Source<object>(2);
        PartialSetter(refs, taint);
        Sink(refs.Field); // no flow
        Sink(refs.RefField); // $ hasValueFlow=2
    }

    public static void Sink(object o) { }

    static T Source<T>(object source) => throw null;
}
