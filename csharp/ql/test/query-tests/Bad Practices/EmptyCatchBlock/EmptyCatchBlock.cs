using System;

class EmptyCatchBlock
{
    void bad()
    {
        try
        {
        }
        catch (Exception)
        {
        }
    }

    void good()
    {
        try
        {
        }
        catch (Exception)
        {
            // GOOD: This catch block should be empty
        }
    }
}
