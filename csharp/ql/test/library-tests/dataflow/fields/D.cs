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
        var o = new object();

        var d = Create(o, null, null);
        Sink(d.AutoProp); // flow
        Sink(d.TrivialProp); // no flow
        Sink(d.trivialPropField); // no flow
        Sink(d.ComplexProp); // no flow

        d = Create(null, o, null);
        Sink(d.AutoProp); // no flow
        Sink(d.TrivialProp); // flow
        Sink(d.trivialPropField); // flow
        Sink(d.ComplexProp); // flow

        d = Create(null, null, o);
        Sink(d.AutoProp); // no flow
        Sink(d.TrivialProp); // flow
        Sink(d.trivialPropField); // flow
        Sink(d.ComplexProp); // flow
    }

    public static void Sink(object o) { }
}
