using System;
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
    public static void GenerateStubs(ILogger logger, IEnumerable<string> referencesPaths, string outputPath)
    {
        var stopWatch = new System.Diagnostics.Stopwatch();
        stopWatch.Start();

        var threads = EnvironmentVariables.GetDefaultNumberOfThreads();

        using var references = new BlockingCollection<(MetadataReference Reference, string Path)>();

        Parallel.ForEach(referencesPaths, new ParallelOptions { MaxDegreeOfParallelism = threads }, path =>
        {
            var reference = MetadataReference.CreateFromFile(path);
            references.Add((reference, path));
        });

        logger.Log(Severity.Info, $"Generating stubs for {references.Count} assemblies.");

        var compilation = CSharpCompilation.Create(
            "stubgenerator.dll",
            null,
            references.Select(tuple => tuple.Item1),
            new CSharpCompilationOptions(OutputKind.ConsoleApplication, allowUnsafe: true));

        Parallel.ForEach(references, new ParallelOptions { MaxDegreeOfParallelism = threads }, @ref =>
        {
            StubReference(logger, compilation, outputPath, @ref.Reference, @ref.Path);
        });

        stopWatch.Stop();
        logger.Log(Severity.Info, $"Stub generation took {stopWatch.Elapsed}.");
    }

    private static void StubReference(ILogger logger, CSharpCompilation compilation, string outputPath, MetadataReference reference, string path)
    {
        if (compilation.GetAssemblyOrModuleSymbol(reference) is not IAssemblySymbol assembly)
            return;

        Func<StreamWriter> makeWriter = () =>
        {
            var fileStream = new FileStream(FileUtils.NestPaths(logger, outputPath, path.Replace(".dll", ".cs")), FileMode.Create, FileAccess.Write);
            var writer = new StreamWriter(fileStream, new UTF8Encoding(false));
            return writer;
        };

        using var visitor = new StubVisitor(assembly, makeWriter);

        if (!assembly.Modules.Any(m => visitor.IsRelevantNamespace(m.GlobalNamespace)))
            return;

        visitor.StubWriter.WriteLine("// This file contains auto-generated code.");
        visitor.StubWriter.WriteLine($"// Generated from `{assembly.Identity}`.");

        visitor.StubAttributes(assembly.GetAttributes(), "assembly: ");

        foreach (var module in assembly.Modules)
        {
            module.GlobalNamespace.Accept(visitor);
        }
    }
}

