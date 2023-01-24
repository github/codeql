using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class ListPattern : Expression
    {
        internal ListPattern(Context cx, ListPatternSyntax syntax, IExpressionParentEntity parent, int child) :
            base(new ExpressionInfo(cx, null, cx.CreateLocation(syntax.GetLocation()), ExprKind.LIST_PATTERN, parent, child, false, null))
        {
            syntax.Patterns.ForEach((p, i) => Pattern.Create(cx, p, this, i));
        }
    }
}