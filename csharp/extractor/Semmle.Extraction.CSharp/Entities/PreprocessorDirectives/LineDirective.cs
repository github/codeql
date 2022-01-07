using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class LineDirective : PreprocessorDirective<LineDirectiveTriviaSyntax>
    {
        private LineDirective(Context cx, LineDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            var type = Symbol.Line.Kind() switch
            {
                SyntaxKind.DefaultKeyword => 0,
                SyntaxKind.HiddenKeyword => 1,
                SyntaxKind.NumericLiteralToken => 2,
                _ => throw new InternalError(Symbol, "Unhandled line token kind")
            };

            trapFile.directive_lines(this, type);

            if (Symbol.Line.IsKind(SyntaxKind.NumericLiteralToken))
            {
                var value = (int)Symbol.Line.Value!;
                trapFile.directive_line_value(this, value);

                if (!string.IsNullOrWhiteSpace(Symbol.File.ValueText))
                {
                    var file = File.Create(Context, Symbol.File.ValueText);
                    trapFile.directive_line_file(this, file);
                }
            }
        }

        public static LineDirective Create(Context cx, LineDirectiveTriviaSyntax line) =>
            LineDirectiveFactory.Instance.CreateEntity(cx, line, line);

        private class LineDirectiveFactory : CachedEntityFactory<LineDirectiveTriviaSyntax, LineDirective>
        {
            public static LineDirectiveFactory Instance { get; } = new LineDirectiveFactory();

            public override LineDirective Create(Context cx, LineDirectiveTriviaSyntax init) => new(cx, init);
        }
    }
}
