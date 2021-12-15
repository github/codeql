class Bad
{
    public static readonly string[] Foo = { "hello", "world" };
    public static void Main(string[] args)
    {
        Foo[0] = "goodbye";
    }
}
