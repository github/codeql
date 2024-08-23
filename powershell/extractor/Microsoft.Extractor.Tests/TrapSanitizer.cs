using System.Text;
using System.Text.RegularExpressions;

namespace Microsoft.Extraction.Tests;

/// <summary>
/// This class provides a method for sanitizing a trap files in tests so they can be validated. 
///     The resulting trap file will not be valid for making a codeqldb due to missing file metadata,
///     which is removed to ensure the test case can match the expected trap.
/// </summary>
internal class TrapSanitizer
{
    // Regex to match the IDs in the file (# followed by digits)
    private static readonly Regex CaptureId = new Regex($"#([0-9]+)");

    /// <summary>
    /// Sanitize a Trap file to check equality by removing run specific things like file names and squashing ids
    ///     to a consistent range
    /// </summary>
    /// <param name="TrapContents">The lines of the trap file to sanitize</param>
    /// <returns>A string containing the sanitized contents</returns>
    public static string SanitizeTrap(string[] TrapContents)
    {
        StringBuilder sb = new();
        int largestId = 0;
        int startingLineActual = -1;
        for (int i = 0; i < TrapContents.Length; i++)
        {
            // The first line with actual extracted contents will be after the numlines line
            if (TrapContents[i].StartsWith("numlines"))
            {
                startingLineActual = i + 1;
                break;
            }
            // If a line before numlines has an ID it is a candidate for largest id found
            if (CaptureId.IsMatch(TrapContents[i]))
            {
                largestId = int.Max(largestId, int.Parse(CaptureId.Matches(TrapContents[i])[0].Groups[1].Captures[0].Value));
            }
        }

        // Starting from the line after numlines declaration
        for (int i = startingLineActual; i < TrapContents.Length; i++)
        {
            // Replace IDs in each line based on the largest previous ID found
            // Reserve #1 for the File
            sb.Append(SanitizeLine(TrapContents[i], largestId - 1));
            sb.Append(Environment.NewLine);
        }

        return sb.ToString();
    }

    /// <summary>
    /// Sanitize a single line of trap content given the largest previously used id number to ignore,
    ///     subtracting the offset from those IDs.
    /// </summary>
    /// <param name="trapContent">A single line of trap content</param>
    /// <param name="offset">The offset to apply</param>
    /// <returns>A sanitized line</returns>
    private static string SanitizeLine(string trapContent, int offset)
    {
        var matches = CaptureId.Matches(trapContent);
        if (!matches.Any())
        {
            return trapContent;
        }
        var sb = new StringBuilder();
        int lastIndex = 0;
        foreach (Match match in matches)
        {
            var capture = match.Groups[1].Captures[0];
            sb.Append(trapContent[lastIndex..capture.Index]);
            lastIndex = capture.Index + capture.Length;
            int newInt = int.Parse(capture.Value);
            if (newInt > 1)
            {
                sb.Append(newInt - offset);
            }
            else
            {
                sb.Append(newInt);
            }
        }
        sb.Append(trapContent[lastIndex..]);
        return sb.ToString();
    }
}