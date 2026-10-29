using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class While : Statement<WhileStatementSyntax>
    {
        private While(Context cx, WhileStatementSyntax node, IStatementParentEntity parent, int child)
            : base(cx, node, StmtKind.WHILE, parent, child) { }

        public static While Create(Context cx, WhileStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new While(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            Expression.Create(Context, Stmt.Condition, this, 0);
            Create(Context, Stmt.Statement, this, 1);
        }
    }
}
