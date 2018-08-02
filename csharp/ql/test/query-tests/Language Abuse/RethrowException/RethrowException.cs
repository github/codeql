using System;

class C
{
    static void Main(string[] args)
    {
        try
        {
        }
        catch (Exception e)
        {
            throw e;    // BAD
        }

        try
        {
        }
        catch (Exception e)
        {
            if (true)
                throw e;    // BAD
        }

        try
        {
        }
        catch (Exception e)
        {
            throw;    // GOOD
        }

        try
        {
        }
        catch (Exception e)
        {
            try
            {
            }
            catch
            {
                throw e;  // GOOD
            }
        }
    }
}
