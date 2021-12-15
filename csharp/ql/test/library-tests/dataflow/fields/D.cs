public class D
{
    object AutoProp { get; set; }

    object trivialPropField;
    object TrivialProp
    {
        get { return this.trivialPropField; }
        set { this.trivialPropField = value; }
    }

    object ComplexProp
    {
        get { return this.trivialPropField; }
        set { this.TrivialProp = value; }
    }

    static D Create(object o1, object o2, object o3)
    {
        var ret = new D();
        ret.AutoProp = o1;
        ret.TrivialProp = o2;
        ret.ComplexProp = o3;
        return ret;
    }

    private void M()
    {
        var o = Source<object>(1);

        var d = Create(o, null, null);
        Sink(d.AutoProp); // $ hasValueFlow=1
        Sink(d.TrivialProp); // no flow
        Sink(d.trivialPropField); // no flow
        Sink(d.ComplexProp); // no flow

        d = Create(null, Source<object>(2), null);
        Sink(d.AutoProp); // no flow
        Sink(d.TrivialProp); // $ hasValueFlow=2
        Sink(d.trivialPropField); // $ hasValueFlow=2
        Sink(d.ComplexProp); // $ hasValueFlow=2

        d = Create(null, null, Source<object>(3));
        Sink(d.AutoProp); // no flow
        Sink(d.TrivialProp); // $ hasValueFlow=3
        Sink(d.trivialPropField); // $ hasValueFlow=3
        Sink(d.ComplexProp); // $ hasValueFlow=3
    }

    public static void Sink(object o) { }

    static T Source<T>(object source) => throw null;
}
