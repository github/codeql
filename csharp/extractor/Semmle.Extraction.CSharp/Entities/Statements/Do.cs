using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Entities;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class Do : Statement<DoStatementSyntax>
    {
        private Do(Context cx, DoStatementSyntax node, IStatementParentEntity parent, int child)
            : base(cx, node, StmtKind.DO, parent, child, cx.Create(node.GetLocation())) { }

        public static Do Create(Context cx, DoStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new Do(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            Create(cx, Stmt.Statement, this, 1);
            Expression.Create(cx, Stmt.Condition, this, 0);
        }
    }
}
