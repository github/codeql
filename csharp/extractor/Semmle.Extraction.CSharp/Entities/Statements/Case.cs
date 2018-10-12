using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using Microsoft.CodeAnalysis;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    abstract class Case<TSyntax> : Statement<TSyntax> where TSyntax : SwitchLabelSyntax
    {
        protected Case(Context cx, TSyntax node, Switch parent, int child)
            : base(cx, node, StmtKind.CASE, parent, child, cx.Create(node.GetLocation())) { }

        public static Statement Create(Context cx, SwitchLabelSyntax node, Switch parent, int child)
        {
            switch (node.Kind())
            {
                case SyntaxKind.CaseSwitchLabel:
                    return CaseLabel.Create(cx, (CaseSwitchLabelSyntax)node, parent, child);
                case SyntaxKind.DefaultSwitchLabel:
                    return CaseDefault.Create(cx, (DefaultSwitchLabelSyntax)node, parent, child);
                case SyntaxKind.CasePatternSwitchLabel:
                    return CasePattern.Create(cx, (CasePatternSwitchLabelSyntax)node, parent, child);
                default:
                    throw new InternalError(node, "Unhandled case label");
            }
        }
    }

    class CaseLabel : Case<CaseSwitchLabelSyntax>
    {
        CaseLabel(Context cx, CaseSwitchLabelSyntax node, Switch parent, int child)
            : base(cx, node, parent, child) { }

        protected override void Populate()
        {
            var value = Stmt.Value;
            Expression.Create(cx, value, this, 0);
            Switch.LabelForValue(cx.Model(Stmt).GetConstantValue(value).Value);
        }

        public static CaseLabel Create(Context cx, CaseSwitchLabelSyntax node, Switch parent, int child)
        {
            var ret = new CaseLabel(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }
    }

    class CaseDefault : Case<DefaultSwitchLabelSyntax>
    {
        CaseDefault(Context cx, DefaultSwitchLabelSyntax node, Switch parent, int child)
            : base(cx, node, parent, child) { }

        protected override void Populate() { }

        public static CaseDefault Create(Context cx, DefaultSwitchLabelSyntax node, Switch parent, int child)
        {
            var ret = new CaseDefault(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }
    }

    class CasePattern : Case<CasePatternSwitchLabelSyntax>
    {
        CasePattern(Context cx, CasePatternSwitchLabelSyntax node, Switch parent, int child)
            : base(cx, node, parent, child) { }

        protected override void Populate()
        {
            switch(Stmt.Pattern)
            {
                case DeclarationPatternSyntax declarationPattern:
                    var symbol = cx.Model(Stmt).GetDeclaredSymbol(declarationPattern.Designation) as ILocalSymbol;
                    if (symbol != null)
                    {
                        var type = Type.Create(cx, symbol.Type);
                        var isVar = declarationPattern.Type.IsVar;
                        Expressions.VariableDeclaration.Create(cx, symbol, type, cx.Create(declarationPattern.GetLocation()), cx.Create(declarationPattern.Designation.GetLocation()), isVar, this, 0);
                    }

                    Expressions.TypeAccess.Create(cx, declarationPattern.Type, this, 1);
                    break;
                case ConstantPatternSyntax pattern:
                    Expression.Create(cx, pattern.Expression, this, 0);
                    break;
                default:
                    throw new InternalError(Stmt, "Case pattern not handled");
            }

            if (Stmt.WhenClause != null)
            {
                Expression.Create(cx, Stmt.WhenClause.Condition, this, 2);
            }
        }

        public static CasePattern Create(Context cx, CasePatternSwitchLabelSyntax node, Switch parent, int child)
        {
            var ret = new CasePattern(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }
    }
}
