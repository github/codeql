using System;

class Test
{
    static void Main(string[] args)
    {
        // BAD: Loop upper bound is off-by-one
        for (int i = 0; i <= args.Length; i++)
        {
            Console.WriteLine(args[i]);
        }

        // BAD: Loop upper bound is off-by-one
        for (int i = 0; args.Length >= i; i++)
        {
            Console.WriteLine(args[i]);
        }

        // GOOD: Loop upper bound is correct
        for (int i = 0; i < args.Length; i++)
        {
            Console.WriteLine(args[i]);
        }

        int j = 0;
        // BAD: Off-by-one on index validity check
        if (j <= args.Length)
        {
            Console.WriteLine(args[j]);
        }

        // BAD: Off-by-one on index validity check
        if (args.Length >= j)
        {
            Console.WriteLine(args[j]);
        }

        // GOOD: Correct terminating value
        if (args.Length > j)
        {
            Console.WriteLine(args[j]);
        }
    }
}
