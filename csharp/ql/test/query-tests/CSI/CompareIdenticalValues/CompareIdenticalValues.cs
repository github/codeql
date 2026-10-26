using System;
using System.Diagnostics;

class Super
{
    protected int Foo;
    protected virtual string Bar { get; set; }
}

class CompareIdenticalValues : Super
{
    public void M()
    {
        if (this.Foo == Foo) ; // $ Alert[cs/comparison-of-identical-expressions]
        if (base.Foo == Foo) ; // $ Alert[cs/comparison-of-identical-expressions]
        if (Foo == new CompareIdenticalValues().Foo) ;

        var x = "Abc";
        if (x == "Abc") ;
        var temp = x == x; // $ Alert[cs/constant-condition]

        double d = double.NaN;
        if (d == d) ; // $ Alert[cs/comparison-of-identical-expressions] // !double.IsNan(d)
        if (d <= d) ; // $ Alert[cs/comparison-of-identical-expressions] // !double.IsNan(d), but unlikely to be intentional
        if (d >= d) ; // $ Alert[cs/comparison-of-identical-expressions] // !double.IsNan(d), but unlikely to be intentional
        if (d != d) ; // $ Alert[cs/comparison-of-identical-expressions] // double.IsNan(d)
        if (d > d) ; // $ Alert[cs/comparison-of-identical-expressions] // always false
        if (d < d) ; // $ Alert[cs/comparison-of-identical-expressions] // always false

        float f = float.NaN;
        if (f == f) ; // $ Alert[cs/comparison-of-identical-expressions] // !float.IsNan(f)
        if (f <= f) ; // $ Alert[cs/comparison-of-identical-expressions] // !float.IsNan(f), but unlikely to be intentional
        if (f >= f) ; // $ Alert[cs/comparison-of-identical-expressions] // !float.IsNan(f), but unlikely to be intentional
        if (f != f) ; // $ Alert[cs/comparison-of-identical-expressions] // float.IsNan(f)
        if (f > f) ; // $ Alert[cs/comparison-of-identical-expressions] // always false
        if (f < f) ; // $ Alert[cs/comparison-of-identical-expressions] // always false

        int i = 0;
        if (i == i) ; // $ Alert[cs/constant-condition]
        if (i != i) ; // $ Alert[cs/constant-condition]

        CompareIdenticalValues c = null;
        c.Prop.Equals(c.Prop); // $ Alert[cs/comparison-of-identical-expressions]
        Equals(c.Prop.Prop.Prop.Foo + 2, c.Prop.Prop.Prop.Foo + 2); // $ Alert[cs/comparison-of-identical-expressions]
        Equals(c.Prop.Prop.Prop.Foo, c.Prop.Prop.Foo);

        if (base.Bar == Bar) ;
        if (Bar == this.Bar) ; // $ Alert[cs/comparison-of-identical-expressions]
        Equals(this); // $ Alert[cs/comparison-of-identical-expressions]

        if (1 + 1 == 2) ; // $ Alert[cs/constant-condition]
        if (1 + 1 == 3) ; // $ Alert[cs/constant-condition]
        if (0 == 1) ; // $ Alert[cs/constant-condition]

        var a = new int[0];
        if (a[0] == a[0]) ; // $ Alert[cs/comparison-of-identical-expressions]

        if (this.Bar[0] == Bar[1 - 1]) ; // $ Alert[cs/comparison-of-identical-expressions]
        if (this.Bar[0] == Bar[1]) ;

        if (this.Prop[Foo] == Prop[this.Foo]) ; // $ Alert[cs/comparison-of-identical-expressions]
        if (this.Prop[0] == Prop[1]) ;
    }

    public CompareIdenticalValues Prop { get; set; }

    protected override string Bar { get; set; }

    public void IsBoxed<T>(T x) where T : I
    {
        ReferenceEquals(x, x);
    }

    public void IsBoxedWrong1<T>(T x) where T : struct
    {
        ReferenceEquals(x, x); // $ Alert[cs/comparison-of-identical-expressions]
    }

    public void IsBoxedWrong2<T>(T x) where T : class
    {
        ReferenceEquals(x, x); // $ Alert[cs/comparison-of-identical-expressions]
    }

    public void IsBoxedWrong3<T>(T x) where T : Super
    {
        ReferenceEquals(x, x); // $ Alert[cs/comparison-of-identical-expressions]
    }

    public int this[int i] { get { return 0; } }
}

public interface I
{
    void M();
}

class MutatingOperations
{
    int x = 0;
    int Pop() => x--;
    int Push() => x++;

    void Good()
    {
        if (Pop() == Pop()) ;
        if (Push() == Push()) ;
        if (x++ == x++) ;
        if (x-- == x--) ;
        if (1 + x++ == 1 + x++) ;
        if ((double)this.Pop() == (double)this.Pop()) ;
    }
}

class Assertions
{
    void F()
    {
        Debug.Assert(0 == 0);  // GOOD
    }
}
