using System.IO;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class CompilerDiagnostic : FreshEntity
    {
        private static readonly int limit = EnvironmentVariables.TryGetExtractorNumberOption<int>("COMPILER_DIAGNOSTIC_LIMIT") ?? 1000;

        private readonly Microsoft.CodeAnalysis.Diagnostic diagnostic;
        private readonly Compilation compilation;
        private readonly int index;

        public CompilerDiagnostic(Context cx, Microsoft.CodeAnalysis.Diagnostic diag, Compilation compilation, int index) : base(cx)
        {
            diagnostic = diag;
            this.compilation = compilation;
            this.index = index;
            TryPopulate();
        }

        protected override void Populate(TextWriter trapFile)
        {
            // The below doesn't limit the extractor messages to the exact limit, but it's good enough.
            var key = diagnostic.Id;
            var messageCount = compilation.messageCounts.AddOrUpdate(key, 1, (_, c) => c + 1);
            if (messageCount > limit)
            {
                if (messageCount == limit + 1)
                {
                    Context.ExtractionContext.Logger.LogWarning($"Stopped logging {key} compiler diagnostics for the current compilation after reaching {limit}");
                }

                return;
            }

            trapFile.diagnostics(this, (int)diagnostic.Severity, key, diagnostic.Descriptor.Title.ToString(),
                diagnostic.GetMessage(), Context.CreateLocation(diagnostic.Location));

            trapFile.diagnostic_for(this, compilation, 0, index);
        }
    }
}
