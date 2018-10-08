using Semmle.Extraction.Kinds;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class RefValue : Expression<RefValueExpressionSyntax>
    {
        RefValue(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.REF)) { }

        public static Expression Create(ExpressionNodeInfo info) => new RefValue(info).TryPopulate();

        protected override void Populate()
        {
            Create(cx, Syntax.Expression, this, 0);
            Create(cx, Syntax.Type, this, 1);   // A type-access
        }
    }
}
