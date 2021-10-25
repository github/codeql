class MissedWhereOpportunityFix
{
    public static void Main(string[] args)
    {
        List<int> lst = Enumerable.Range(1, 10).ToList();

        foreach (int i in lst.Where(e => e % 2 == 0))
        {
            Console.WriteLine(i);
            Console.WriteLine((i / 2));
        }
    }
}
