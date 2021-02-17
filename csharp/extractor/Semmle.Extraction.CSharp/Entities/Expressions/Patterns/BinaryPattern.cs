using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Entities;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class BinaryPattern : Expression
    {
        public BinaryPattern(Context cx, BinaryPatternSyntax syntax, IExpressionParentEntity parent, int child) :
            base(new ExpressionInfo(cx, null, cx.CreateLocation(syntax.GetLocation()), GetKind(syntax.OperatorToken, syntax), parent, child, false, null))
        {
            Pattern.Create(cx, syntax.Left, this, 0);
            Pattern.Create(cx, syntax.Right, this, 1);
        }

        private static ExprKind GetKind(SyntaxToken operatorToken, BinaryPatternSyntax syntax)
        {
            return operatorToken.Kind() switch
            {
                SyntaxKind.AndKeyword => ExprKind.AND_PATTERN,
                SyntaxKind.OrKeyword => ExprKind.OR_PATTERN,
                _ => throw new InternalError(syntax, $"Operator '{operatorToken.Kind()}' is not supported in binary patterns.")
            };
        }
    }
}