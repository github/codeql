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
            if (Stmt.Declaration is not null)
                VariableDeclarations.Populate(Context, Stmt.Declaration, this, -1, childIncrement: -1);

            if (Stmt.Expression is not null)
                Expression.Create(Context, Stmt.Expression, this, 0);

            if (Stmt.Statement is not null)
                Statement.Create(Context, Stmt.Statement, this, 1);
        }
    }
}
