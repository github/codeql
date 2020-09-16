using Semmle.Extraction.Kinds;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class RefValue : Expression<RefValueExpressionSyntax>
    {
        RefValue(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.REF)) { }

        public static Expression Create(ExpressionNodeInfo info) => new RefValue(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(Cx, Syntax.Expression, this, 0);
            Create(Cx, Syntax.Type, this, 1);   // A type-access
        }
    }
}
