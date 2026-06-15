using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class RegionDirective : PreprocessorDirective<RegionDirectiveTriviaSyntax>
    {
        private RegionDirective(Context cx, RegionDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_regions(this, Symbol.EndOfDirectiveToken.LeadingTrivia.ToString());
        }

        public static RegionDirective Create(Context cx, RegionDirectiveTriviaSyntax region) =>
            RegionDirectiveFactory.Instance.CreateEntity(cx, region, region);

        private class RegionDirectiveFactory : CachedEntityFactory<RegionDirectiveTriviaSyntax, RegionDirective>
        {
            public static RegionDirectiveFactory Instance { get; } = new RegionDirectiveFactory();

            public override RegionDirective Create(Context cx, RegionDirectiveTriviaSyntax init) => new(cx, init);
        }
    }
}
