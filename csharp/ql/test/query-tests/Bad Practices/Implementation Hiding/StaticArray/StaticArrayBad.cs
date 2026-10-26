class Bad
{
    public static readonly string[] Foo = { "hello", "world" }; // $ Alert
    public static void Main(string[] args)
    {
        Foo[0] = "goodbye";
    }
}
