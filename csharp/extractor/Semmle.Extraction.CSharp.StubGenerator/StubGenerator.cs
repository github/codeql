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
        var referenceResolveTasks = GetResolvedReferenceTasks(referencesPaths, references);

        Parallel.Invoke(
            new ParallelOptions { MaxDegreeOfParallelism = threads },
            referenceResolveTasks.ToArray());

        logger.Log(Severity.Info, $"Generating stubs for {references.Count} assemblies.");

        var compilation = CSharpCompilation.Create(
            "stubgenerator.dll",
            null,
            references.Select(tuple => tuple.Item1),
            new CSharpCompilationOptions(OutputKind.ConsoleApplication, allowUnsafe: true));

        var referenceStubTasks = references.Select(@ref => (Action)(() => StubReference(compilation, outputPath, @ref.Reference, @ref.Path)));
        Parallel.Invoke(
            new ParallelOptions { MaxDegreeOfParallelism = threads },
            referenceStubTasks.ToArray());

        stopWatch.Stop();
        logger.Log(Severity.Info, $"Stub generation took {stopWatch.Elapsed}.");
    }

    private static IEnumerable<Action> GetResolvedReferenceTasks(IEnumerable<string> referencePaths, BlockingCollection<(MetadataReference, string)> references)
    {
        return referencePaths.Select<string, Action>(path => () =>
        {
            var reference = MetadataReference.CreateFromFile(path);
            references.Add((reference, path));
        });
    }

    private static void StubReference(CSharpCompilation compilation, string outputPath, MetadataReference reference, string path)
    {
        if (compilation.GetAssemblyOrModuleSymbol(reference) is IAssemblySymbol assembly)
        {
            var logger = new ConsoleLogger(Verbosity.Info);
            using var fileStream = new FileStream(FileUtils.NestPaths(logger, outputPath, path.Replace(".dll", ".cs")), FileMode.Create, FileAccess.Write);
            using var writer = new StreamWriter(fileStream, new UTF8Encoding(false));

            writer.WriteLine("// This file contains auto-generated code.");
            writer.WriteLine($"// Generated from `{assembly.Identity}`.");

            var visitor = new StubVisitor(assembly, writer);

            visitor.StubAttributes(assembly.GetAttributes(), "assembly: ");

            foreach (var module in assembly.Modules)
            {
                module.GlobalNamespace.Accept(new StubVisitor(assembly, writer));
            }
        }
    }
}

