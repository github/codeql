using System;

public class Test
{
    public struct S
    {
        public int field;
        public object[] args;

        public S(object[] args)
        {
            this.args = args;
        }
    }

    public void SetTainted(S s)
    {
        s.args[0] = Source<object>(2);
        s.field = Source<int>(3);
    }

    public void M1()
    {
        var o = Source<object>(1);
        var s = new S([o]);
        Sink(s.args[0]); // $ hasValueFlow=1
    }

    public void M2()
    {
        var s = new S(new object[1]);
        SetTainted(s);
        Sink(s.args[0]); // $ hasValueFlow=2
        Sink(s.field); // $ no flow.
    }

    public static void Sink(object o) { }

    static T Source<T>(object source) => throw null;
}
