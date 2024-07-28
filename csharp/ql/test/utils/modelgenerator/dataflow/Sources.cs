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
}
