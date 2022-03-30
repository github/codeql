using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class PragmaWarningDirective : PreprocessorDirective<PragmaWarningDirectiveTriviaSyntax>
    {
        private PragmaWarningDirective(Context cx, PragmaWarningDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.pragma_warnings(this, Symbol.DisableOrRestoreKeyword.IsKind(SyntaxKind.DisableKeyword) ? 0 : 1);

            var childIndex = 0;
            foreach (var code in Symbol.ErrorCodes)
            {
                trapFile.pragma_warning_error_codes(this, code.ToString(), childIndex++);
            }
        }

        public static PragmaWarningDirective Create(Context cx, PragmaWarningDirectiveTriviaSyntax p) =>
            PragmaWarningDirectiveFactory.Instance.CreateEntity(cx, p, p);

        private class PragmaWarningDirectiveFactory : CachedEntityFactory<PragmaWarningDirectiveTriviaSyntax, PragmaWarningDirective>
        {
            public static PragmaWarningDirectiveFactory Instance { get; } = new PragmaWarningDirectiveFactory();

            public override PragmaWarningDirective Create(Context cx, PragmaWarningDirectiveTriviaSyntax init) => new(cx, init);
        }
    }
}
