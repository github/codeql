using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal enum LineDirectiveKind
    {
        Default = 0,
        Hidden = 1,
        Numeric = 2,
        Span = 3
    }

    internal abstract class LineOrSpanDirective<T> : PreprocessorDirective<T> where T : LineOrSpanDirectiveTriviaSyntax
    {
        private readonly LineDirectiveKind kind;

        protected LineOrSpanDirective(Context cx, T trivia, LineDirectiveKind k)
            : base(cx, trivia)
        {
            kind = k;
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_lines(this, kind);

            if (!string.IsNullOrWhiteSpace(Symbol.File.ValueText))
            {
                var file = File.Create(Context, Symbol.File.ValueText);
                trapFile.directive_line_file(this, file);
            }
        }
    }
}
