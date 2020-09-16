using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    class Yield : Statement<YieldStatementSyntax>
    {
        Yield(Context cx, YieldStatementSyntax node, IStatementParentEntity parent, int child)
            : base(cx, node, StmtKind.YIELD, parent, child) { }

        public static Yield Create(Context cx, YieldStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new Yield(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            if (Stmt.Expression != null)
            {
                Expression.Create(Cx, Stmt.Expression, this, 0);
            }
        }
    }
}
