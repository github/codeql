using System;

class Test
{
    void Test1(string[] args)
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
    }

    void Test2(string[] args)
    {
        int j = 0;

        // GOOD: Correct terminating value
        if (args.Length > j)
        {
            Console.WriteLine(args[j]);
        }
    }

    void Test3(string[] args)
    {
        // GOOD: Guarded by ternary operator.
        for (int i = 0; i <= args.Length; i++)
        {
            string s = i < args.Length ? args[i] : "";
        }
    }

    void Test4(string[] args)
    {
        int j = 0;

        // GOOD: Guarded by ternary operator.
        if( j <= args.Length )
        {
            string s = j < args.Length ? args[j] : "";
        }
    }

    void Test5(string[] args)
    {
        // GOOD: A valid test of Length.
        for (int i = 0; i != args.Length; i++)
        {
            Console.WriteLine(args[i]);
        }
    }

    void Test6(string[] args)
    {
        int j = 0;

        // GOOD: There is another correct test.
        if( j <= args.Length )
        {
            if (j == args.Length) return;
            Console.WriteLine(args[j]);
        }
    }

    void Test7(string[] args)
    {
        // GOOD: Guarded by ||.
        for (int i = 0; i <= args.Length; i++)
        {
            bool b = i == args.Length || args[i] == "x";
        }
    }
}
