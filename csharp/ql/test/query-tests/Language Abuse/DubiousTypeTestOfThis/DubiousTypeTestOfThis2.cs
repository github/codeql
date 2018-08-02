// semmle-extractor-options: /r:System.Diagnostics.Debug.dll

using System;
using System.Diagnostics;

class C
{
    void M()
    {
        if (this is D) ;  // BAD
        Debug.Assert(this is D);  // GOOD
    }
}

class D : C
{
}
