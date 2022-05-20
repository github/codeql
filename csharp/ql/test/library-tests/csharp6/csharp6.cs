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

class IndexInitializers
{
    class Compound
    {
        public Dictionary<int, string> DictionaryField;
        public Dictionary<int, string> DictionaryProperty { get; set; }
        public string[] ArrayField;
        public string[] ArrayProperty { get; set; }
        public string[,] ArrayField2;
        public string[,] ArrayProperty2 { get; set; }
    }

    void Test()
    {
        // Collection initializer
        var dict = new Dictionary<int, string>() { [0] = "Zero", [1] = "One", [2] = "Two" };

        // Indexed initializer
        var compound = new Compound()
        {
            DictionaryField = { [0] = "Zero", [1] = "One", [2] = "Two" },
            DictionaryProperty = { [3] = "Three", [2] = "Two", [1] = "One" },
            ArrayField = { [0] = "Zero", [1] = "One" },
            ArrayField2 = { [0, 1] = "i", [1, 0] = "1" },
            ArrayProperty = { [1] = "One", [2] = "Two" },
            ArrayProperty2 = { [0, 1] = "i", [1, 0] = "1" },
        };
    }
}
