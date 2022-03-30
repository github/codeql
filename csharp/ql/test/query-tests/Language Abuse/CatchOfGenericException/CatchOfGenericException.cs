using System;

class CatchOfGenericException
{
    void M(bool rethrow)
    {
        try
        {
        }
        catch (Exception)
        { // BAD
        }

        try
        {
        }
        catch
        { // BAD
        }

        try
        {
        }
        catch (Exception)
        { // GOOD
            if (rethrow)
                throw;
        }

        try
        {
        }
        catch (Exception e) when (rethrow)
        { // GOOD
        }

        try
        {
        }
        catch
        { // GOOD
            throw;
        }
    }

    double reciprocal(double input)
    {
        try
        {
            return 1 / input;
        }
        catch
        { // BAD
          // division by zero, return 0
            return 0;
        }
    }
}
