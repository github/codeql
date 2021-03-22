using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class LineDirective : PreprocessorDirective<LineDirectiveTriviaSyntax>
    {
        public LineDirective(Context cx, LineDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            var type = trivia.Line.Kind() switch
            {
                SyntaxKind.DefaultKeyword => 0,
                SyntaxKind.HiddenKeyword => 1,
                SyntaxKind.NumericLiteralToken => 2,
                _ => throw new InternalError(trivia, "Unhandled line token kind")
            };

            trapFile.directive_lines(this, type);

            if (trivia.Line.IsKind(SyntaxKind.NumericLiteralToken))
            {
                var value = (int)trivia.Line.Value!;
                trapFile.directive_line_value(this, value);

                if (!string.IsNullOrWhiteSpace(trivia.File.ValueText))
                {
                    var file = File.Create(Context, trivia.File.ValueText);
                    trapFile.directive_line_file(this, file);
                }
            }
        }
    }
}
