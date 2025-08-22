using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class Try : Statement<TryStatementSyntax>
    {
        private Try(Context cx, TryStatementSyntax node, IStatementParentEntity parent, int child)
            : base(cx, node, StmtKind.TRY, parent, child) { }

        public static Try Create(Context cx, TryStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new Try(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            var child = 1;
            foreach (var c in Stmt.Catches)
            {
                Catch.Create(Context, c, this, child++);
            }

            Create(Context, Stmt.Block, this, 0);

            if (Stmt.Finally is not null)
            {
                Create(Context, Stmt.Finally.Block, this, -1);
            }
        }
    }
}
