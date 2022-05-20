using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class EndRegionDirective : PreprocessorDirective<EndRegionDirectiveTriviaSyntax>
    {
        private readonly RegionDirective region;

        private EndRegionDirective(Context cx, EndRegionDirectiveTriviaSyntax trivia, RegionDirective region)
            : base(cx, trivia)
        {
            this.region = region;
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_endregions(this, region);
        }

        public static EndRegionDirective Create(Context cx, EndRegionDirectiveTriviaSyntax end, RegionDirective start) =>
            EndRegionDirectiveFactory.Instance.CreateEntity(cx, end, (end, start));

        private class EndRegionDirectiveFactory : CachedEntityFactory<(EndRegionDirectiveTriviaSyntax end, RegionDirective start), EndRegionDirective>
        {
            public static EndRegionDirectiveFactory Instance { get; } = new EndRegionDirectiveFactory();

            public override EndRegionDirective Create(Context cx, (EndRegionDirectiveTriviaSyntax end, RegionDirective start) init) => new(cx, init.end, init.start);
        }
    }
}
