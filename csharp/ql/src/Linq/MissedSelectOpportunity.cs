class MissedSelectOpportunity
{
    public static void Main(string[] args)
    {
        List<int> lst = Enumerable.Range(1, 5).ToList();

        foreach (int i in lst)
        {
            int j = i * i;
            Console.WriteLine(j);
        }
    }
}
