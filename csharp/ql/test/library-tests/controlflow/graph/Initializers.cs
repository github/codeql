using System.Collections.Generic;

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

class IndexInitializers
{
    class Compound
    {
        public Dictionary<int, string> DictionaryField;
        public Dictionary<int, string> DictionaryProperty { get; set; }
        public string[] ArrayField;
        public string[] ArrayProperty { get; set; }
        public string[,] ArrayField2;
        public string[,] ArrayProperty2 { get; set; }
    }

    void Test(int i)
    {
        // Collection initializer
        var dict = new Dictionary<int, string>() { [0] = "Zero", [1] = "One", [i + 2] = "Two" };

        // Indexed initializer
        var compound = new Compound()
        {
            DictionaryField = { [0] = "Zero", [1] = "One", [i + 2] = "Two" },
            DictionaryProperty = { [3] = "Three", [2] = "Two", [i + 1] = "One" },
            ArrayField = { [0] = "Zero", [i + 1] = "One" },
            ArrayField2 = { [0, 1] = "i", [1, i + 0] = "1" },
            ArrayProperty = { [1] = "One", [i + 2] = "Two" },
            ArrayProperty2 = { [0, 1] = "i", [1, i + 0] = "1" },
        };
    }
}
