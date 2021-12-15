class RedundantSelect
{
    static void Main(string[] args)
    {
        List<int> lst = Enumerable.Range(1, 10).ToList();

        foreach (int i in lst.Select(e => e).Where(e => e % 2 == 0))
        {
            Console.WriteLine(i);
        }
    }
}
