using Microsoft.CodeAnalysis;
using System;
using System.IO;
using System.Linq;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class Compilation : CachedEntity<object>
    {
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
            var index = 0;
            foreach (var arg in Compilation.Settings.Args)
            {
                trapFile.compilation_args(this, index++, arg);
            }

            // Files
            index = 0;
            foreach (var file in Context.Compilation.SyntaxTrees.Select(tree => File.Create(Context, tree.FilePath)))
            {
                trapFile.compilation_compiling_files(this, index++, file);
            }

            // References
            index = 0;
            foreach (var file in Context.Compilation.References
                .OfType<PortableExecutableReference>()
                .Where(r => r.FilePath is not null)
                .Select(r => File.Create(Context, r.FilePath!)))
            {
                trapFile.compilation_referencing_files(this, index++, file);
            }

            // Diagnostics
            index = 0;
            foreach (var diag in Context.Compilation.GetDiagnostics().Select(d => new Diagnostic(Context, d)))
            {
                trapFile.diagnostic_for(diag, this, 0, index++);
            }
        }

        public void PopulatePerformance(PerformanceMetrics p)
        {
            var trapFile = Context.TrapWriter.Writer;
            var index = 0;
            foreach (var metric in p.Metrics)
            {
                trapFile.compilation_time(this, -1, index++, metric);
            }
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
