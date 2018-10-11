using Semmle.Extraction.Kinds;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class RefType : Expression<RefTypeExpressionSyntax>
    {
        RefType(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.UNKNOWN)) { }

        public static Expression Create(ExpressionNodeInfo info) => new RefType(info).TryPopulate();

        protected override void Populate()
        {
            Create(cx, Syntax.Expression, this, 0);
        }
    }
}
