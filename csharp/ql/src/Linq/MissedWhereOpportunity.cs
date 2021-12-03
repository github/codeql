class MissedWhereOpportunity
{
    public static void Main(string[] args)
    {
        List<int> lst = Enumerable.Range(1, 10).ToList();

        foreach (int i in lst)
        {
            if (i % 2 != 0)
                continue;
            Console.WriteLine(i);
            Console.WriteLine((i / 2));
        }

        foreach (int i in lst)
        {
            if (i % 2 == 0)
            {
                Console.WriteLine(i);
                Console.WriteLine((i / 2));
            }
        }
    }
}
