class Splitting
{
    void M1(bool b, string tainted)
    {
        if (b)
            if (tainted == null)
                return;
        var x = Return(tainted);
        Check(x);
        if (b)
            Check(x);
    }

    static void Check<T>(T x) { }

    static T Return<T>(T x) => x;

    string this[string s]
    {
        get { return Return(s); }
        set { Check(Return(value)); }
    }

    void M2(bool b, string tainted)
    {
        if (b)
            if (tainted == null)
                return;
        dynamic d = this;
        d[""] = tainted;
        var x = d[tainted];
        Check(x);
        if (b)
            Check(x);
    }
}
