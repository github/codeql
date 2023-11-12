using System.IO; // lgtm[cs/similar-file]
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class Return : Statement<ReturnStatementSyntax>
    {
        private Return(Context cx, ReturnStatementSyntax node, IStatementParentEntity parent, int child)
            : base(cx, node, StmtKind.RETURN, parent, child) { }

        public static Return Create(Context cx, ReturnStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new Return(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            if (Stmt.Expression is not null)
                Expression.Create(Context, Stmt.Expression, this, 0);
        }
    }
}
