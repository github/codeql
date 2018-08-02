class EqualsArray
{
    public static void Main(string[] args)
    {
        string[] strings = { "hello", "world" };
        string[] moreStrings = { "hello", "world" };
        Console.WriteLine(strings.Equals(moreStrings));
    }
}
