namespace System.Runtime.CompilerServices
{
    internal static class IsExternalInit { }
}

public record class RecordClass(object Prop1, object Prop2) { }

public record struct RecordStruct(object Prop1, object Prop2) { }

public class J
{
    private void M1()
    {
        var o = Source<object>(1);
        var r1 = new RecordClass(o, null);
        Sink(r1.Prop1); // $ hasValueFlow=1
        Sink(r1.Prop2); // no flow

        var r2 = r1 with { };
        Sink(r2.Prop1); // $ hasValueFlow=1
        Sink(r2.Prop2); // no flow

        var r3 = r1 with { Prop2 = Source<object>(2) };
        Sink(r3.Prop1); // $ hasValueFlow=1
        Sink(r3.Prop2); // $ hasValueFlow=2

        var r4 = r1 with { Prop1 = null };
        Sink(r4.Prop1); // no flow
        Sink(r4.Prop2); // no flow
    }

    private void M2()
    {
        var o = Source<object>(1);
        var r1 = new RecordStruct(o, null);
        Sink(r1.Prop1); // $ hasValueFlow=1
        Sink(r1.Prop2); // no flow
    }

    public static void Sink(object o) { }

    static T Source<T>(object source) => throw null;
}
