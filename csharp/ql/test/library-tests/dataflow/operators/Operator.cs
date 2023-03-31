public class Operators
{

    static void Sink(object o) { }
    static T Source<T>(object source) => throw null;

    public interface I<T> where T : I<T>
    {
        static virtual T operator *(T x, T y) => x;
        static abstract T operator /(T x, T y);
        static abstract T operator checked /(T x, T y);
    }

    public class C : I<C>
    {
        public static C operator +(C x, C y) => x;

        public static C operator checked -(C x, C y) => y;
        public static C operator -(C x, C y) => x;

        public static C operator /(C x, C y) => y;
        public static C operator checked /(C x, C y) => y;
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

    public void M4Aux<T>(T x, T y) where T : I<T>
    {
        var z = x * y;
        Sink(z); // $ hasValueFlow=7
    }

    public void M4()
    {
        var x = Source<C>(7);
        var y = Source<C>(8);
        M4Aux(x, y);
    }

    public void M5Aux<T>(T x, T y) where T : I<T>
    {
        var z = x / y;
        Sink(z); // $ hasValueFlow=10
    }

    public void M5()
    {
        var x = Source<C>(9);
        var y = Source<C>(10);
        M5Aux(x, y);
    }

    public void M6Aux<T>(T x, T y) where T : I<T>
    {
        var z = checked(x / y);
        Sink(z); // $ hasValueFlow=12
    }

    public void M6()
    {
        var x = Source<C>(11);
        var y = Source<C>(12);
        M6Aux(x, y);
    }
}