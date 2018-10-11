using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    class Continue : Statement<ContinueStatementSyntax>
    {
        Continue(Context cx, ContinueStatementSyntax stmt, IStatementParentEntity parent, int child)
            : base(cx, stmt, StmtKind.CONTINUE, parent, child) { }

        public static Continue Create(Context cx, ContinueStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new Continue(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void Populate() { }
    }
}

