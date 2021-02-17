using Microsoft.CodeAnalysis.CSharp.Syntax;
using System;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class RegionDirective : PreprocessorDirective<RegionDirectiveTriviaSyntax>
    {
        public RegionDirective(Context cx, RegionDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_regions(this, trivia.EndOfDirectiveToken.LeadingTrivia.ToString());
        }
    }
}
