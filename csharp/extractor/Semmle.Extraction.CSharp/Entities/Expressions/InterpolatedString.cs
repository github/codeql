using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class InterpolatedString : Expression<InterpolatedStringExpressionSyntax>
    {
        InterpolatedString(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.INTERPOLATED_STRING)) { }

        public static Expression Create(ExpressionNodeInfo info) => new InterpolatedString(info).TryPopulate();

        protected override void Populate()
        {
            var child = 0;
            foreach (var c in Syntax.Contents)
            {
                switch (c.Kind())
                {
                    case SyntaxKind.Interpolation:
                        var interpolation = (InterpolationSyntax)c;
                        Create(cx, interpolation.Expression, this, child++);
                        break;
                    case SyntaxKind.InterpolatedStringText:
                        // Create a string literal
                        var interpolatedText = (InterpolatedStringTextSyntax)c;
                        new Expression(new ExpressionInfo(cx, Type, cx.Create(c.GetLocation()), ExprKind.STRING_LITERAL, this, child++, false, interpolatedText.TextToken.Text));
                        break;
                    default:
                        throw new InternalError(c, $"Unhandled interpolation kind {c.Kind()}");
                }
            }
        }
    }
}
