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

public partial class DPartial
{
    private object _backingField;
    public partial object PartialProp1
    {
        get { return _backingField; }
        set { _backingField = value; }
    }

    public partial object PartialProp2
    {
        get { return null; }
        set { }
    }
}

public partial class DPartial
{
    public partial object PartialProp1 { get; set; }
    public partial object PartialProp2 { get; set; }

    public void M()
    {
        var o = Source<object>(1);

        var d = new DPartial();
        d.PartialProp1 = o;
        d.PartialProp2 = o;

        Sink(d.PartialProp1); // $ hasValueFlow=1
        Sink(d.PartialProp2); // no flow
    }

    public static void Sink(object o) { }

    static T Source<T>(object source) => throw null;
}

public class DFieldProps
{
    object FieldProp0
    {
        get { return field; }
        set { field = value; }
    } = Source<object>(0);

    object FieldProp1
    {
        get { return field; }
        set { field = value; }
    }

    object FieldProp2
    {
        get { return field; }
        set
        {
            var x = value;
            field = x;
        }
    }

    static object StaticFieldProp
    {
        get { return field; }
        set { field = value; }
    }

    private void M()
    {
        var d0 = new DFieldProps();
        Sink(d0.FieldProp0); // $ hasValueFlow=0
        Sink(d0.FieldProp1); // no flow
        Sink(d0.FieldProp2); // no flow

        var d1 = new DFieldProps();
        var o1 = Source<object>(1);
        d1.FieldProp1 = o1;
        Sink(d1.FieldProp0); // $ hasValueFlow=0
        Sink(d1.FieldProp1); // $ hasValueFlow=1
        Sink(d1.FieldProp2); // no flow

        var d2 = new DFieldProps();
        var o2 = Source<object>(2);
        d2.FieldProp2 = o2;
        Sink(d2.FieldProp0); // $ hasValueFlow=0
        Sink(d2.FieldProp1); // no flow
        Sink(d2.FieldProp2); // $ hasValueFlow=2

        var o3 = Source<object>(3);
        DFieldProps.StaticFieldProp = o3;
        Sink(DFieldProps.StaticFieldProp); // $ hasValueFlow=3
    }

    public static void Sink(object o) { }

    static T Source<T>(object source) => throw null;

}
