using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class PositionalPattern : Expression
    {
        internal PositionalPattern(Context cx, PositionalPatternClauseSyntax posPc, IExpressionParentEntity parent, int child) :
            base(new ExpressionInfo(cx, null, cx.CreateLocation(posPc.GetLocation()), ExprKind.POSITIONAL_PATTERN, parent, child, false, null))
        {
            posPc.Subpatterns.ForEach((p, i) => Pattern.Create(cx, p.Pattern, this, i));
        }
    }
}
