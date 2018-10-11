using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    class Return : Statement<ReturnStatementSyntax>
    {
        Return(Context cx, ReturnStatementSyntax node, IStatementParentEntity parent, int child)
            : base(cx, node, StmtKind.RETURN, parent, child) { }

        public static Return Create(Context cx, ReturnStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new Return(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void Populate()
        {
            if (Stmt.Expression != null)
                Expression.Create(cx, Stmt.Expression, this, 0);
        }
    }
}
