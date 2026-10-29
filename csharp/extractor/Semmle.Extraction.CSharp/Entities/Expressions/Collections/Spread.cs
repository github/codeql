using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class Spread : Expression
    {
        public Spread(Context cx, SpreadElementSyntax syntax, IExpressionParentEntity parent, int child) :
            base(new ExpressionInfo(cx, null, cx.CreateLocation(syntax.GetLocation()), ExprKind.SPREAD_ELEMENT, parent, child, isCompilerGenerated: false, null))
        {
            Create(cx, syntax.Expression, this, 0);
        }

        public static Expression Create(Context cx, SpreadElementSyntax syntax, IExpressionParentEntity parent, int child) =>
            new Spread(cx, syntax, parent, child);
    }
}
