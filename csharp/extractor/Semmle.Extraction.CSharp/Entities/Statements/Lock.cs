using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class Lock : Statement<LockStatementSyntax>
    {
        private Lock(Context cx, LockStatementSyntax @lock, IStatementParentEntity parent, int child)
            : base(cx, @lock, StmtKind.LOCK, parent, child) { }

        public static Lock Create(Context cx, LockStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new Lock(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            Expression.Create(Context, Stmt.Expression, this, 0);
            Statement.Create(Context, Stmt.Statement, this, 1);
        }
    }
}
