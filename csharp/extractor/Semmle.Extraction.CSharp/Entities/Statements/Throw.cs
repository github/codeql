using Microsoft.CodeAnalysis.CSharp.Syntax;  // lgtm[cs/similar-file]
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    class Throw : Statement<ThrowStatementSyntax>
    {
        Throw(Context cx, ThrowStatementSyntax node, IStatementParentEntity parent, int child)
            : base(cx, node, StmtKind.THROW, parent, child) { }

        public static Throw Create(Context cx, ThrowStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new Throw(cx, node, parent, child);
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
