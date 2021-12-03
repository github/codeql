class MissedUsingOpportunity
{
    static void Main(string[] args)
    {
        StreamReader reader = null;
        try
        {
            reader = File.OpenText("input.txt");
            // ...
        }
        finally
        {
            if (reader != null)
            {
                ((IDisposable)reader).Dispose();
            }
        }
    }
}
