using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class ElseDirective : PreprocessorDirective<ElseDirectiveTriviaSyntax>, IIfSiblingDirective
    {
        private readonly IfDirective start;
        private readonly int index;

        public ElseDirective(Context cx, ElseDirectiveTriviaSyntax trivia, IfDirective start, int index)
            : base(cx, trivia, populateFromBase: false)
        {
            this.start = start;
            this.index = index;
            TryPopulate();
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_elses(this, trivia.BranchTaken, start, index);
        }
    }
}
