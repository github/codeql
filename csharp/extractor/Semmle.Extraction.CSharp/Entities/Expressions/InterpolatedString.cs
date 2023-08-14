using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Entities;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class InterpolatedStringAlignmentClause : Expression
    {
        // TODO: Introduce the correct expression kind.
        private InterpolatedStringAlignmentClause(Context cx, InterpolationAlignmentClauseSyntax syntax, IExpressionParentEntity parent, int child) : base(new ExpressionInfo(cx, null, cx.CreateLocation(syntax.GetLocation()), ExprKind.INTERPOLATED_STRING_ALIGNMENT, parent, child, false, null))
        {
            Expression.Create(cx, syntax.Value, this, 0);
        }

        public static Expression Create(Context cx, InterpolationAlignmentClauseSyntax syntax, IExpressionParentEntity parent, int child) =>
            new InterpolatedStringAlignmentClause(cx, syntax, parent, child);

    }

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
                        if (interpolation.AlignmentClause is not null)
                        {
                            InterpolatedStringAlignmentClause.Create(Context, interpolation.AlignmentClause.Value, this, child++);
                        }
                        break;
                    case SyntaxKind.InterpolatedStringText:
                        // Create a string literal
                        var interpolatedText = (InterpolatedStringTextSyntax)c;
                        new Expression(new ExpressionInfo(Context, Type, Context.CreateLocation(c.GetLocation()), ExprKind.UTF16_STRING_LITERAL, this, child++, false, interpolatedText.TextToken.ValueText));
                        break;
                    default:
                        throw new InternalError(c, $"Unhandled interpolation kind {c.Kind()}");
                }
            }
        }
    }
}
