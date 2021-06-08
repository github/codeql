using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class WarningDirective : PreprocessorDirective<WarningDirectiveTriviaSyntax>
    {
        public WarningDirective(Context cx, WarningDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_warnings(this, trivia.EndOfDirectiveToken.LeadingTrivia.ToString());
        }
    }
}
