namespace System.Runtime.CompilerServices
{
    internal static class IsExternalInit { }
}

public record Record(object Prop1, object Prop2) { }

public class J
{
    private void M1()
    {
        var o = new object();
        var r1 = new Record(o, null);
        Sink(r1.Prop1); // flow
        Sink(r1.Prop2); // no flow

        var r2 = r1 with { };
        Sink(r2.Prop1); // flow
        Sink(r2.Prop2); // no flow

        var r3 = r1 with { Prop2 = o };
        Sink(r3.Prop1); // flow
        Sink(r3.Prop2); // flow

        var r4 = r1 with { Prop1 = null };
        Sink(r4.Prop1); // no flow
        Sink(r4.Prop2); // no flow
    }

    public static void Sink(object o) { }
}
