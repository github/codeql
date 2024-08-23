using System.Reflection;
using System.Text.RegularExpressions;
using Microsoft.Extraction.Tests;
using Semmle.Extraction;
using Semmle.Extraction.PowerShell.Standalone;
using Xunit.Abstractions;
using Xunit.Sdk;
using Semmle.Extraction.PowerShell;

namespace Microsoft.Extractor.Tests;

internal static class PathHolder
{
    internal static string powershellSource = Path.Join("..", "..", "..", "..", "..", "samples", "code");
    internal static string expectedTraps = Path.Join("..", "..", "..", "..", "..", "samples", "traps");
    internal static string schemaPath = Path.Join("..", "..", "..", "..", "..", "config", "semmlecode.powershell.dbscheme");
    internal static string generatedTraps = Path.Join(".", Path.GetFullPath(powershellSource).Replace(":", "_"));
}
public class TrapTestFixture : IDisposable
{
    public TrapTestFixture()
    {
        // Setup here
    }

    public void Dispose()
    {
        // Delete the generated traps
        Directory.Delete(PathHolder.generatedTraps, true);
    }
}

public class Traps : IClassFixture<TrapTestFixture>
{
    private readonly ITestOutputHelper _output;
    public Traps(ITestOutputHelper output)
    {
        _output = output;
    }

    private static Regex schemaDeclStart = new("([a-zA-Z_]+)\\(");
    private static Regex schemaEnd = new("^\\)");
    private static Regex commentEnd = new("\\*/");

    /// <summary>
    /// Naiively parse the schema and try to determine how many parameters each table expects
    /// </summary>
    /// <param name="schemaContents"></param>
    /// <returns>Dictionary mapping table name to number of parameters</returns>
    private static Dictionary<string, int> ParseSchema(string[] schemaContents)
    {
        bool isParsingTable = false;
        int expectedNumEntries = 0;
        string targetName = string.Empty;
        Dictionary<string, int> output = new();
        for (int index = 0; index < schemaContents.Length; index++)
        {
            if (!isParsingTable)
            {
                if (schemaDeclStart.IsMatch(schemaContents[index]))
                {
                    targetName = schemaDeclStart.Matches(schemaContents[index])[0].Groups[1].Captures[0].Value;
                    isParsingTable = true;
                    expectedNumEntries = 0;
                }
            }
            else
            {
                if (commentEnd.IsMatch(schemaContents[index]))
                {
                    isParsingTable = false;
                    expectedNumEntries = 0;
                }
                if (schemaEnd.IsMatch(schemaContents[index]))
                {
                    output.Add(targetName, expectedNumEntries);
                    isParsingTable = false;
                    expectedNumEntries++;
                }
                else
                {
                    expectedNumEntries++;
                }
            }
        }

        return output;
    }

    /// <summary>
    /// Check that the Schema entries match the implemented methods in Tuples.cs
    /// </summary>
    [Fact]
    public void Schema_Matches_Tuples()
    {
        string[] schemaContents = File.ReadLines(PathHolder.schemaPath).ToArray();
        Dictionary<string, int> expected = ParseSchema(schemaContents);
        // Get all the nonpublic static methods from the Tuples classes
        var methods = typeof(Semmle.Extraction.PowerShell.Tuples)
            .GetMethods(BindingFlags.Static | BindingFlags.NonPublic)
            .Union(typeof(Semmle.Extraction.Tuples).GetMethods(BindingFlags.Static | BindingFlags.NonPublic))
            // Select a tuple of the method, its parameters
            .Select(method => (method, method.GetParameters(),
                // the expected number of parameters - one fewer than actual if the first is a TextWriter, and the name of the method
                method.GetParameters()[0].ParameterType.Name.Equals("TextWriter") ? method.GetParameters().Length - 1 : method.GetParameters().Length , method.Name));
        List<string> errors = new();
        List<string> warnings = new();
        // If a tuple method exists and doesn't have a matching schema entry that is an error, as the produce traps won't be match
        foreach (var method in methods)
        {
            if (expected.Any(entry => method.Name == entry.Key && (method.Item3) == entry.Value))
            {
                continue;
            }
            errors.Add($"Tuple {method.Name} does not match any schema entry, expected {method.Item3} parameters.");
        }
        // If the schema has a superfluous entity that is a warning, as the extractor simply cannot product those things
        foreach (var entry in expected)
        {
            if (methods.Any(method => method.Name == entry.Key && (method.Item3) == entry.Value))
            {
                continue;
            }
            warnings.Add($"Schema entry {entry.Key} does not match any implemented Tuple, expected {entry.Value} parameters.");
        }

        foreach (var warning in warnings)
        {
            _output.WriteLine($"Warning: {warning}");
        }
        foreach (var error in errors)
        {
            _output.WriteLine($"Error: {error}");
        }
        Assert.Empty(errors);
    }
    
    [Fact]
    public void Verify_Sample_Traps()
    {
        string[] expectedTrapsFiles = Directory.GetFiles(PathHolder.expectedTraps);
        int numFailures = 0;
        foreach (string expected in expectedTrapsFiles)
        {
            if (File.ReadAllText(expected).Contains("extractor_messages"))
            {
                numFailures++;
                _output.WriteLine($"Expected sample trap {expected} has extractor error messages.");
            }
        }

        if (numFailures > 0)
        {
            _output.WriteLine($"{numFailures} errors were detected.");
        }
        Assert.Equal(0, numFailures);
    }


    [Fact]
    public void Compare_Generated_Traps()
    {
        string[] args = new string[] { PathHolder.powershellSource };
        int exitcode = Program.Main(args);
        Assert.Equal(0, exitcode);
        string[] generatedTrapsFiles = Directory.GetFiles(PathHolder.generatedTraps);
        string[] expectedTrapsFiles = Directory.GetFiles(PathHolder.expectedTraps);

        Assert.NotEmpty(generatedTrapsFiles);
        int numFailures = 0;
        var generatedFileNames = generatedTrapsFiles.Select(x => (Path.GetFileName(x), x)).ToList();
        var expectedFileNames = expectedTrapsFiles.Select(x => (Path.GetFileName(x), x)).ToList();
        foreach (var expectedTrapFile in expectedFileNames)
        {
            if (generatedFileNames.Any(x => x.Item1 == expectedTrapFile.Item1)) continue;
            numFailures++;
            _output.WriteLine($"{expectedTrapFile} has no matching filename in generated.");
        }
        foreach (var generated in generatedFileNames)
        {
            var expected = expectedFileNames.FirstOrDefault(filePath => filePath.Item1.Equals(generated.Item1));
            if (expected.Item1 is null || expected.x is null)
            {
                numFailures++;
                _output.WriteLine($"{generated.Item1} has no matching filename in expected.");
            }
            else
            {
                if (File.ReadAllText(generated.x).Contains("extractor_messages"))
                {
                    _output.WriteLine($"Test generated trap {generated} has extractor error messages.");
                    numFailures++;
                    continue;
                }
                string generatedFileSanitized = TrapSanitizer.SanitizeTrap(File.ReadAllLines(generated.x));
                string expectedFileSanitized = TrapSanitizer.SanitizeTrap(File.ReadAllLines(expected.x));
                if (!generatedFileSanitized.Equals(expectedFileSanitized))
                {
                    numFailures++;
                    _output.WriteLine($"{generated} does not match {expected}");
                }
            }
        }

        if (numFailures > 0)
        {
            _output.WriteLine($"{numFailures} errors were detected.");
        }
        Assert.Equal(expectedTrapsFiles.Length, generatedTrapsFiles.Length);
        Assert.Equal(0, numFailures);
    }
}