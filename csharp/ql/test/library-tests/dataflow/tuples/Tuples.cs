class Tuples
{
    static void M1()
    {
        var x = (a: "taint source", (1, "taint source"));
        var (a, (b, c)) = x;
        Sink(a);                // Tainted
        Sink(b);
        Sink(c);                // Tainted

        (a, (b, c)) = x;
        Sink(a);                // Tainted
        Sink(b);
        Sink(c);                // Tainted

        (var p, var q) = x;
        Sink(p);                // Tainted
        Sink(q.Item1);
        Sink(q.Item2);          // Tainted

        Sink(x.Item1);          // Tainted
        Sink(x.a);              // Tainted
        Sink(x.Item2.Item1);
        Sink(x.Item2.Item2);    // Tainted
    }

    static void Sink<T>(T x) { }
}
