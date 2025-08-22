using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class Unsafe : Statement<UnsafeStatementSyntax>
    {
        private Unsafe(Context cx, UnsafeStatementSyntax node, IStatementParentEntity parent, int child)
            : base(cx, node, StmtKind.UNSAFE, parent, child) { }

        public static Unsafe Create(Context cx, UnsafeStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new Unsafe(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            Create(Context, Stmt.Block, this, 0);
        }
    }
}
