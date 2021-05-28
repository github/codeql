using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class Labeled : Statement<LabeledStatementSyntax>
    {
        private readonly IStatementParentEntity parent;
        private readonly int child;
        private Statement? labelledStmt;

        private Labeled(Context cx, LabeledStatementSyntax stmt, IStatementParentEntity parent, int child)
            : base(cx, stmt, StmtKind.LABEL, parent, child)
        {
            this.parent = parent;
            this.child = child;
        }

        public static Labeled Create(Context cx, LabeledStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new Labeled(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            trapFile.exprorstmt_name(this, Stmt.Identifier.ToString());

            // For compatibility with the Mono extractor, make insert the labelled statement into the same block
            // as this one. The parent MUST be a block statement.
            labelledStmt = Statement.Create(Context, Stmt.Statement, parent, child + 1);
        }

        public override int NumberOfStatements => 1 + labelledStmt?.NumberOfStatements ?? 0;
    }
}
