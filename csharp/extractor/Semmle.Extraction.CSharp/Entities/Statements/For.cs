using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Entities.Expressions;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class For : Statement<ForStatementSyntax>
    {
        private For(Context cx, ForStatementSyntax node, IStatementParentEntity parent, int child)
            : base(cx, node, StmtKind.FOR, parent, child) { }

        public static For Create(Context cx, ForStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new For(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            var child = -1;

            if (Stmt.Declaration is not null)
                VariableDeclarations.Populate(Context, Stmt.Declaration, this, child, childIncrement: -1);

            foreach (var init in Stmt.Initializers)
            {
                Expression.Create(Context, init, this, child--);
            }

            if (Stmt.Condition is not null)
            {
                Expression.Create(Context, Stmt.Condition, this, 0);
            }

            child = 1;
            foreach (var inc in Stmt.Incrementors)
            {
                Expression.Create(Context, inc, this, child++);
            }

            Statement.Create(Context, Stmt.Statement, this, 1 + Stmt.Incrementors.Count);
        }
    }
}
