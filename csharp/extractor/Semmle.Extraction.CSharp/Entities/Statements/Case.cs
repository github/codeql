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
            : base(cx, node, StmtKind.CASE, parent, child, cx.CreateLocation(node.GetLocation())) { }

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
                    throw new InternalError(node, $"Unhandled case label of kind {node.Kind()}");
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
            Expression.Create(Context, value, this, 0);
            Switch.LabelForValue(Context.GetModel(Stmt).GetConstantValue(value).Value);
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

        protected override void PopulateStatement(TextWriter trapFile)
        {
            Expressions.Pattern.Create(Context, Stmt.Pattern, this, 0);

            if (Stmt.WhenClause is not null)
            {
                Expression.Create(Context, Stmt.WhenClause.Condition, this, 1);
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
