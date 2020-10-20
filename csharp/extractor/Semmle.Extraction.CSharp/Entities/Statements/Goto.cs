using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using Microsoft.CodeAnalysis.CSharp;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    /// <summary>
    /// A goto, goto case or goto default.
    /// </summary>
    internal class Goto : Statement<GotoStatementSyntax>
    {
        private static StmtKind GetKind(GotoStatementSyntax node)
        {
            switch (node.CaseOrDefaultKeyword.Kind())
            {
                case SyntaxKind.None: return StmtKind.GOTO;
                case SyntaxKind.DefaultKeyword: return StmtKind.GOTO_DEFAULT;
                case SyntaxKind.CaseKeyword: return StmtKind.GOTO_CASE;
                default: throw new InternalError(node, $"Unhandled goto statement kind {node.CaseOrDefaultKeyword.Kind()}");
            }
        }

        private Goto(Context cx, GotoStatementSyntax node, IStatementParentEntity parent, int child)
            : base(cx, node, GetKind(node), parent, child) { }

        public static Goto Create(Context cx, GotoStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new Goto(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            switch (GetKind(Stmt))
            {
                case StmtKind.GOTO:
                    var target = ((IdentifierNameSyntax)Stmt.Expression).Identifier.Text;
                    trapFile.exprorstmt_name(this, target);
                    break;
                case StmtKind.GOTO_CASE:
                    Expr = Expression.Create(cx, Stmt.Expression, this, 0);
                    ConstantValue = Switch.LabelForValue(cx.GetModel(Stmt).GetConstantValue(Stmt.Expression).Value);
                    break;
                case StmtKind.GOTO_DEFAULT:
                    ConstantValue = Switch.DefaultLabel;
                    break;
            }
        }

        public Expression Expr { get; private set; }

        public object ConstantValue { get; private set; }

        public bool IsDefault => ConstantValue == Switch.DefaultLabel;
    }
}
