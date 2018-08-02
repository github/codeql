// semmle-extractor-options: /out:test.dll

class C1
{
    public int P1 => 0;
    public int P2 { get { return 1; } set { } }
    public int M() => 2;
}

// Stub implementation
class C2
{
    public int F = 1;
    public int this[int i] => throw null;
    public string this[string s] { get { throw null; } set { } }
    public void M1(int i = 1)
    {
        int M2() => throw null;
    }
    public C2(int i) { throw null; }
    public C2() : this(1) { }
    ~C2() { throw null; }
    public static implicit operator C2(int i) => throw null;
    public int P { get; set; } = 1;
}

class C3
{
    public int P3 { get; }
}

partial class C4
{
    int M1() => 0;
}
