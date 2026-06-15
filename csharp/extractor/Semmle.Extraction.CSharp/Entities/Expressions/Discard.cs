using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class Discard : Expression
    {
        public Discard(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.DISCARD))
        {
        }

        private Discard(Context cx, CSharpSyntaxNode syntax, IExpressionParentEntity parent, int child) :
            base(new ExpressionInfo(cx, cx.GetType(syntax), cx.CreateLocation(syntax.GetLocation()), ExprKind.DISCARD, parent, child, isCompilerGenerated: false, null))
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
