using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class NullableDirective : PreprocessorDirective<NullableDirectiveTriviaSyntax>
    {
        public NullableDirective(Context cx, NullableDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            var setting = trivia.SettingToken.Kind() switch
            {
                SyntaxKind.DisableKeyword => 0,
                SyntaxKind.EnableKeyword => 1,
                SyntaxKind.RestoreKeyword => 2,
                _ => throw new InternalError(trivia, "Unhandled setting token kind")
            };

            var target = trivia.TargetToken.Kind() switch
            {
                SyntaxKind.None => 0,
                SyntaxKind.AnnotationsKeyword => 1,
                SyntaxKind.WarningsKeyword => 2,
                _ => throw new InternalError(trivia, "Unhandled target token kind")
            };

            trapFile.directive_nullables(this, setting, target);
        }
    }
}
