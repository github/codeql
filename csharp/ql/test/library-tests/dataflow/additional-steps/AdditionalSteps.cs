class AdditionalSteps
{
    class A
    {
        public static string M1(int arg)
        {
            Sink(arg);
            return arg.ToString();
        }

        public static decimal M2(bool arg) => throw null;

        public int Field;

        public int M3() => this.Field;

        public object M4() => throw null;
    }

    static void M1()
    {
        var b = false;
        var d = A.M2(b);
        Sink(d);
    }

    static void M2()
    {
        var a = new A();
        a.Field = 0;
        var o = a.M4();
        Sink(o);
    }

    static void Sink<T>(T x) { }
}
