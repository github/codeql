//
// Start of trivia.cs
// Unassociated
#define DEBUG
#define DEBUG2
#undef DEBUG

using System;
using System.Collections;
using System.Collections.Generic;

#pragma warning disable 414, CS3021
#pragma checksum "comments1.cs" "{406EA660-64CF-4C82-B6F0-42D48172A799}" "ab007f1d23d9" // New checksum
class Tr1
{
    static void M1()
    {
#line 1 "comments1.cs"
        int i; // A mapped single-line comment
        int j;
#line default
        char c;
#pragma warning restore
        float f;
#line hidden // numbering not affected
        string s;
#line 5
        double d;
    }
}

class Tr2
{
    static void M1()
    {
        #region fields
        int i;
        #region nested
        int j;
        #endregion
        #endregion
    }
}

class Tr3
{
    static void M1()
    {
#nullable disable// Sets the nullable annotation and warning contexts to disabled.
#nullable enable// Sets the nullable annotation and warning contexts to enabled.
#nullable restore// Restores the nullable annotation and warning contexts to project settings.
#nullable disable annotations// Sets the nullable annotation context to disabled.
#nullable enable annotations// Sets the nullable annotation context to enabled.
#nullable restore annotations// Restores the nullable annotation context to project settings.
#nullable disable warnings// Sets the nullable warning context to disabled.
#nullable enable warnings// Sets the nullable warning context to enabled.
#nullable restore warnings// Restores the nullable warning context to project settings.
    }
}

class Tr4
{
    static void M1()
    {
#if DEBUG
#error DEBUG is defined
        var i = 0;
#if NESTED
        i--;
#endif
#elif (NOTDEBUG == true) || !(TEST)
#warning NOTDEBUG is defined or TEST is not
        var i = 1;
#else
        var i = 2;
#endif
    }
}

class Tr5
{
#if DEBUG2
    static void M1()
    {
    }
#endif

    static void M2()
    {
    }

    public int F1
#if DEBUG2
= 10
#endif
;

    public int F2 = 0;

    public int P1
    {
        get;
#if DEBUG2
        set;
#endif
    }

    public int P2 { get; set; }
}
