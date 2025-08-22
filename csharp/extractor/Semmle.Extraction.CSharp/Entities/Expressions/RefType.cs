using System.IO; // lgtm[cs/similar-file]
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class RefType : Expression<RefTypeExpressionSyntax>
    {
        private RefType(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.UNKNOWN)) { }

        public static Expression Create(ExpressionNodeInfo info) => new RefType(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(Context, Syntax.Expression, this, 0);
        }
    }
}
