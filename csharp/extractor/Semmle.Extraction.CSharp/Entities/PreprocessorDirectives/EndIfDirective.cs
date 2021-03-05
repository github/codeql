using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class EndIfDirective : PreprocessorDirective<EndIfDirectiveTriviaSyntax>
    {
        private readonly IfDirective start;

        public EndIfDirective(Context cx, EndIfDirectiveTriviaSyntax trivia, IfDirective start)
            : base(cx, trivia, populateFromBase: false)
        {
            this.start = start;
            TryPopulate();
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_endifs(this, start);
        }
    }
}
