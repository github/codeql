using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Entities;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class Switch : Expression<SwitchExpressionSyntax>
    {
        private Switch(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.SWITCH))
        {
        }

        public static Expression Create(ExpressionNodeInfo info) => new Switch(info).TryPopulate();

        public Expression SwitchedExpr { get; private set; }

        protected override void Populate()
        {
            SwitchedExpr = Expression.Create(cx, Syntax.GoverningExpression, this, -1);
            int child = 0;
            foreach(var arm in Syntax.Arms)
            {
                new SwitchCase(cx, arm, this, child++);
            }
        }
    }

    class SwitchCase : Expression
    {
        internal SwitchCase(Context cx, SwitchExpressionArmSyntax arm, Switch parent, int child) :
            base(new ExpressionInfo(cx, parent.SwitchedExpr.Type, cx.Create(arm.GetLocation()), ExprKind.SWITCH_CASE, parent, child, false, null))
        {
            cx.CreatePattern(arm.Pattern, this, 0);
            if (arm.WhenClause is WhenClauseSyntax when)
                Expression.Create(cx, when.Condition, this, 1);
            Expression.Create(cx, arm.Expression, this, 2);
        }
    }
}
