// semmle-extractor-options: --separate-compilation

// Stub implementation
class C1
{
    public int P1 => throw null;
    public int P2 { get { throw null; } set { throw null; } }
    public int M() => throw null;
}

class C2
{
    public int F = 0;
    public int this[int i] => i;
    public string this[string s] { get { return s; } set { } }
    public void M1(int i = 0)
    {
        int M2() => 0;
    }
    public C2(int i) { F = i; }
    public C2() : this(0) { }
    ~C2() { }
    public static implicit operator C2(int i) => null;
    public int P { get; set; } = 0;
}

// Stub implementation
class C3
{
    public int P3 { get => throw null; }
}

// Stub implementation
partial class C4
{
    int M1() { throw null; }
    int M2() { throw null; }
}
