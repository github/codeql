using System;

public record class RecordClass2(object Prop) { }

public record class Nested(RecordClass2 Record) { }

public class RecordPatterns
{
    private void M1()
    {
        var o = Source<object>(1);
        var r = new RecordClass2(o);
        if (r is RecordClass2 { Prop: object p })
        {
            Sink(p); // $ MISSING: hasValueFlow=1
        }
    }

    private void M2()
    {
        var o = Source<object>(2);
        var r = new RecordClass2(o);
        switch (r)
        {
            case RecordClass2 { Prop: object p }:
                Sink(p); // $ MISSING: hasValueFlow=2
                break;
        }
    }

    private void M3()
    {
        var o = Source<object>(3);
        var s = new Nested(new RecordClass2(o));
        if (s is Nested { Record: { Prop: object p } })
        {
            Sink(p); // $ MISSING: hasValueFlow=3
        }
    }

    private void M4()
    {
        var o = Source<object>(4);
        var s = new Nested(new RecordClass2(o));
        if (s is Nested { Record.Prop: object p })
        {
            Sink(p); // $ MISSING: hasValueFlow=4
        }
    }

    public static void Sink(object o) { }

    static T Source<T>(object source) => throw null;
}
