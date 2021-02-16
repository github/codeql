using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class DefineDirective : PreprocessorDirective<DefineDirectiveTriviaSyntax>
    {
        public DefineDirective(Context cx, DefineDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_defines(this, trivia.Name.ToString());
        }
    }
}
