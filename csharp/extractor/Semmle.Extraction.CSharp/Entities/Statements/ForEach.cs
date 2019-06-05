using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    class ForEach : Statement<ForEachStatementSyntax>
    {
        ForEach(Context cx, ForEachStatementSyntax stmt, IStatementParentEntity parent, int child)
            : base(cx, stmt, StmtKind.FOREACH, parent, child) { }

        public static ForEach Create(Context cx, ForEachStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new ForEach(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void Populate()
        {
            Expression.Create(cx, Stmt.Expression, this, 1);

            var typeSymbol = cx.Model(Stmt).GetDeclaredSymbol(Stmt);
            var type = Type.Create(cx, typeSymbol.GetAnnotatedType());

            var location = cx.Create(Stmt.Identifier.GetLocation());

            if (typeSymbol.Name != "_")
                Expressions.VariableDeclaration.Create(cx, typeSymbol, type, Stmt.Type, location, location, Stmt.Type.IsVar, this, 0);
            else
                TypeMention.Create(cx, Stmt.Type, this, type.Type);

            Statement.Create(cx, Stmt.Statement, this, 2);
        }
    }

    class ForEachVariable : Statement<ForEachVariableStatementSyntax>
    {
        ForEachVariable(Context cx, ForEachVariableStatementSyntax stmt, IStatementParentEntity parent, int child)
            : base(cx, stmt, StmtKind.FOREACH, parent, child) { }

        public static ForEachVariable Create(Context cx, ForEachVariableStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new ForEachVariable(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void Populate()
        {
            Expression.Create(cx, Stmt.Variable, this, 0);
            Expression.Create(cx, Stmt.Expression, this, 1);
            Statement.Create(cx, Stmt.Statement, this, 2);
        }
    }
}
