using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class WithExpression : Expression<WithExpressionSyntax>
    {
        private WithExpression(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.WITH)) { }

        public static Expression Create(ExpressionNodeInfo info) => new WithExpression(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(cx, Syntax.Expression, this, 0);

            ObjectInitializer.Create(new ExpressionNodeInfo(cx, Syntax.Initializer, this, 1).SetType(Type));
        }
    }
}
