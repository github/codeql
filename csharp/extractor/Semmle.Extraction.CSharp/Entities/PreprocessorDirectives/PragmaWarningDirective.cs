using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class PragmaWarningDirective : PreprocessorDirective<PragmaWarningDirectiveTriviaSyntax>
    {
        public PragmaWarningDirective(Context cx, PragmaWarningDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.pragma_warnings(this, trivia.DisableOrRestoreKeyword.IsKind(SyntaxKind.DisableKeyword) ? 0 : 1);

            var childIndex = 0;
            foreach (var code in trivia.ErrorCodes)
            {
                trapFile.pragma_warning_error_codes(this, code.ToString(), childIndex++);
            }
        }
    }
}
