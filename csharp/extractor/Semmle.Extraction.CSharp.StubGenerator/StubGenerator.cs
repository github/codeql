using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;

using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.StubGenerator;

public static class StubGenerator
{
    /// <summary>
    /// Generates stubs for all the provided assembly paths.
    /// </summary>
    /// <param name="referencesPaths">The paths of the assemblies to generate stubs for.</param>
    /// <param name="outputPath">The path in which to store the stubs.</param>
    public static string[] GenerateStubs(ILogger logger, IEnumerable<string> referencesPaths, string outputPath)
    {
        var stopWatch = new System.Diagnostics.Stopwatch();
        stopWatch.Start();

        var threads = EnvironmentVariables.GetDefaultNumberOfThreads();

        using var stubPaths = new BlockingCollection<string>();
        using var references = new BlockingCollection<(MetadataReference Reference, string Path)>();

        Parallel.ForEach(referencesPaths, new ParallelOptions { MaxDegreeOfParallelism = threads }, path =>
        {
            var reference = MetadataReference.CreateFromFile(path);
            references.Add((reference, path));
        });

        logger.LogInfo($"Generating stubs for {references.Count} assemblies.");

        var compilation = CSharpCompilation.Create(
            "stubgenerator.dll",
            null,
            references.Select(tuple => tuple.Item1),
            new CSharpCompilationOptions(OutputKind.ConsoleApplication, allowUnsafe: true));

        Parallel.ForEach(references, new ParallelOptions { MaxDegreeOfParallelism = threads }, @ref =>
        {
            StubReference(logger, compilation, outputPath, @ref.Reference, @ref.Path, stubPaths);
        });

        stopWatch.Stop();
        logger.LogInfo($"Stub generation took {stopWatch.Elapsed}.");

        return stubPaths.ToArray();
    }

    private static void StubReference(ILogger logger, CSharpCompilation compilation, string outputPath, MetadataReference reference, string path, BlockingCollection<string> stubPaths)
    {
        if (compilation.GetAssemblyOrModuleSymbol(reference) is not IAssemblySymbol assembly)
            return;

        var relevantSymbol = new RelevantSymbol(assembly);

        if (!assembly.Modules.Any(m => relevantSymbol.IsRelevantNamespace(m.GlobalNamespace)))
            return;

        var stubPath = FileUtils.NestPaths(logger, outputPath, path.Replace(".dll", ".cs"));
        stubPaths.Add(stubPath);
        using var fileStream = new FileStream(stubPath, FileMode.Create, FileAccess.Write);
        using var writer = new StreamWriter(fileStream, new UTF8Encoding(false)) { NewLine = "\n" };

        var visitor = new StubVisitor(writer, relevantSymbol);

        writer.WriteLine("// This file contains auto-generated code.");
        writer.WriteLine($"// Generated from `{assembly.Identity}`.");

        visitor.StubAttributes(assembly.GetAttributes(), "assembly: ");

        foreach (var module in assembly.Modules)
        {
            module.GlobalNamespace.Accept(visitor);
        }
    }
}
