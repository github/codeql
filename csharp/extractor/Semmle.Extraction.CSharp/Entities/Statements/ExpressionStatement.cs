using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class ExpressionStatement : Statement<ExpressionStatementSyntax>
    {
        private ExpressionStatement(Context cx, ExpressionStatementSyntax node, IStatementParentEntity parent, int child)
            : base(cx, node, Kinds.StmtKind.EXPR, parent, child) { }

        public static ExpressionStatement Create(Context cx, ExpressionStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new ExpressionStatement(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            if (Stmt.Expression != null)
                Expression.Create(cx, Stmt.Expression, this, 0);
            else
                cx.ModelError(Stmt, "Invalid expression statement");
        }
    }
}
