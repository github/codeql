public class K
{
    static string[] Strings = new string[10];

    private void M1()
    {
        var o = Source<string>(1);
        Strings[0] = o;
    }

    private void M2()
    {
        Sink(Strings[0]); // $ hasValueFlow=1
    }

    public static void Sink(object o) { }

    static T Source<T>(object source) => throw null;
}
