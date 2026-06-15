using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Entities.Expressions;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class LocalDeclaration : Statement<LocalDeclarationStatementSyntax>
    {
        private static StmtKind GetKind(LocalDeclarationStatementSyntax declStmt)
        {
            if (declStmt.UsingKeyword.RawKind != 0)
                return StmtKind.USING_DECL;

            if (declStmt.IsConst)
                return StmtKind.CONST_DECL;

            return StmtKind.VAR_DECL;
        }

        private LocalDeclaration(Context cx, LocalDeclarationStatementSyntax declStmt, IStatementParentEntity parent, int child)
            : base(cx, declStmt, GetKind(declStmt), parent, child) { }

        public static LocalDeclaration Create(Context cx, LocalDeclarationStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new LocalDeclaration(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            VariableDeclarations.Populate(Context, Stmt.Declaration, this, 0);
            Context.BindComments(this, Stmt.GetLocation());
        }
    }
}
