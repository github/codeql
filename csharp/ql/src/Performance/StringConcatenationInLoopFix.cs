class StringConcatenationInLoopFix
{
    public static void Main(string[] args)
    {
        StringBuilder numberList = new StringBuilder();
        for (int i = 0; i <= 100; i++)
        {
            numberList.Append(i);
            numberList.Append(" ");
        }
        Console.WriteLine(numberList);
    }
}
