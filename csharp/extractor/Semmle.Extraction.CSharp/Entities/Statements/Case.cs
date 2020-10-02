using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using Microsoft.CodeAnalysis;
using Semmle.Extraction.Entities;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal abstract class Case<TSyntax> : Statement<TSyntax> where TSyntax : SwitchLabelSyntax
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

    internal class CaseLabel : Case<CaseSwitchLabelSyntax>
    {
        private CaseLabel(Context cx, CaseSwitchLabelSyntax node, Switch parent, int child)
            : base(cx, node, parent, child) { }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            var value = Stmt.Value;
            Expression.Create(cx, value, this, 0);
            Switch.LabelForValue(cx.GetModel(Stmt).GetConstantValue(value).Value);
        }

        public static CaseLabel Create(Context cx, CaseSwitchLabelSyntax node, Switch parent, int child)
        {
            var ret = new CaseLabel(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }
    }

    internal class CaseDefault : Case<DefaultSwitchLabelSyntax>
    {
        private CaseDefault(Context cx, DefaultSwitchLabelSyntax node, Switch parent, int child)
            : base(cx, node, parent, child) { }

        protected override void PopulateStatement(TextWriter trapFile) { }

        public static CaseDefault Create(Context cx, DefaultSwitchLabelSyntax node, Switch parent, int child)
        {
            var ret = new CaseDefault(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }
    }

    internal class CasePattern : Case<CasePatternSwitchLabelSyntax>
    {
        private CasePattern(Context cx, CasePatternSwitchLabelSyntax node, Switch parent, int child)
            : base(cx, node, parent, child) { }

        private void PopulatePattern(PatternSyntax pattern, TypeSyntax optionalType, VariableDesignationSyntax designation)
        {
            var isVar = optionalType is null;
            switch (designation)
            {
                case SingleVariableDesignationSyntax _:
                    if (cx.GetModel(pattern).GetDeclaredSymbol(designation) is ILocalSymbol symbol)
                    {
                        var type = Type.Create(cx, symbol.GetAnnotatedType());
                        Expressions.VariableDeclaration.Create(cx, symbol, type, optionalType, cx.Create(pattern.GetLocation()), isVar, this, 0);
                    }
                    break;
                case DiscardDesignationSyntax discard:
                    if (isVar)
                        new Expressions.Discard(cx, discard, this, 0);
                    else
                        Expressions.TypeAccess.Create(cx, optionalType, this, 0);
                    break;
                case null:
                    break;
                case ParenthesizedVariableDesignationSyntax paren:
                    Expressions.VariableDeclaration.CreateParenthesized(cx, (VarPatternSyntax)pattern, paren, this, 0);
                    break;
                default:
                    throw new InternalError(pattern, "Unhandled designation in case statement");
            }
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            switch (Stmt.Pattern)
            {
                case VarPatternSyntax varPattern:
                    PopulatePattern(varPattern, null, varPattern.Designation);
                    break;
                case DeclarationPatternSyntax declarationPattern:
                    PopulatePattern(declarationPattern, declarationPattern.Type, declarationPattern.Designation);
                    break;
                case ConstantPatternSyntax pattern:
                    Expression.Create(cx, pattern.Expression, this, 0);
                    break;
                case RecursivePatternSyntax recPattern:
                    new Expressions.RecursivePattern(cx, recPattern, this, 0);
                    break;
                default:
                    throw new InternalError(Stmt, "Case pattern not handled");
            }

            if (Stmt.WhenClause != null)
            {
                Expression.Create(cx, Stmt.WhenClause.Condition, this, 1);
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
