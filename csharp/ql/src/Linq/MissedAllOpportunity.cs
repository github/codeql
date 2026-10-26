class MissedAllOpportunity
{
    public static void Main(string[] args)
    {
        List<int> lst = new List<int> { 2, 4, 18, 12, 80 };

        bool allEven = true;
        foreach (int i in lst)
        {
            if (i % 2 != 0)
            {
                allEven = false;
                break;
            }
        }
        Console.WriteLine("All Even = " + allEven);
    }
}
