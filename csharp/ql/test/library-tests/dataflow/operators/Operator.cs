public class Operators
{

    static void Sink(object o) { }
    static T Source<T>(object source) => throw null;

    public class C
    {
        public static C operator +(C x, C y) => x;

        public static C operator checked -(C x, C y) => y;
        public static C operator -(C x, C y) => x;
    }

    public void M1()
    {
        var x = Source<C>(1);
        var y = Source<C>(2);
        var z = x + y;
        Sink(z); // $ hasValueFlow=1
    }

    public void M2()
    {
        var x = Source<C>(3);
        var y = Source<C>(4);
        var z = unchecked(x - y);
        Sink(z); // $ hasValueFlow=3
    }

    public void M3()
    {
        var x = Source<C>(5);
        var y = Source<C>(6);
        var z = checked(x - y);
        Sink(z); // $ hasValueFlow=6
    }
}