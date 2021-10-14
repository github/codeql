public class C
{
    private Elem s1 = Source<Elem>(1);
    private readonly Elem s2 = Source<Elem>(2);
    private Elem s3;
    private static Elem s4 = Source<Elem>(4);
    private Elem s5 { get; set; } = Source<Elem>(5);
    private Elem s6 { get => Source<Elem>(6); set { } }

    void M1()
    {
        C c = new C();
        c.M2();
    }

    private C()
    {
        this.s3 = Source<Elem>(3);
    }

    public void M2()
    {
        Sink(s1); // $ hasValueFlow=1
        Sink(s2); // $ hasValueFlow=2
        Sink(s3); // $ hasValueFlow=3
        Sink(s4); // $ hasValueFlow=4
        Sink(s5); // $ hasValueFlow=5
        Sink(s6); // $ hasValueFlow=6
    }

    public static void Sink(object o) { }

    static T Source<T>(object source) => throw null;

    public class Elem { }
}
