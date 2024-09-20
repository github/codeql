using System.Text.RegularExpressions;

var dummy = "dummy";

partial class Test
{
    [GeneratedRegex("abc|def", RegexOptions.IgnoreCase, "en-US")]
    private static partial Regex AbcOrDefGeneratedRegex();
}
