using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class WarningDirective : PreprocessorDirective<WarningDirectiveTriviaSyntax>
    {
        private WarningDirective(Context cx, WarningDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_warnings(this, Symbol.EndOfDirectiveToken.LeadingTrivia.ToString());
        }

        public static WarningDirective Create(Context cx, WarningDirectiveTriviaSyntax warning) =>
            WarningDirectiveFactory.Instance.CreateEntity(cx, warning, warning);

        private class WarningDirectiveFactory : CachedEntityFactory<WarningDirectiveTriviaSyntax, WarningDirective>
        {
            public static WarningDirectiveFactory Instance { get; } = new WarningDirectiveFactory();

            public override WarningDirective Create(Context cx, WarningDirectiveTriviaSyntax init) => new(cx, init);
        }
    }
}
