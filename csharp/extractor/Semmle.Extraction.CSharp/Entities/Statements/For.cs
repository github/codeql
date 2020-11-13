using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Entities.Expressions;
using Semmle.Extraction.Kinds;
using System.IO;

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

            if (Stmt.Declaration != null)
                VariableDeclarations.Populate(cx, Stmt.Declaration, this, child, childIncrement: -1);

            foreach (var init in Stmt.Initializers)
            {
                Expression.Create(cx, init, this, child--);
            }

            if (Stmt.Condition != null)
            {
                Expression.Create(cx, Stmt.Condition, this, 0);
            }

            child = 1;
            foreach (var inc in Stmt.Incrementors)
            {
                Expression.Create(cx, inc, this, child++);
            }

            Statement.Create(cx, Stmt.Statement, this, 1 + Stmt.Incrementors.Count);
        }
    }
}
