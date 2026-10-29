class DangerousNonShortCircuitLogic
{
    public static void Main(string[] args)
    {
        string a = null;
        if (a != null & a.ToLower() == "hello world")
        {
            Console.WriteLine("The string said hello world.");
        }
    }
}
