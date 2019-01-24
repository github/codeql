using Microsoft.CodeAnalysis.CSharp.Syntax;  // lgtm[cs/similar-file]
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    class Unchecked : Statement<CheckedStatementSyntax>
    {
        Unchecked(Context cx, CheckedStatementSyntax stmt, IStatementParentEntity parent, int child)
            : base(cx, stmt, StmtKind.UNCHECKED, parent, child) { }

        public static Unchecked Create(Context cx, CheckedStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new Unchecked(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void Populate()
        {
            Statement.Create(cx, Stmt.Block, this, 0);
        }
    }
}
