using System;
using System.Collections.Concurrent;
using System.IO;
using System.Linq;
using Microsoft.CodeAnalysis;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class Compilation : CachedEntity<object>
    {
        internal readonly ConcurrentDictionary<string, int> messageCounts = new();

        private static (string Cwd, string[] Args) settings;
        private static int hashCode;

        public static (string Cwd, string[] Args) Settings
        {
            get { return settings; }
            set
            {
                settings = value;
                hashCode = settings.Cwd.GetHashCode();
                for (var i = 0; i < settings.Args.Length; i++)
                {
                    hashCode = HashCode.Combine(hashCode, settings.Args[i].GetHashCode());
                }
            }
        }

#nullable disable warnings
        private Compilation(Context cx) : base(cx, null)
        {
        }
#nullable restore warnings

        public override void Populate(TextWriter trapFile)
        {
            var assembly = Assembly.CreateOutputAssembly(Context);

            trapFile.compilations(this, FileUtils.ConvertToUnix(Compilation.Settings.Cwd));
            trapFile.compilation_assembly(this, assembly);

            // Arguments
            var expandedIndex = 0;
            for (var i = 0; i < Compilation.Settings.Args.Length; i++)
            {
                var arg = Compilation.Settings.Args[i];
                trapFile.compilation_args(this, i, arg);

                if (CommandLineExtensions.IsFileArgument(arg))
                {
                    try
                    {
                        var rspFileContent = System.IO.File.ReadAllText(arg[1..]);
                        var rspArgs = CommandLineParser.SplitCommandLineIntoArguments(rspFileContent, removeHashComments: true);
                        foreach (var rspArg in rspArgs)
                        {
                            trapFile.compilation_expanded_args(this, expandedIndex++, rspArg);
                        }
                    }
                    catch (Exception exc)
                    {
                        Context.ExtractionError($"Couldn't read compiler argument file: {arg}. {exc.Message}", null, null, exc.StackTrace);
                    }
                }
                else
                {
                    trapFile.compilation_expanded_args(this, expandedIndex++, arg);
                }
            }

            // Files
            Context.Compilation.SyntaxTrees.Select(tree => File.Create(Context, tree.FilePath)).ForEach((file, index) => trapFile.compilation_compiling_files(this, index, file));

            // References
            Context.Compilation.References
                .OfType<PortableExecutableReference>()
                .Where(r => r.FilePath is not null)
                .Select(r => File.Create(Context, r.FilePath!))
                .ForEach((file, index) => trapFile.compilation_referencing_files(this, index, file));

            // Diagnostics
            var diags = Context.Compilation.GetDiagnostics();
            diags.ForEach((diag, index) => new CompilerDiagnostic(Context, diag, this, index));

            var diagCounts = diags.GroupBy(diag => diag.Id).ToDictionary(group => group.Key, group => group.Count());
            diagCounts.ForEach(pair => trapFile.compilation_info(this, $"Compiler diagnostic count for {pair.Key}", pair.Value.ToString()));
        }

        public void PopulatePerformance(PerformanceMetrics p)
        {
            var trapFile = Context.TrapWriter.Writer;
            p.Metrics.ForEach((metric, index) => trapFile.compilation_time(this, -1, index, metric));
            trapFile.compilation_finished(this, (float)p.Total.Cpu.TotalSeconds, (float)p.Total.Elapsed.TotalSeconds);
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.Write(hashCode);
            trapFile.Write(";compilation");
        }

        public override Location ReportingLocation => throw new NotImplementedException();

        public override bool NeedsPopulation => Context.IsAssemblyScope;

        private class CompilationFactory : CachedEntityFactory<object?, Compilation>
        {
            public static CompilationFactory Instance { get; } = new CompilationFactory();

            public override Compilation Create(Context cx, object? init) => new Compilation(cx);
        }

        private static readonly object compilationCacheKey = new object();

        public static Compilation Create(Context cx)
            => CompilationFactory.Instance.CreateEntity(cx, compilationCacheKey, null);
    }
}
