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
        int F = 0;
        int G = 1;
    }
}
