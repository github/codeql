using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using Semmle.Extraction.Entities;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class Discard : Expression
    {
        public Discard(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.DISCARD))
        {
        }

        public Discard(Context cx, DiscardDesignationSyntax discard, IExpressionParentEntity parent, int child) :
            base(new ExpressionInfo(cx, Type.Create(cx, cx.Model(discard).GetTypeInfo(discard).Type), cx.Create(discard.GetLocation()), ExprKind.DISCARD, parent, child, false, null))
        {
        }

        public Discard(Context cx, DiscardPatternSyntax pattern, IExpressionParentEntity parent, int child) :
            base(new ExpressionInfo(cx, Type.Create(cx, cx.Model(pattern).GetTypeInfo(pattern).Type), cx.Create(pattern.GetLocation()), ExprKind.DISCARD, parent, child, false, null))
        {
        }
    }
}
