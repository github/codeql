using System;

public class L
{
    public string p1 { get; set; }
    public string p2 { get; set; }
    public string p3 { get; set; }
    
    private string f1;
    private string f2;
    private string f3;

    private void M1()
    {
        // dynamic property write followed by dynamic property read
        dynamic d1 = this;
        d1.p1 = Source<string>(1);
        Sink(d1.p1); // $ hasValueFlow=1

        // dynamic property write followed by static property read
        dynamic d2 = this;
        d2.p2 = Source<string>(2);
        L l2 = d2;
        Sink(l2.p2); // $ hasValueFlow=2

        // static property write followed by dynamic property read
        this.p3 = Source<string>(3);
        dynamic d3 = this;
        Sink(d3.p3); // $ hasValueFlow=3

        // dynamic property write followed by dynamic field read
        dynamic d4 = this;
        d4.f1 = Source<string>(4);
        Sink(d4.f1); // $ hasValueFlow=4

        // dynamic property write followed by static field read
        dynamic d5 = this;
        d5.f2 = Source<string>(5);
        L l5 = d5;
        Sink(l5.f2); // $ hasValueFlow=5

        // static field write followed by dynamic property read
        this.f3 = Source<string>(6);
        dynamic d6 = this;
        Sink(d6.f3); // $ hasValueFlow=6
    }

    public static void Sink(object o) { }

    static T Source<T>(object source) => throw null;
}
