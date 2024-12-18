using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class Switch : Expression<SwitchExpressionSyntax>
    {
        private Switch(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.SWITCH))
        {
        }

        public static Expression Create(ExpressionNodeInfo info) => new Switch(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Expression.Create(Context, Syntax.GoverningExpression, this, -1);
            for (var i = 0; i < Syntax.Arms.Count; i++)
            {
                new SwitchCase(Context, Syntax.Arms[i], this, i);
            }
        }
    }

    internal class SwitchCase : Expression
    {
        internal SwitchCase(Context cx, SwitchExpressionArmSyntax arm, Switch parent, int child) :
            base(new ExpressionInfo(
                cx, cx.GetType(arm.Expression), cx.CreateLocation(arm.GetLocation()),
                ExprKind.SWITCH_CASE, parent, child, isCompilerGenerated: false, null))
        {
            Expressions.Pattern.Create(cx, arm.Pattern, this, 0);
            if (arm.WhenClause is WhenClauseSyntax when)
                Expression.Create(cx, when.Condition, this, 1);
            Expression.Create(cx, arm.Expression, this, 2);
        }
    }
}
