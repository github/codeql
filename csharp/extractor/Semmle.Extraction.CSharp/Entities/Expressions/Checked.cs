using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class Checked : Expression<CheckedExpressionSyntax>
    {
        Checked(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.CHECKED)) { }

        public static Expression Create(ExpressionNodeInfo info) => new Checked(info).TryPopulate();

        protected override void Populate()
        {
            Create(cx, Syntax.Expression, this, 0);
        }
    }
}
