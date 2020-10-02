using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Entities;

namespace Semmle.Extraction.CSharp.Populators
{
    internal class Ast : CSharpSyntaxVisitor
    {
        private readonly Context cx;
        private readonly IExpressionParentEntity parent;
        private readonly int child;

        public Ast(Context cx, IExpressionParentEntity parent, int child)
        {
            this.cx = cx;
            this.parent = parent;
            this.child = child;
        }

        public override void DefaultVisit(SyntaxNode node)
        {
            cx.ModelError(node, $"Unhandled syntax node {node.Kind()}");
        }

        public override void VisitArgumentList(ArgumentListSyntax node)
        {
            var c = 0;
            foreach (var m in node.Arguments)
            {
                cx.Extract(m, parent, c++);
            }
        }

        public override void VisitArgument(ArgumentSyntax node)
        {
            Expression.Create(cx, node.Expression, parent, child);
        }
    }

    public static class AstExtensions
    {
        public static void Extract(this Context cx, CSharpSyntaxNode node, IExpressionParentEntity parent, int child)
        {
            using (cx.StackGuard)
            {
                try
                {
                    node.Accept(new Ast(cx, parent, child));
                }
                catch (System.Exception ex)  // lgtm[cs/catch-of-all-exceptions]
                {
                    cx.ModelError(node, $"Exception processing syntax node of type {node.Kind()}: {ex.Message}");
                }
            }
        }

        public static void Extract(this Context cx, SyntaxNode node, IEntity parent, int child)
        {
            cx.Extract(((CSharpSyntaxNode)node), parent, child);
        }
    }
}
