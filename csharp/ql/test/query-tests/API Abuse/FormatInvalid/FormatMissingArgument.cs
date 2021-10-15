using System;

class Class1
{
    void TestFormatMissingArgument()
    {
        // GOOD: All args supplied
        String.Format("{0}", 0);

        // BAD: Missing {1}
        String.Format("{1}", 0);

        // BAD: Missing {2} and {3}
        String.Format("{2} {3}", 0, 1);

        // GOOD: An array has been supplied.
        String.Format("{0} {1} {2}", args);

        // GOOD: All arguments supplied to params
        String.Format("{0} {1} {2} {3}", 0, 1, 2, 3);

        helper("{1}");

        // BAD: Missing {0}
        Console.WriteLine("{0}");
    }

    void helper(string format)
    {
        // BAD: Missing {1}
        String.Format(format, 0);
    }

    object[] args;
}
