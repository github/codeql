// semmle-extractor-options: /r:System.Diagnostics.Debug.dll

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
        if (this.Foo == Foo) ;
        if (base.Foo == Foo) ;
        if (Foo == new CompareIdenticalValues().Foo) ;

        var x = "Abc";
        if (x == "Abc") ;
        var temp = x == x; // BAD: but flagged by cs/constant-comparison

        double d = double.NaN;
        if (d == d) ; // !double.IsNan(d)
        if (d <= d) ; // !double.IsNan(d), but unlikely to be intentional
        if (d >= d) ; // !double.IsNan(d), but unlikely to be intentional
        if (d != d) ; // double.IsNan(d)
        if (d > d) ; // always false
        if (d < d) ; // always false

        float f = float.NaN;
        if (f == f) ; // !float.IsNan(f)
        if (f <= f) ; // !float.IsNan(f), but unlikely to be intentional
        if (f >= f) ; // !float.IsNan(f), but unlikely to be intentional
        if (f != f) ; // float.IsNan(f)
        if (f > f) ; // always false
        if (f < f) ; // always false

        int i = 0;
        if (i == i) ;  // BAD: but flagged by cs/constant-condition
        if (i != i) ;  // BAD: but flagged by cs/constant-condition

        CompareIdenticalValues c = null;
        c.Prop.Equals(c.Prop);
        Equals(c.Prop.Prop.Prop.Foo + 2, c.Prop.Prop.Prop.Foo + 2);
        Equals(c.Prop.Prop.Prop.Foo, c.Prop.Prop.Foo);

        if (base.Bar == Bar) ;
        if (Bar == this.Bar) ;
        Equals(this);

        if (1 + 1 == 2) ;  // BAD: but flagged by cs/constant-condition
        if (1 + 1 == 3) ;
        if (0 == 1) ;

        var a = new int[0];
        if (a[0] == a[0]) ;

        if (this.Bar[0] == Bar[1 - 1]) ;
        if (this.Bar[0] == Bar[1]) ;

        if (this.Prop[Foo] == Prop[this.Foo]) ;
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
        ReferenceEquals(x, x);
    }

    public void IsBoxedWrong2<T>(T x) where T : class
    {
        ReferenceEquals(x, x);
    }

    public void IsBoxedWrong3<T>(T x) where T : Super
    {
        ReferenceEquals(x, x);
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
