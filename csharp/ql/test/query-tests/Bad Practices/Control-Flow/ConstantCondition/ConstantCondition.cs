// semmle-extractor-options: /r:System.Threading.Thread.dll /r:System.Diagnostics.Debug.dll

using System;
using System.Diagnostics;

class ConstantCondition
{
    const bool Field = false;

    void M1(int x)
    {
        if (Field) // GOOD: Allow conditional execution based on constant field
            ;

        const bool local = false;
        if (local)  // GOOD: Allow conditional execution based on local constant
            ;

        try
        {
            throw new ArgumentNullException("x");
        }
        finally
        {
            if (x > 1) // No 'false' successor (instead a 'throw[ArgumentNullException]' successor)
                throw new Exception();
        }
    }

    int M2(bool? b) => (b ?? false) ? 0 : 1; // GOOD

    bool M3(double d) => d == d; // BAD: but flagged by cs/constant-comparison
}

class Assertions
{
    void F()
    {
        Debug.Assert(false ? false : true);  // GOOD
    }
}
