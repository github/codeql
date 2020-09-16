using Microsoft.CodeAnalysis;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    class Compilation : FreshEntity
    {
        private readonly string cwd;
        private readonly string[] args;

        public Compilation(Context cx, string cwd, string[] args) : base(cx)
        {
            this.cwd = cwd;
            this.args = args;
            TryPopulate();
        }

        protected override void Populate(TextWriter trapFile)
        {
            Extraction.Entities.Assembly.CreateOutputAssembly(Cx);

            trapFile.compilations(this, Extraction.Entities.File.PathAsDatabaseString(cwd));

            // Arguments
            int index = 0;
            foreach (var arg in args)
            {
                trapFile.compilation_args(this, index++, arg);
            }

            // Files
            index = 0;
            foreach (var file in Cx.Compilation.SyntaxTrees.Select(tree => Extraction.Entities.File.Create(Cx, tree.FilePath)))
            {
                trapFile.compilation_compiling_files(this, index++, file);
            }

            // References
            index = 0;
            foreach (var file in Cx.Compilation.References.OfType<PortableExecutableReference>().Select(r => Extraction.Entities.File.Create(Cx, r.FilePath)))
            {
                trapFile.compilation_referencing_files(this, index++, file);
            }

            // Diagnostics
            index = 0;
            foreach (var diag in Cx.Compilation.GetDiagnostics().Select(d => new Diagnostic(Cx, d)))
            {
                trapFile.diagnostic_for(diag, this, 0, index++);
            }
        }

        public void PopulatePerformance(PerformanceMetrics p)
        {
            var trapFile = Cx.TrapWriter.Writer;
            int index = 0;
            foreach (float metric in p.Metrics)
            {
                trapFile.compilation_time(this, -1, index++, metric);
            }
            trapFile.compilation_finished(this, (float)p.Total.Cpu.TotalSeconds, (float)p.Total.Elapsed.TotalSeconds);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;
    }

    class Diagnostic : FreshEntity
    {
        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;

        readonly Microsoft.CodeAnalysis.Diagnostic diagnostic;

        public Diagnostic(Context cx, Microsoft.CodeAnalysis.Diagnostic diag) : base(cx)
        {
            diagnostic = diag;
            TryPopulate();
        }

        protected override void Populate(TextWriter trapFile)
        {
            trapFile.diagnostics(this, (int)diagnostic.Severity, diagnostic.Id, diagnostic.Descriptor.Title.ToString(),
                diagnostic.GetMessage(), Extraction.Entities.Location.Create(Cx, diagnostic.Location));
        }
    }

    public struct Timings
    {
        public TimeSpan Elapsed, Cpu, User;
    }

    /// <summary>
    /// The various performance metrics to log.
    /// </summary>
    public struct PerformanceMetrics
    {
        public Timings Frontend, Extractor, Total;
        public long PeakWorkingSet;

        /// <summary>
        /// These are in database order (0 indexed)
        /// </summary>
        public IEnumerable<float> Metrics
        {
            get
            {
                yield return (float)Frontend.Cpu.TotalSeconds;
                yield return (float)Frontend.Elapsed.TotalSeconds;
                yield return (float)Extractor.Cpu.TotalSeconds;
                yield return (float)Extractor.Elapsed.TotalSeconds;
                yield return (float)Frontend.User.TotalSeconds;
                yield return (float)Extractor.User.TotalSeconds;
                yield return PeakWorkingSet / 1024.0f / 1024.0f;
            }
        }
    }
}
