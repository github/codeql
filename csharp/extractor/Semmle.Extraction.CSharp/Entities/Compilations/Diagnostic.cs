using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class Diagnostic : FreshEntity
    {
        private readonly Microsoft.CodeAnalysis.Diagnostic diagnostic;

        public Diagnostic(Context cx, Microsoft.CodeAnalysis.Diagnostic diag) : base(cx)
        {
            diagnostic = diag;
            TryPopulate();
        }

        protected override void Populate(TextWriter trapFile)
        {
            trapFile.diagnostics(this, (int)diagnostic.Severity, diagnostic.Id, diagnostic.Descriptor.Title.ToString(),
                diagnostic.GetMessage(), Context.CreateLocation(diagnostic.Location));
        }
    }
}
