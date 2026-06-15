using System;

namespace Sources;

public class NewSources
{
    // Defined as source in the extensions file next to the test.
    // neutral=Sources;NewSources;Source1;();summary;df-generated 
    public static string Source1() => throw null;

    // Defined as source in the extensions file next to the test.
    // neutral=Sources;NewSources;Source2;();summary;df-generated
    public static string Source2() => throw null;


    // New source
    // source=Sources;NewSources;false;WrapConsoleReadLine;();;ReturnValue;stdin;df-generated
    // neutral=Sources;NewSources;WrapConsoleReadLine;();summary;df-generated
    public string? WrapConsoleReadLine()
    {
        return Console.ReadLine();
    }

    // New source
    // source=Sources;NewSources;false;WrapConsoleReadLineAndProcees;(System.String);;ReturnValue;stdin;df-generated
    // neutral=Sources;NewSources;WrapConsoleReadLineAndProcees;(System.String);summary;df-generated
    public string WrapConsoleReadLineAndProcees(string prompt)
    {
        var s = Console.ReadLine();
        return string.IsNullOrEmpty(s) ? "" : s.ToUpper();
    }

    // NOT new source as method is private
    private string? PrivateWrapConsoleReadLine()
    {
        return Console.ReadLine();
    }

    // New source
    // source=Sources;NewSources;false;WrapConsoleReadKey;();;ReturnValue;stdin;df-generated
    // neutral=Sources;NewSources;WrapConsoleReadKey;();summary;df-generated
    public ConsoleKeyInfo WrapConsoleReadKey()
    {
        return Console.ReadKey();
    }

    // Not a new source because a simple type is used in an intermediate step
    // neutral=Sources;NewSources;WrapConsoleReadLineGetBool;();summary;df-generated
    public bool WrapConsoleReadLineGetBool()
    {
        var s = Console.ReadLine();
        return s == "hello";
    }

    public abstract class ValueReader
    {
        // neutral=Sources;NewSources+ValueReader;GetValue;();summary;df-generated
        public abstract string GetValue();
    }

    public class MyConsoleReader : ValueReader
    {
        // neutral=Sources;NewSources+MyConsoleReader;GetValue;();summary;df-generated
        public override string GetValue()
        {
            return Console.ReadLine();
        }
    }

    public class MyOtherReader : ValueReader
    {
        // neutral=Sources;NewSources+MyOtherReader;GetValue;();summary;df-generated
        public override string GetValue()
        {
            return "";
        }
    }

    public class MyContainer<T> where T : ValueReader
    {
        public T Value { get; set; }

        // neutral=Sources;NewSources+MyContainer<T>;Read;();summary;df-generated
        public string Read()
        {
            return Value.GetValue();
        }
    }

    // Not a new source as this callable has been manually modelled
    // as source neutral.
    // neutral=Sources;NewSources;ManualNeutralSource;();summary;df-generated
    public string ManualNeutralSource()
    {
        return Console.ReadLine();
    }

    // Not a new source as this callable already has a manual source.
    // neutral=Sources;NewSources;ManualSourceAlreadyDefined;();summary;df-generated
    public string ManualSourceAlreadyDefined()
    {
        return Console.ReadLine();
    }

    public abstract class DataReader
    {
        // neutral=Sources;NewSources+DataReader;Read;();summary;df-generated
        public abstract string Read();
    }

    public class DataReaderKind1 : DataReader
    {
        // neutral=Sources;NewSources+DataReaderKind1;Read;();summary;df-generated
        public override string Read()
        {
            return Source1();
        }
    }

    public sealed class DataReaderKind2 : DataReader
    {
        // neutral=Sources;NewSources+DataReaderKind2;Read;();summary;df-generated
        public override string Read()
        {
            return Source2();
        }
    }

    public class C1
    {
        // neutral=Sources;NewSources+C1;ToString;();summary;df-generated
        public override string ToString()
        {
            return Source1();
        }
    }

    public sealed class C2
    {
        // neutral=Sources;NewSources+C2;ToString;();summary;df-generated
        public override string ToString()
        {
            return Source1();
        }
    }

}
