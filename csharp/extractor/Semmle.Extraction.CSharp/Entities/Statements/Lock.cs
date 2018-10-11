using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    class Lock : Statement<LockStatementSyntax>
    {
        Lock(Context cx, LockStatementSyntax @lock, IStatementParentEntity parent, int child)
            : base(cx, @lock, StmtKind.LOCK, parent, child) { }

        public static Lock Create(Context cx, LockStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new Lock(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void Populate()
        {
            Expression.Create(cx, Stmt.Expression, this, 0);
            Statement.Create(cx, Stmt.Statement, this, 1);
        }
    }
}
