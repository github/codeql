using Semmle.Extraction.Kinds;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class RefValue : Expression<RefValueExpressionSyntax>
    {
        private RefValue(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.REF)) { }

        public static Expression Create(ExpressionNodeInfo info) => new RefValue(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(Context, Syntax.Expression, this, 0);
            Create(Context, Syntax.Type, this, 1);   // A type-access
        }
    }
}
