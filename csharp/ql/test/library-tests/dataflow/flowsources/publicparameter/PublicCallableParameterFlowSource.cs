using System;
using System.Collections.Specialized;

class PublicCallableParameterFlowSource
{
    public void M1(string x, out string y, ref string z)
    {
        y = x;
        y = z;
    }

    void M2(string x, out string y, ref string z)
    {
        y = x;
        y = z;
    }
}
