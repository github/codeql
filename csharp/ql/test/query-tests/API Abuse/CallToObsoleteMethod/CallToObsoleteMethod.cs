using System;

class Program
{
    [Obsolete]
    static void ObsoleteMethod()
    {
        // GOOD: Calling obsolete methods in obsolete methods
        ObsoleteMethod();
    }

    static void NotObsoleteMethod()
    {
    }

    static void Main(string[] args)
    {
        // BAD: Call to obsolete method
        ObsoleteMethod();

        // GOOD: Call to non-obsolete method
        NotObsoleteMethod();
    }
}
