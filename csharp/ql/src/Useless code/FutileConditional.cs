class FutileConditional
{
    static void Main(string[] args)
    {
        if (args.Length > 10) ; // BAD
        if (args.Length > 8)
        {
            // BAD
        }
        if (args.Length > 6)
        {
            // GOOD: because of else-branch
        }
        else
        {
            System.Console.WriteLine("hello");
        }
    }
}
