using System;

class CatchOfGenericException
{
    void M(bool rethrow)
    {
        try
        {
        }
        catch (Exception) // $ Alert
        { // BAD
        }

        try
        {
        }
        catch // $ Alert
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
        catch // $ Alert
        { // BAD
          // division by zero, return 0
            return 0;
        }
    }
}
