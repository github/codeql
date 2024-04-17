using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Util;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class PositionalPattern : Expression
    {
        internal PositionalPattern(Context cx, PositionalPatternClauseSyntax posPc, IExpressionParentEntity parent, int child) :
            base(new ExpressionInfo(cx, null, cx.CreateLocation(posPc.GetLocation()), ExprKind.POSITIONAL_PATTERN, parent, child, isCompilerGenerated: false, null))
        {
            posPc.Subpatterns.ForEach((p, i) => Pattern.Create(cx, p.Pattern, this, i));
        }
    }
}
