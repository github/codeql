using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class Break : Statement<BreakStatementSyntax>
    {
        private Break(Context cx, BreakStatementSyntax node, IStatementParentEntity parent, int child)
            : base(cx, node, StmtKind.BREAK, parent, child) { }

        public static Break Create(Context cx, BreakStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new Break(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile) { }
    }
}
