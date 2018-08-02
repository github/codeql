using System.Collections.Generic;

class C1
{
    public virtual int M1() { return 0; }
    public virtual int M2() { return 0; }
    public virtual IEnumerable<T> M3<T>() { return null; }
    public virtual IEnumerable<T> M4<T>() { return null; }
    public virtual int M5(double x) { return 0; }
}

class C2 : C1
{
    // BAD: M1 does not override C1.M1
    public int M1() { return 1; }

    // GOOD: M2 overrides using the explicit keyword "override"
    public override int M2() { return 2; }

    // BAD: M3 does not override C1.M3
    public IEnumerable<T> M3<T>() { return null; }

    // GOOD: M4 overrides using the explicit keyword "override"
    public override IEnumerable<T> M4<T>() { return null; }

    // GOOD: Arguments mismatch, so no attempt to override
    public void M5(int x) { }

    public new void M5(double x) { }
}
