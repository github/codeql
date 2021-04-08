using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class RangeExpression : Expression<RangeExpressionSyntax>
    {
        private RangeExpression(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.RANGE))
        {
        }

        protected override void PopulateExpression(TextWriter trapFile)
        {
            if (!(Syntax.LeftOperand is null))
                Expression.Create(Context, Syntax.LeftOperand, this, 0);
            if (!(Syntax.RightOperand is null))
                Expression.Create(Context, Syntax.RightOperand, this, 1);
        }

        public static Expression Create(ExpressionNodeInfo info) => new RangeExpression(info).TryPopulate();
    }
}
