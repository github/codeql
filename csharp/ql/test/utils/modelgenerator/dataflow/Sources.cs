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
    // source=Sources;NewSources;false;WrapConsoleReadLine;();;ReturnValue;local;df-generated
    // neutral=Sources;NewSources;WrapConsoleReadLine;();summary;df-generated
    public string? WrapConsoleReadLine()
    {
        return Console.ReadLine();
    }

    // New source
    // source=Sources;NewSources;false;WrapConsoleReadLineAndProcees;(System.String);;ReturnValue;local;df-generated
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
    // source=Sources;NewSources;false;WrapConsoleReadKey;();;ReturnValue;local;df-generated
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

    public class MyConsoleReader
    {
        // source=Sources;NewSources+MyConsoleReader;false;ToString;();;ReturnValue;local;df-generated
        // neutral=Sources;NewSources+MyConsoleReader;ToString;();summary;df-generated
        public override string ToString()
        {
            return Console.ReadLine();
        }
    }


    public class MyContainer<T>
    {
        public T Value { get; set; }

        // summary=Sources;NewSources+MyContainer<T>;false;Read;();;Argument[this];ReturnValue;taint;df-generated
        public string Read()
        {
            return Value.ToString();
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
        // source=Sources;NewSources+DataReaderKind1;true;Read;();;ReturnValue;source-kind-1;df-generated
        // neutral=Sources;NewSources+DataReaderKind1;Read;();summary;df-generated
        public override string Read()
        {
            return Source1();
        }
    }

    public class DataReaderKind2 : DataReader
    {
        // source=Sources;NewSources+DataReaderKind2;true;Read;();;ReturnValue;source-kind-2;df-generated
        // neutral=Sources;NewSources+DataReaderKind2;Read;();summary;df-generated
        public override string Read()
        {
            return Source2();
        }
    }
}
