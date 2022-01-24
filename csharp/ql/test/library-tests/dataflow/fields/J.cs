namespace System.Runtime.CompilerServices
{
    internal static class IsExternalInit { }
}

public record class RecordClass(object Prop1, object Prop2) { }

public record struct RecordStruct(object Prop1, object Prop2) { }

public struct Struct
{
    public object Field;
    public object Prop { get; init; }
    public Struct(object field, object prop) => (Field, Prop) = (field, prop);
}

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
        var o = Source<object>(2);
        var r1 = new RecordStruct(o, null);
        Sink(r1.Prop1); // $ hasValueFlow=2
        Sink(r1.Prop2); // no flow

        var r2 = r1 with { };
        Sink(r2.Prop1); // $ hasValueFlow=2
        Sink(r2.Prop2); // no flow

        var r3 = r1 with { Prop2 = Source<object>(3) };
        Sink(r3.Prop1); // $ hasValueFlow=2
        Sink(r3.Prop2); // $ hasValueFlow=3

        var r4 = r1 with { Prop1 = null };
        Sink(r4.Prop1); // no flow
        Sink(r4.Prop2); // no flow
    }

    private void M3()
    {
        var o = Source<object>(3);
        var s1 = new Struct(o, null);

        var s2 = s1 with { };
        Sink(s2.Field); // $ hasValueFlow=3
        Sink(s2.Prop); // no flow

        var s3 = s1 with { Prop = Source<object>(4) };
        Sink(s3.Field); // $ hasValueFlow=3
        Sink(s3.Prop); // $ hasValueFlow=4

        var s4 = s1 with { Field = null };
        Sink(s4.Field); // no flow
        Sink(s4.Prop); // no flow
    }

    private void M4()
    {
        var o = Source<object>(5);
        var s1 = new Struct(null, o);

        var s2 = s1 with { };
        Sink(s2.Field); // $ no flow
        Sink(s2.Prop); // $ hasValueFlow=5

        var s3 = s1 with { Field = Source<object>(6) };
        Sink(s3.Field); // $ hasValueFlow=6
        Sink(s3.Prop); // $ hasValueFlow=5

        var s4 = s1 with { Prop = null };
        Sink(s4.Field); // no flow
        Sink(s4.Prop); // no flow
    }

    private void M5()
    {
        var o = Source<object>(7);
        object @null = null;
        var a1 = new { X = o, Y = @null };

        var a2 = a1 with { };
        Sink(a2.X); // $ hasValueFlow=7
        Sink(a2.Y); // no flow

        var a3 = a1 with { Y = Source<object>(8) };
        Sink(a3.X); // $ hasValueFlow=7
        Sink(a3.Y); // $ hasValueFlow=8

        var a4 = a1 with { X = @null };
        Sink(a4.X); // no flow
        Sink(a4.Y); // no flow
    }

    public static void Sink(object o) { }

    static T Source<T>(object source) => throw null;
}
