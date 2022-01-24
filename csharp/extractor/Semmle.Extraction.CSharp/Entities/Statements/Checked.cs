using Microsoft.CodeAnalysis.CSharp.Syntax;  // lgtm[cs/similar-file]
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class Checked : Statement<CheckedStatementSyntax>
    {
        private Checked(Context cx, CheckedStatementSyntax stmt, IStatementParentEntity parent, int child)
            : base(cx, stmt, StmtKind.CHECKED, parent, child) { }

        public static Checked Create(Context cx, CheckedStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new Checked(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            Statement.Create(Context, Stmt.Block, this, 0);
        }
    }
}
