class Foreach
{
    void M1(string[] args)
    {
        foreach (var arg in args)
            ;
    }

    void M2(string[] args)
    {
        foreach (var _ in args)
            ;
    }
}
