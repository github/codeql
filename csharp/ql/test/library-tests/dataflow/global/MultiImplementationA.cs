// semmle-extractor-options: --separate-compilation

class MultiImpl
{
    public void M1() => M2("taint source");

    public void M2(string x) => Check(x);

    static void Check<T>(T x) { }
}
