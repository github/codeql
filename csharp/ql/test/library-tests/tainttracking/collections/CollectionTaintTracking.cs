public class CollectionTaintTracking
{
    public void ImplicitCollectionReadAtSink()
    {
        var tainted = Source<object>(1);
        var arr = new object[] { tainted };
        Sink(arr); // $ hasTaintFlow=1
    }

    static T Source<T>(object source) => throw null;

    public static void Sink<T>(T t) { }
}
