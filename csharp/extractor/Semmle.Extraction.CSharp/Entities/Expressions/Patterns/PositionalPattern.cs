using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class PositionalPattern : Expression
    {
        internal PositionalPattern(Context cx, PositionalPatternClauseSyntax posPc, IExpressionParentEntity parent, int child) :
            base(new ExpressionInfo(cx, null, cx.CreateLocation(posPc.GetLocation()), ExprKind.POSITIONAL_PATTERN, parent, child, false, null))
        {
            child = 0;
            foreach (var sub in posPc.Subpatterns)
            {
                Expressions.Pattern.Create(cx, sub.Pattern, this, child++);
            }
        }
    }
}
