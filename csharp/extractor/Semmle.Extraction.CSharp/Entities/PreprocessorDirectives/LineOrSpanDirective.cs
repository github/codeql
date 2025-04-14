using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;

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

            var path = Symbol.File.ValueText;
            if (!string.IsNullOrWhiteSpace(path))
            {
                path = Context.TryAdjustRelativeMappedFilePath(path, Symbol.SyntaxTree.FilePath);
                var file = File.Create(Context, path);
                trapFile.directive_line_file(this, file);
            }
        }
    }
}
