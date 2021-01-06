using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Entities;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class Switch : Expression<SwitchExpressionSyntax>
    {
        private Switch(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.SWITCH))
        {
        }

        public static Expression Create(ExpressionNodeInfo info) => new Switch(info).TryPopulate();

        public Expression SwitchedExpr { get; private set; }

        protected override void PopulateExpression(TextWriter trapFile)
        {
            SwitchedExpr = Expression.Create(cx, Syntax.GoverningExpression, this, -1);
            for (var i = 0; i < Syntax.Arms.Count; i++)
            {
                new SwitchCase(cx, Syntax.Arms[i], this, i);
            }
        }
    }

    internal class SwitchCase : Expression
    {
        internal SwitchCase(Context cx, SwitchExpressionArmSyntax arm, Switch parent, int child) :
            base(new ExpressionInfo(
                cx, Entities.Type.Create(cx, cx.GetType(arm.Expression)), cx.Create(arm.GetLocation()),
                ExprKind.SWITCH_CASE, parent, child, false, null))
        {
            Expressions.Pattern.Create(cx, arm.Pattern, this, 0);
            if (arm.WhenClause is WhenClauseSyntax when)
                Expression.Create(cx, when.Condition, this, 1);
            Expression.Create(cx, arm.Expression, this, 2);
        }
    }
}
