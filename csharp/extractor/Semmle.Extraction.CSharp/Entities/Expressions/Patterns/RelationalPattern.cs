using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class RelationalPattern : Expression
    {
        public RelationalPattern(Context cx, RelationalPatternSyntax syntax, IExpressionParentEntity parent, int child) :
             base(new ExpressionInfo(cx, null, cx.CreateLocation(syntax.GetLocation()), GetKind(syntax.OperatorToken), parent, child, isCompilerGenerated: false, null))
        {
            Expression.Create(cx, syntax.Expression, this, 0);
        }

        private static ExprKind GetKind(SyntaxToken operatorToken)
        {
            return operatorToken.Kind() switch
            {
                SyntaxKind.LessThanEqualsToken => ExprKind.LE_PATTERN,
                SyntaxKind.GreaterThanEqualsToken => ExprKind.GE_PATTERN,
                SyntaxKind.LessThanToken => ExprKind.LT_PATTERN,
                SyntaxKind.GreaterThanToken => ExprKind.GT_PATTERN,
                _ => throw new InternalError(operatorToken.Parent!, $"Relation pattern with operator token '{operatorToken.Kind()}' is not supported."),
            };
        }
    }
}
