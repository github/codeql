using System.IO;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class LineDirective : LineOrSpanDirective<LineDirectiveTriviaSyntax>
    {
        private LineDirective(Context cx, LineDirectiveTriviaSyntax trivia)
            : base(cx, trivia, trivia.Line.Kind() switch
            {
                SyntaxKind.DefaultKeyword => LineDirectiveKind.Default,
                SyntaxKind.HiddenKeyword => LineDirectiveKind.Hidden,
                SyntaxKind.NumericLiteralToken => LineDirectiveKind.Numeric,
                _ => throw new InternalError(trivia, $"Unhandled line token kind {trivia.Line.Kind()}")
            })
        {
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            if (Symbol.Line.IsKind(SyntaxKind.NumericLiteralToken))
            {
                var value = (int)Symbol.Line.Value!;
                trapFile.directive_line_value(this, value);
            }

            base.PopulatePreprocessor(trapFile);
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
