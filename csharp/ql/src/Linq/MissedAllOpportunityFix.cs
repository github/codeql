class MissedAllOpportunityFix
{
    public static void Main(string[] args)
    {
        List<int> lst = new List<int> { 2, 4, 18, 12, 80 };

        Console.WriteLine("All Even = " + lst.All(i => i % 2 == 0));
    }
}
