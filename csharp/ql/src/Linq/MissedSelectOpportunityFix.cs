class MissedSelectOpportunityFix
{
    public static void Main(string[] args)
    {
        List<int> lst = Enumerable.Range(1, 5).ToList();

        foreach (int j in lst.Select(i => i * i))
        {
            Console.WriteLine(j);
        }
    }
}
