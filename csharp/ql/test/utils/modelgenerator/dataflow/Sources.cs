using System;

namespace Sources;

public class NewSources
{
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
}
