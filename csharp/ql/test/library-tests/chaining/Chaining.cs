using System;

class C1
{
    // Methods designed for chaining
    public C1 M1() { return this; }
    public C1 M2() => this;
    public C1 M3(int x) => x > 0 ? this : this;
    public virtual C1 M4() { return this; }
    public C1 M5() => M1();
    public C1 M6() => this.M5();

    // Methods not designed for chaining
    public int M7() => 42;
    public C1 M8() { return new C1(); }
    public C1 M9(int x) { return x > 0 ? new C1() : this; }
    public virtual C1 M10() { return this; }
    public C1 M11() => M10();
    public C1 M12() => new C1().M1();
}

class C2 : C1
{
    // Methods designed for chaining
    public override C1 M4() { return this; }

    // Methods not designed for chaining
    public override C1 M10() { return new C2(); }
}

class C3
{
    // Properties designed for chaining
    public C3 F1 { get { return this; } }
    public C3 F2 => this;
    public C3 F3 => F1;
    public virtual C3 F4 => this;
    public C3 F5 => this.F4;

    // Properties not designed for chaining
    public int F6 => 42;
    public virtual C3 F7 { get { return this; } }
    public C3 F8 => new C3();
    public C3 F9 => new C3().F1;
}

class C4 : C3
{
    // Properties designed for chaining
    public override C3 F4 => this;

    // Properties not designed for chaining
    public override C3 F7 => new C3();
}

class C5
{
    public C5()
    {
        // Lambdas designed for chaining
        Func<C5> f1 = () => this;
        Func<int, C5> f2 = x => x > 0 ? this : this;

        // Lambdas not designed for chaining
        Func<C5> f3 = () => new C5();
        Func<int, C5> f4 = x => x > 0 ? this : new C5();
    }
}

// Simulate library code
abstract class C6
{
    // Methods (possibly) designed for chaining
    public abstract C6 M1();

    // Methods not designed for chaining
    public abstract int M2();
    public static extern C6 M3();
}
