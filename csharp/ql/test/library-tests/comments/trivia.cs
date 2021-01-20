//  semmle-extractor-options: --standalone
// Start of trivia.cs
// Unassociated
#define DEBUG

#undef DEBUG

using System;
using System.Collections;
using System.Collections.Generic;

#pragma warning disable 414, CS3021
#pragma checksum "file.cs" "{406EA660-64CF-4C82-B6F0-42D48172A799}" "ab007f1d23d9" // New checksum
class Tr1
{
    static void M1()
    {
#line 200 "Special"
        int i;
        int j;
#line default
        char c;
#pragma warning restore
        float f;
#line hidden // numbering not affected
        string s;
#line 300
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
#warning DEBUG is defined
        var i = 0;
#if NESTED
        i--;
#endif
#elif (NOTDEBUG == true) || !(TEST)
#error NOTDEBUG is defined or TEST is not
        var i = 1;
#else
        var i = 2;
#endif
    }
}