using System;

class Finally
{
    int M(bool b)
    {
        int i = 0;
        try
        {
            if (b)
                throw new Exception();
        }
        finally
        {
            i = 1;
        }
        return i;
    }
}
