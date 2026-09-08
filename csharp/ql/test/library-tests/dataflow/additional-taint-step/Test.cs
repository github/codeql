class Marker
{
    // A stand-in for a framework method that isn't otherwise understood by the
    // taint-tracking library, whose taint behaviour is modelled by a test-only
    // `AdditionalTaintStep` subclass instead.
    public static object Step(object x) => new object();
}

class Test
{
    void M(object taintSource)
    {
        var tainted = Marker.Step(taintSource);
        Sink(tainted);
    }

    static void Sink(object o) { }
}
