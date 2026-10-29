class MissedUsingOpportunityFix
{
    static void Main(string[] args)
    {
        using (StreamReader reader = File.OpenText("input.txt"))
        {
            // ...
        }
    }
}
