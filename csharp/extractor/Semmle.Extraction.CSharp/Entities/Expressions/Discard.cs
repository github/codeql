using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using Semmle.Extraction.Entities;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class Discard : Expression
    {
        public Discard(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.DISCARD))
        {
        }

        Discard(Context cx, CSharpSyntaxNode syntax, IExpressionParentEntity parent, int child) :
            base(new ExpressionInfo(cx, Type.Create(cx, cx.Model(syntax).GetTypeInfo(syntax).Type), cx.Create(syntax.GetLocation()), ExprKind.DISCARD, parent, child, false, null))
        {
        }

        public Discard(Context cx, DiscardDesignationSyntax discard, IExpressionParentEntity parent, int child) : this(cx, (CSharpSyntaxNode)discard, parent, child)
        {
        }

        public Discard(Context cx, DiscardPatternSyntax pattern, IExpressionParentEntity parent, int child) : this(cx, (CSharpSyntaxNode)pattern, parent, child)
        {
        }
    }
}
