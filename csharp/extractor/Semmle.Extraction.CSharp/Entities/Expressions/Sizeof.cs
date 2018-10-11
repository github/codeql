using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class SizeOf : Expression<SizeOfExpressionSyntax>
    {
        SizeOf(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.SIZEOF)) { }

        public static Expression Create(ExpressionNodeInfo info) => new SizeOf(info).TryPopulate();

        protected override void Populate()
        {
            TypeAccess.Create(cx, Syntax.Type, this, 0);
        }
    }
}
