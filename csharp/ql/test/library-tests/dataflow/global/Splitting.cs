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
}
