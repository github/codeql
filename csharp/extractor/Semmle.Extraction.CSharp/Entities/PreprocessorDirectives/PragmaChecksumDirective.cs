using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class PragmaChecksumDirective : PreprocessorDirective<PragmaChecksumDirectiveTriviaSyntax>
    {
        private PragmaChecksumDirective(Context cx, PragmaChecksumDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            var file = File.Create(Context, Symbol.File.ValueText);
            trapFile.pragma_checksums(this, file, Symbol.Guid.ToString(), Symbol.Bytes.ToString());
        }

        public static PragmaChecksumDirective Create(Context cx, PragmaChecksumDirectiveTriviaSyntax p) =>
            PragmaChecksumDirectiveFactory.Instance.CreateEntity(cx, p, p);

        private class PragmaChecksumDirectiveFactory : CachedEntityFactory<PragmaChecksumDirectiveTriviaSyntax, PragmaChecksumDirective>
        {
            public static PragmaChecksumDirectiveFactory Instance { get; } = new PragmaChecksumDirectiveFactory();

            public override PragmaChecksumDirective Create(Context cx, PragmaChecksumDirectiveTriviaSyntax init) => new(cx, init);
        }
    }
}
