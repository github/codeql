class StaticArray
{
    public static readonly string[] Foo = { "hello", "world" }; // BAD
    public static void Main(string[] args)
    {
        Foo[0] = "goodbye";
    }
}
