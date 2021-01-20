using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class ElseDirective : PreprocessorDirective<ElseDirectiveTriviaSyntax>, IIfSiblingDirective
    {
        public ElseDirective(Context cx, ElseDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_elses(this, trivia.BranchTaken);
        }
    }
}
