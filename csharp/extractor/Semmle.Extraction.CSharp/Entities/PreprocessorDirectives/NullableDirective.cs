using System.IO;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class NullableDirective : PreprocessorDirective<NullableDirectiveTriviaSyntax>
    {
        private NullableDirective(Context cx, NullableDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            var setting = Symbol.SettingToken.Kind() switch
            {
                SyntaxKind.DisableKeyword => 0,
                SyntaxKind.EnableKeyword => 1,
                SyntaxKind.RestoreKeyword => 2,
                _ => throw new InternalError(Symbol, $"Unhandled setting token kind {Symbol.SettingToken.Kind()}")
            };

            var target = Symbol.TargetToken.Kind() switch
            {
                SyntaxKind.None => 0,
                SyntaxKind.AnnotationsKeyword => 1,
                SyntaxKind.WarningsKeyword => 2,
                _ => throw new InternalError(Symbol, $"Unhandled target token kind {Symbol.TargetToken.Kind()}")
            };

            trapFile.directive_nullables(this, setting, target);
        }

        public static NullableDirective Create(Context cx, NullableDirectiveTriviaSyntax nullable) =>
            NullableDirectiveFactory.Instance.CreateEntity(cx, nullable, nullable);

        private class NullableDirectiveFactory : CachedEntityFactory<NullableDirectiveTriviaSyntax, NullableDirective>
        {
            public static NullableDirectiveFactory Instance { get; } = new NullableDirectiveFactory();

            public override NullableDirective Create(Context cx, NullableDirectiveTriviaSyntax init) => new(cx, init);
        }
    }
}
