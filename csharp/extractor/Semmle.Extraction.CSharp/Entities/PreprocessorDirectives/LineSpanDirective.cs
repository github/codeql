using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class LineSpanDirective : LineOrSpanDirective<LineSpanDirectiveTriviaSyntax>
    {
        private LineSpanDirective(Context cx, LineSpanDirectiveTriviaSyntax trivia)
            : base(cx, trivia, LineDirectiveKind.Span) { }

        public static LineSpanDirective Create(Context cx, LineSpanDirectiveTriviaSyntax line) =>
            LineSpanDirectiveFactory.Instance.CreateEntity(cx, line, line);

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            var startLine = (int)Symbol.Start.Line.Value!;
            var startColumn = (int)Symbol.Start.Character.Value!;
            var endLine = (int)Symbol.End.Line.Value!;
            var endColumn = (int)Symbol.End.Character.Value!;
            trapFile.directive_line_span(this, startLine, startColumn, endLine, endColumn);

            if (Symbol.CharacterOffset.Value is int offset)
            {
                trapFile.directive_line_offset(this, offset);
            }

            base.PopulatePreprocessor(trapFile);
        }

        private class LineSpanDirectiveFactory : CachedEntityFactory<LineSpanDirectiveTriviaSyntax, LineSpanDirective>
        {
            public static LineSpanDirectiveFactory Instance { get; } = new LineSpanDirectiveFactory();

            public override LineSpanDirective Create(Context cx, LineSpanDirectiveTriviaSyntax init) => new(cx, init);
        }
    }
}