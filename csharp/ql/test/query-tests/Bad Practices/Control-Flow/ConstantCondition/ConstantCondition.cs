using System;
using System.Collections;
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

class ConstantNullness
{
    void M1(int i)
    {
        var j = ((string)null)?.Length; // BAD
        var s = ((int?)i)?.ToString(); // BAD
        var k = s?.Length; // GOOD
        k = s?.ToLower()?.Length; // GOOD
    }

    void M2(int i)
    {
        var j = (int?)null ?? 0; // BAD
        var s = "" ?? "a"; // BAD
        j = (int?)i ?? 1; // BAD
        s = ""?.CommaJoinWith(s); // BAD
        s = s ?? ""; // GOOD
        s = (i == 0 ? s : null) ?? s; // GOOD
        var k = (i == 0 ? s : null)?.Length; // GOOD
    }
}

class ConstantMatching
{
    void M1()
    {
        switch (1 + 2)
        {
            case 2: // BAD
                break;
            case 3: // BAD
                break;
            case int _: // GOOD
                break;
        }
    }

    void M2(string s)
    {
        switch ((object)s)
        {
            case int _: // BAD
                break;
            case "": // GOOD
                break;
        }
    }

    void M3(object o)
    {
        switch (o)
        {
            case IList _: // GOOD
                break;
        }
    }

    string M4(object o)
    {
        return o switch
        {
            _ => o.ToString() // BAD
        };
    }

    string M5(object o)
    {
        return o switch
        {
            "" => " ",
            _ => o.ToString() // GOOD
        };
    }

    void M6(bool b1, bool b2)
    {
        if (!b1)
            return;
        if (!b2)
            return;
        if (b1 && b2) // BAD
            return;
    }

    string M7(object o)
    {
        return o switch
        {
            (string s, _) => s, // GOOD
            (_, string s) => s, // GOOD
            _ => "" // GOOD
        };
    }
}

class Assertions
{
    void F()
    {
        Debug.Assert(false ? false : true);  // GOOD
    }
}

static class Ext
{
    public static string CommaJoinWith(this string s1, string s2) => s1 + ", " + s2;
}
