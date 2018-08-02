/*
  Testcase covering C# 6.0 features
*/

using System;
using static System.Console;
using System.Linq;
using System.Collections.Generic;

class TestCSharp6
{
    static int Value
    {
        get;
    } = 20;

    static void Fn(string x) => WriteLine(x);

    static void Main()
    {
        try
        {
            string foo = nameof(TestCSharp6), bar = null;

            WriteLine($"{nameof(foo)} is {foo}, and {nameof(bar)} has length {bar?.Length ?? 0}");

            Fn($@"{nameof(foo)} is {foo}, and {nameof(bar)} has length {bar?.Length ?? 0}");

            bool? anythingInBar = bar?.Any();
            var countTInFoo = foo?.ToUpper().Select(c => c == 'T')?.Count();

            var testElementBinding = new Dictionary<int, string>()?[2][1];
        }
        catch (IndexOutOfRangeException) when (Value == 20)
        {
        }
        catch when (Value == 30)
        {
        }
        catch
        {
        }
    }

    static public bool operator ==(TestCSharp6 t1, TestCSharp6 t2) => true;
    static public bool operator !=(TestCSharp6 t1, TestCSharp6 t2) => false;

    int ExprProperty => 3;

    int this[int i] => i;
}

// semmle-extractor-options: /r:System.Linq.dll
