using System;

class ImplicitToStringTest
{
    void InterpolatedStringImplicitToString()
    {
        object o = null;
        string s = $"{o}"; // GOOD
    }
}
