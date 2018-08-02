using System.Collections;

class S1
{
    public int P1;
    public int P2 { get; set; }
    public int P3 { set { } }
}

class S2 : IEnumerable
{
    public void Add(int x) { }
    public void Add(int x, int y) { }
    public IEnumerator GetEnumerator() { return null; }
}

class Test
{
    static void Main(string[] args)
    {
        new S1 { P1 = 1, P2 = 2, P3 = 3 };
        new S2 { 1, 2, 3, { 4, 5 } };
    }
}
