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
}
