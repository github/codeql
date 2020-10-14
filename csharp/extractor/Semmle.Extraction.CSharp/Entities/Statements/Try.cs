using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using Microsoft.CodeAnalysis;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class Try : Statement<TryStatementSyntax>
    {
        private Try(Context cx, TryStatementSyntax node, IStatementParentEntity parent, int child)
            : base(cx, node, StmtKind.TRY, parent, child) { }

        public static Try Create(Context cx, TryStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new Try(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            var child = 1;
            foreach (var c in Stmt.Catches)
            {
                Catch.Create(cx, c, this, child++);
            }

            Create(cx, Stmt.Block, this, 0);

            if (Stmt.Finally != null)
            {
                Create(cx, Stmt.Finally.Block, this, -1);
            }
        }

        public static SyntaxNodeOrToken NextNode(SyntaxNode node)
        {
            for (var i = node.Parent.ChildNodesAndTokens().GetEnumerator(); i.MoveNext();)
            {
                if (i.Current == node)
                {
                    return i.MoveNext() ? i.Current : null;
                }
            }
            return null;
        }
    }
}
