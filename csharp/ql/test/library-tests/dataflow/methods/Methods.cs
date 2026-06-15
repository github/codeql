public partial class Partial
{
    public partial object PartialMethod(object o);
}

public partial class Partial
{
    public partial object PartialMethod(object o)
    {
        return o;
    }
}
public class C
{
    public void M()
    {
        var o = Source<object>(1);
        var p = new Partial();
        var result = p.PartialMethod(o);
        Sink(result); // $ hasValueFlow=1
    }

    public static void Sink(object o) { }

    static T Source<T>(object source) => throw null;
}
