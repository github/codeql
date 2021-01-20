using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class EndRegionDirective : PreprocessorDirective<EndRegionDirectiveTriviaSyntax>
    {
        public EndRegionDirective(Context cx, EndRegionDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_endregions(this);
        }

        internal static void WriteRegionBlock(Context cx, RegionDirective region, EndRegionDirective endregion)
        {
            cx.TrapWriter.Writer.regions(region, endregion);
        }
    }
}
