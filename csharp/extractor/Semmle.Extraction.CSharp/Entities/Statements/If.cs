using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

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
            Expression.Create(Context, Stmt.Condition, this, 0);

            Create(Context, Stmt.Statement, this, 1);

            if (Stmt.Else is not null)
                Create(Context, Stmt.Else.Statement, this, 2);
        }
    }
}
