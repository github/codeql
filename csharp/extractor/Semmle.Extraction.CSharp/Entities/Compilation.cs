using Microsoft.CodeAnalysis;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class Compilation : FreshEntity
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
            Extraction.Entities.Assembly.CreateOutputAssembly(cx);

            trapFile.compilations(this, FileUtils.ConvertToUnix(cwd));

            // Arguments
            var index = 0;
            foreach (var arg in args)
            {
                trapFile.compilation_args(this, index++, arg);
            }

            // Files
            index = 0;
            foreach (var file in cx.Compilation.SyntaxTrees.Select(tree => Extraction.Entities.File.Create(cx, tree.FilePath)))
            {
                trapFile.compilation_compiling_files(this, index++, file);
            }

            // References
            index = 0;
            foreach (var file in cx.Compilation.References.OfType<PortableExecutableReference>().Select(r => Extraction.Entities.File.Create(cx, r.FilePath)))
            {
                trapFile.compilation_referencing_files(this, index++, file);
            }

            // Diagnostics
            index = 0;
            foreach (var diag in cx.Compilation.GetDiagnostics().Select(d => new Diagnostic(cx, d)))
            {
                trapFile.diagnostic_for(diag, this, 0, index++);
            }
        }

        public void PopulatePerformance(PerformanceMetrics p)
        {
            var trapFile = cx.TrapWriter.Writer;
            var index = 0;
            foreach (var metric in p.Metrics)
            {
                trapFile.compilation_time(this, -1, index++, metric);
            }
            trapFile.compilation_finished(this, (float)p.Total.Cpu.TotalSeconds, (float)p.Total.Elapsed.TotalSeconds);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;
    }

    internal class Diagnostic : FreshEntity
    {
        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;

        private readonly Microsoft.CodeAnalysis.Diagnostic diagnostic;

        public Diagnostic(Context cx, Microsoft.CodeAnalysis.Diagnostic diag) : base(cx)
        {
            diagnostic = diag;
            TryPopulate();
        }

        protected override void Populate(TextWriter trapFile)
        {
            trapFile.diagnostics(this, (int)diagnostic.Severity, diagnostic.Id, diagnostic.Descriptor.Title.ToString(),
                diagnostic.GetMessage(), Extraction.Entities.Location.Create(cx, diagnostic.Location));
        }
    }

    public struct Timings
    {
        public TimeSpan Elapsed { get; set; }
        public TimeSpan Cpu { get; set; }
        public TimeSpan User { get; set; }
    }

    /// <summary>
    /// The various performance metrics to log.
    /// </summary>
    public struct PerformanceMetrics
    {
        public Timings Frontend { get; set; }
        public Timings Extractor { get; set; }
        public Timings Total { get; set; }
        public long PeakWorkingSet { get; set; }

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
