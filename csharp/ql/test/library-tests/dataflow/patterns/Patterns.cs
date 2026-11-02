using System;

public record class RecordClass(object Prop) { }

public record class Nested(RecordClass Record) { }

public class C1<T>
{
    public T Prop { get; set; }
}

public class C2
{
    public string Field;
}

public class RecordPatterns
{
    private void M1()
    {
        var o = Source<object>(1);
        var r = new RecordClass(o);
        if (r is RecordClass { Prop: object p })
        {
            Sink(p); // $ hasValueFlow=1
        }
    }

    private void M2()
    {
        var o = Source<object>(2);
        var r = new RecordClass(o);
        switch (r)
        {
            case RecordClass { Prop: object p }:
                Sink(p); // $ hasValueFlow=2
                break;
        }
    }

    private void M3()
    {
        var o = Source<object>(3);
        var s = new Nested(new RecordClass(o));
        if (s is Nested { Record: { Prop: object p } })
        {
            Sink(p); // $ hasValueFlow=3
        }
    }

    private void M4()
    {
        var o = Source<object>(4);
        var s = new Nested(new RecordClass(o));
        if (s is Nested { Record.Prop: object p })
        {
            Sink(p); // $ hasValueFlow=4
        }
    }

    public void M5()
    {
        var o = Source<object>(5);
        var c = new C1<object> { Prop = o };
        if (c is C1<object> { Prop: object p })
        {
            Sink(p); // $ hasValueFlow=5
        }
    }

    public void M6()
    {
        var o = Source<object>(6);
        var s = new Nested(new RecordClass(o));
        if (s is Nested { Record: RecordClass { Prop: var _ } r })
        {
            Sink(r.Prop); // $ hasValueFlow=6
        }
    }

    public void M7()
    {
        var o1 = Source<object>(7);
        var o2 = Source<object>(8);
        var t = (new Nested(new RecordClass(o1)), o2);
        switch (t)
        {
            case (Nested { Record: { Prop: object p } }, var o):
                Sink(p); // $ hasValueFlow=7
                Sink(o); // $ hasValueFlow=8
                break;
        }
    }

    public void M8()
    {
        var s = Source<string>(9);
        var c = new C2 { Field = s };
        if (c is C2 { Field: string p })
        {
            Sink(p); // $ hasValueFlow=9
        }
    }

    public static void Sink(object o) { }

    static T Source<T>(object source) => throw null;
}
