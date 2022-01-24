using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Entities;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class InterpolatedString : Expression<InterpolatedStringExpressionSyntax>
    {
        private InterpolatedString(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.INTERPOLATED_STRING)) { }

        public static Expression Create(ExpressionNodeInfo info) => new InterpolatedString(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            var child = 0;
            foreach (var c in Syntax.Contents)
            {
                switch (c.Kind())
                {
                    case SyntaxKind.Interpolation:
                        var interpolation = (InterpolationSyntax)c;
                        Create(Context, interpolation.Expression, this, child++);
                        break;
                    case SyntaxKind.InterpolatedStringText:
                        // Create a string literal
                        var interpolatedText = (InterpolatedStringTextSyntax)c;
                        new Expression(new ExpressionInfo(Context, Type, Context.CreateLocation(c.GetLocation()), ExprKind.STRING_LITERAL, this, child++, false, interpolatedText.TextToken.Text));
                        break;
                    default:
                        throw new InternalError(c, $"Unhandled interpolation kind {c.Kind()}");
                }
            }
        }
    }
}
