using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class UndefineDirective : PreprocessorDirective<UndefDirectiveTriviaSyntax>
    {
        public UndefineDirective(Context cx, UndefDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_undefines(this, trivia.Name.ToString());
        }
    }
}
