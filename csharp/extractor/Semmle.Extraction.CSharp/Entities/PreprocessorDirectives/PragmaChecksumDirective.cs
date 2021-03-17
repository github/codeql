using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class PragmaChecksumDirective : PreprocessorDirective<PragmaChecksumDirectiveTriviaSyntax>
    {
        public PragmaChecksumDirective(Context cx, PragmaChecksumDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            var file = File.Create(Context, trivia.File.ValueText);
            trapFile.pragma_checksums(this, file, trivia.Guid.ToString(), trivia.Bytes.ToString());
        }
    }
}
