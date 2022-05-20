class CheckOdd
{
    private static bool IsOdd(int x)
    {
        return x % 2 != 0;
    }

    public static void Main(String[] args)
    {
        Console.Out.WriteLine(IsOdd(-9)); // prints True
    }
}
