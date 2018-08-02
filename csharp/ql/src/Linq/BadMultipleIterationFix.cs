class BadMultipleIterationFix
{
    private static int count = 1;
    private static IEnumerable<int> NonRepeatable()
    {
        for (; count <= 3; count++)
        {
            yield return count;
        }
    }

    public static void Main(string[] args)
    {
        IList<int> nr = NonRepeatable().ToList<int>();
        foreach (int i in nr)
            Console.WriteLine(i);

        foreach (int i in nr)
            Console.WriteLine(i);
    }
}
