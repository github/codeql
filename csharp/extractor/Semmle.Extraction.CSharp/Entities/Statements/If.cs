using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class If : Statement<IfStatementSyntax>
    {
        private If(Context cx, IfStatementSyntax node, IStatementParentEntity parent, int child)
            : base(cx, node, StmtKind.IF, parent, child) { }

        public static If Create(Context cx, IfStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new If(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            Expression.Create(cx, Stmt.Condition, this, 0);

            Create(cx, Stmt.Statement, this, 1);

            if (Stmt.Else != null)
                Create(cx, Stmt.Else.Statement, this, 2);
        }
    }
}
