using Microsoft.CodeAnalysis.CSharp.Syntax; // lgtm[cs/similar-file]
using Semmle.Extraction.CSharp.Entities.Expressions;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    class Fixed : Statement<FixedStatementSyntax>
    {
        Fixed(Context cx, FixedStatementSyntax @fixed, IStatementParentEntity parent, int child)
            : base(cx, @fixed, StmtKind.FIXED, parent, child) { }

        public static Fixed Create(Context cx, FixedStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new Fixed(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            VariableDeclarations.Populate(Cx, Stmt.Declaration, this, -1, childIncrement: -1);
            Create(Cx, Stmt.Statement, this, 0);
        }
    }
}
