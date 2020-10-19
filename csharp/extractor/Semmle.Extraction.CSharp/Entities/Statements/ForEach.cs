using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Extraction.Entities;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class ForEach : Statement<ForEachStatementSyntax>
    {
        private ForEach(Context cx, ForEachStatementSyntax stmt, IStatementParentEntity parent, int child)
            : base(cx, stmt, StmtKind.FOREACH, parent, child) { }

        public static ForEach Create(Context cx, ForEachStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new ForEach(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter _)
        {
            Expression.Create(cx, Stmt.Expression, this, 1);

            var typeSymbol = cx.GetModel(Stmt).GetDeclaredSymbol(Stmt);
            var type = Type.Create(cx, typeSymbol.GetAnnotatedType());

            var location = cx.Create(Stmt.Identifier.GetLocation());

            Expressions.VariableDeclaration.Create(cx, typeSymbol, type, Stmt.Type, location, Stmt.Type.IsVar, this, 0);

            Statement.Create(cx, Stmt.Statement, this, 2);
        }
    }

    internal class ForEachVariable : Statement<ForEachVariableStatementSyntax>
    {
        private ForEachVariable(Context cx, ForEachVariableStatementSyntax stmt, IStatementParentEntity parent, int child)
            : base(cx, stmt, StmtKind.FOREACH, parent, child) { }

        public static ForEachVariable Create(Context cx, ForEachVariableStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new ForEachVariable(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            Expression.Create(cx, Stmt.Variable, this, 0);
            Expression.Create(cx, Stmt.Expression, this, 1);
            Statement.Create(cx, Stmt.Statement, this, 2);
        }
    }
}
