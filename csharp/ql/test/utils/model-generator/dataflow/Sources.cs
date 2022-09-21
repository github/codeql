using System;

namespace Sources;

public class NewSources
{
    // New source
    public string? WrapConsoleReadLine()
    {
        return Console.ReadLine();
    }

    // New source
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
    public ConsoleKeyInfo WrapConsoleReadKey()
    {
        return Console.ReadKey();
    }
}