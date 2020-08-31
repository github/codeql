using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    class Labeled : Statement<LabeledStatementSyntax>
    {
        readonly Statement Parent;
        readonly int Child;

        Labeled(Context cx, LabeledStatementSyntax stmt, Statement parent, int child)
            : base(cx, stmt, StmtKind.LABEL, parent, child)
        {
            Parent = parent;
            Child = child;
        }

        public static Labeled Create(Context cx, LabeledStatementSyntax node, Statement parent, int child)
        {
            var ret = new Labeled(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            trapFile.exprorstmt_name(this, Stmt.Identifier.ToString());

            // For compatilibty with the Mono extractor, make insert the labelled statement into the same block
            // as this one. The parent MUST be a block statement.
            labelledStmt = Statement.Create(cx, Stmt.Statement, Parent, Child + 1);
        }

        Statement? labelledStmt;

        public override int NumberOfStatements => 1 + labelledStmt!.NumberOfStatements;
    }
}
