using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class ErrorDirective : PreprocessorDirective<ErrorDirectiveTriviaSyntax>
    {
        public ErrorDirective(Context cx, ErrorDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_errors(this, trivia.EndOfDirectiveToken.LeadingTrivia.ToString());
        }
    }
}
