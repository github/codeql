class Initializers
{
    int F;
    int G;

    Initializers(string s) { }

    void M()
    {
        var i = new Initializers("") { F = 0, G = 1 };
        var iz = new Initializers[] { i, new Initializers("") };
    }
}
