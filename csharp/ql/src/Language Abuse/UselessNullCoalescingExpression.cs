class UselessNullCoalescingExpression
{
    private static Random generator;

    private static int RandomNumber()
    {
        // This should probably have said "generator ?? new Random()".
        generator = generator ?? generator;
        return generator.Next();
    }

    static void Main(string[] args)
    {
        Console.WriteLine(RandomNumber());
        Console.WriteLine(RandomNumber());
        Console.WriteLine(RandomNumber());
    }
}
