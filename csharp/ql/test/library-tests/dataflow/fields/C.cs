public class C
{
    private Elem s1 = new Elem();
    private readonly Elem s2 = new Elem();
    private Elem s3;
    private static Elem s4 = new Elem();
    private Elem s5 { get; set; } = new Elem();
    private Elem s6 { get => new Elem(); set { } }

    void M1()
    {
        C c = new C();
        c.M2();
    }

    private C()
    {
        this.s3 = new Elem();
    }

    public void M2()
    {
        Sink(s1);
        Sink(s2);
        Sink(s3);
        Sink(s4);
        Sink(s5);
        Sink(s6);
    }

    public static void Sink(object o) { }

    public class Elem { }
}
