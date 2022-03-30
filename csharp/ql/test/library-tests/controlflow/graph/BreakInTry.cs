class BreakInTry
{
    void M1(string[] args)
    {
        try
        {
            foreach (var arg in args)
            {
                if (arg == null)
                    break;
            }
        }
        finally
        {
            if (args == null)
                ;
        }
    }

    void M2(string[] args)
    {
        foreach (var arg in args)
        {
            try
            {
                if (arg == null)
                    break;
            }
            finally
            {
                if (args == null)
                    ;
            }
        }
      ;
    }

    void M3(string[] args)
    {
        try
        {
            if (args == null)
                return;
        }
        finally
        {
            foreach (var arg in args)
            {
                if (arg == null)
                    break;
            }
        }
      ;
    }

    void M4(string[] args)
    {
        try
        {
            if (args == null)
                return;
        }
        finally
        {
            foreach (var arg in args)
            {
                if (arg == null)
                    break;
            }
        }
    }
}
