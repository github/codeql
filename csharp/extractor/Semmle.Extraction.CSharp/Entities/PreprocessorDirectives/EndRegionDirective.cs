using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class EndRegionDirective : PreprocessorDirective<EndRegionDirectiveTriviaSyntax>
    {
        private readonly RegionDirective region;

        public EndRegionDirective(Context cx, EndRegionDirectiveTriviaSyntax trivia, RegionDirective region)
            : base(cx, trivia, populateFromBase: false)
        {
            this.region = region;
            TryPopulate();
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_endregions(this, region);
        }
    }
}
