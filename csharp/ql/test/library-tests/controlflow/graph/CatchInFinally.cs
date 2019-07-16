using System;

class CatchInFinally
{
    void M1(string[] args)
    {
        try
        {
            if (args == null)
                throw new ArgumentNullException();
        }
        finally
        {
            try
            {
                if (args.Length == 1)
                    throw new Exception("1");
            }
            catch (Exception e) when (e.Message == "1")
            {
                Console.WriteLine(args[0]);
            }
            catch
            {
                Console.WriteLine("");
            }
        }
    }

    class ExceptionA : Exception { }
    class ExceptionB : Exception { }
    class ExceptionC : Exception { }

    public static void M2(bool b1, bool b2)
    {
        try
        {
            if (b1) throw new ExceptionA();
        }
        finally
        {
            try
            {
                if (b2) throw new ExceptionB();
            }
            catch (ExceptionB) when (b2)
            {
                if (b1) throw new ExceptionC();
            }
        }
    }
}
