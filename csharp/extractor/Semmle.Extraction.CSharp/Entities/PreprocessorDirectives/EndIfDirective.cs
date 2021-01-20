using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class EndIfDirective : PreprocessorDirective<EndIfDirectiveTriviaSyntax>
    {
        public EndIfDirective(Context cx, EndIfDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_endifs(this);
        }
    }
}
