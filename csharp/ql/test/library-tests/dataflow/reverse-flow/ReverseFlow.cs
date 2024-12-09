public class A
{
    public string Field;

    public A Nested;

    public void M1()
    {
        var a = new A();
        M2(a);
        Sink(a.Nested.Field); // $ hasValueFlow=1
    }

    public void M2(A a)
    {
        var b = a.Nested;
        M3(b);
    }

    public void M3(A a)
    {
        a.Field = Source<string>(1);
    }

    public void M4()
    {
        this.M5();
        Sink(this.Nested.Field); // $ hasValueFlow=2
    }

    public void M5()
    {
        var b = this.Nested;
        b.M6();
    }

    public void M6()
    {
        this.Field = Source<string>(2);
    }

    public void M7()
    {
        var a = new A();
        M8(a);
        Sink(a.Field); // $ hasValueFlow=3
    }

    public void M8(A a)
    {
        var b = new A();
        b.Nested = a;
        M9(b);
    }

    public void M9(A a)
    {
        a.Nested.Field = Source<string>(3);
    }

    public void M10()
    {
        var a = new A();
        Sink(a);
        Sink(a.Nested.Nested.Field);
        GetNestedNested(a).Field = Source<string>(4);
        Sink(a.Nested.Nested.Field); // $ hasValueFlow=4
    }

    public void M11(A a)
    {

    }

    public void M12()
    {
        var a = new A();
        M11(a);
        Sink(a.Field);
        a.Field = Source<string>(5);
        Sink(a.Field); // $ hasValueFlow=5
    }

    public A GetNestedNested(A a) => a.Nested.Nested;

    public static void Sink(object o) { }

    static T Source<T>(object source) => throw null;
}
