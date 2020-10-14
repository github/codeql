using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Entities.Expressions;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class Using : Statement<UsingStatementSyntax>
    {
        private Using(Context cx, UsingStatementSyntax node, IStatementParentEntity parent, int child)
            : base(cx, node, StmtKind.USING, parent, child) { }

        public static Using Create(Context cx, UsingStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new Using(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            if (Stmt.Declaration != null)
                VariableDeclarations.Populate(cx, Stmt.Declaration, this, -1, childIncrement: -1);

            if (Stmt.Expression != null)
                Expression.Create(cx, Stmt.Expression, this, 0);

            if (Stmt.Statement != null)
                Statement.Create(cx, Stmt.Statement, this, 1);
        }
    }
}
