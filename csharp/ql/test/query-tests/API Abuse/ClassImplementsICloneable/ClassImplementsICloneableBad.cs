using System;

class Bad
{
    class Thing
    {
        public int I { get; set; }
        public Thing(int i) { I = i; }
    }

    class Shallow : ICloneable
    {
        public Thing T { get; set; }
        public Shallow(Thing t) { T = t; }

        // Implements a shallow clone (compliant with the spec)
        public object Clone() { return new Shallow(T); }
    }

    class Deep : ICloneable
    {
        public Thing T { get; set; }
        public Deep(Thing t) { T = t; }

        // Implements a deep clone (also compliant with the spec)
        public object Clone() { return new Deep(new Thing(T.I)); }
    }

    static void Main(string[] args)
    {
        var s1 = new Shallow(new Thing(23));
        var s2 = (Shallow)s1.Clone();
        Console.WriteLine(s2.T.I); // 23
        s1.T.I = 9;
        Console.WriteLine(s2.T.I); // 9

        var d1 = new Deep(new Thing(23));
        var d2 = (Deep)d1.Clone();
        Console.WriteLine(d2.T.I); // 23
        d1.T.I = 9;
        Console.WriteLine(d2.T.I); // 23
    }
}
