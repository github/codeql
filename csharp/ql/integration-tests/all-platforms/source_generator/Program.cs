using System.Text.RegularExpressions;

Console.WriteLine("Hello, World!");

partial class Test
{
    [GeneratedRegex("abc|def", RegexOptions.IgnoreCase, "en-US")]
    private static partial Regex AbcOrDefGeneratedRegex();
}