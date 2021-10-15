class EmptyBlock
{
    static void Method(string[] args)
    {
        var result = "";

        // BAD
        foreach (var arg in args)
        {
        }

        // OK - comment
        foreach (var arg in args)
        {
            // comment
        }

        // OK - not empty
        foreach (var arg in args)
        {
            result = result + arg;
        }

        // BAD
        if (true)
        {
        }

        // OK - comment
        if (true)
        {
            // comment
        }

        // OK - not empty
        if (true)
        {
            result = result + "foo";
        }

        // OK - there is an update
        for (int i = 0; i < 10; ++i)
        {
        }

        // BAD: there is no update
        for (int i = 0; i < 10;)
        {
        }
    }
}
