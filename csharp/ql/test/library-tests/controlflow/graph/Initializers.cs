class Initializers
{
    int F = H + 1;
    int G { get; set; } = H + 2;

    Initializers() { }

    Initializers(string s) { }

    void M()
    {
        var i = new Initializers("") { F = 0, G = 1 };
        var iz = new Initializers[] { i, new Initializers("") };
    }

    static int H = 1;

    class NoConstructor
    {
        protected int F = 0;
        protected int G = 1;
    }

    class Sub : NoConstructor
    {
        int H = 2;
        int I;

        Sub() : base() { I = 3; }

        Sub(int i) : this() { I = i; }

        Sub(int i, int j) { I = i + j; }
    }
}
