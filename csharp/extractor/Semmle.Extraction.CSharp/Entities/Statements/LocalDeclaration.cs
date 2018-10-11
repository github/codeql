using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Entities.Expressions;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    class LocalDeclaration : Statement<LocalDeclarationStatementSyntax>
    {
        LocalDeclaration(Context cx, LocalDeclarationStatementSyntax declStmt, IStatementParentEntity parent, int child)
            : base(cx, declStmt, declStmt.IsConst ? StmtKind.CONST_DECL : StmtKind.VAR_DECL, parent, child) { }

        public static LocalDeclaration Create(Context cx, LocalDeclarationStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new LocalDeclaration(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void Populate()
        {
            VariableDeclarations.Populate(cx, Stmt.Declaration, this, 0);
            cx.BindComments(this, Stmt.GetLocation());
        }
    }
}
