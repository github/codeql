class StringConcatenationInLoop
{
    public static void Main(string[] args)
    {
        String numberList = "";
        for (int i = 0; i <= 100; i++)
        {
            numberList += i + " ";
        }
        Console.WriteLine(numberList);
    }
}
