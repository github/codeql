class StaticArrayFix
{
    public static readonly ReadOnlyCollection<string> Foo
        = new ReadOnlyCollection<string>(new string[] { "hello", "world" });
    public static void Main(string[] args)
    {

    }
}
