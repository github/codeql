using System;

class CompileTimeOperators
{
    int Default()
    {
        return default(int);
    }

    int Sizeof()
    {
        return sizeof(int);
    }

    Type Typeof()
    {
        return typeof(int);
    }

    string Nameof(int i)
    {
        return nameof(i);
    }
}

class GotoInTryFinally
{
    void M()
    {
        try
        {
            goto End;
            Console.WriteLine("Dead");
        }
        finally
        {
            Console.WriteLine("Finally");
        }
        Console.WriteLine("Dead");
        End: Console.WriteLine("End");
    }
}
