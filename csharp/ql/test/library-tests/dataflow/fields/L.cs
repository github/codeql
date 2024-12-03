using System;

public class L
{
    public string f1 { get; set; }
    public string f2 { get; set; }
    public string f3 { get; set; }

    private void M1()
    {
        // dynamic write followed by dynamic read
        dynamic d1 = this;
        d1.f1 = Source<string>(1);
        Sink(d1.f1); // $ MISSING: hasValueFlow=1

        // dynamic write followed by static read
        dynamic d2 = this;
        d2.f2 = Source<string>(2);
        L l2 = d2;
        Sink(l2.f2); // $ MISSING: hasValueFlow=2

        // static write followed by dynamic read
        this.f3 = Source<string>(3);
        dynamic d3 = this;
        Sink(d3.f3); // $ MISSING: hasValueFlow=3
    }

    public static void Sink(object o) { }

    static T Source<T>(object source) => throw null;
}
