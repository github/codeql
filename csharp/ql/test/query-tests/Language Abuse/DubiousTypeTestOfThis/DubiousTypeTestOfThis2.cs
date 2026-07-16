using System;
using System.Diagnostics;

class C
{
    void M()
    {
        if (this is D) ;  // $ Alert // BAD
        Debug.Assert(this is D);  // GOOD
    }
}

class D : C
{
}
