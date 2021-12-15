using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class PointerMemberAccess : Expression<MemberAccessExpressionSyntax>
    {
        private PointerMemberAccess(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.POINTER_INDIRECTION)) { }

        public static Expression Create(ExpressionNodeInfo info) => new PointerMemberAccess(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(Context, Syntax.Expression, this, 0);

            // !! We do not currently look at the member (or store the member name).
        }
    }
}
