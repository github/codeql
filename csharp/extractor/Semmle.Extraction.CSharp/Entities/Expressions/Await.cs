using System.IO; // lgtm[cs/similar-file]
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class Await : Expression<AwaitExpressionSyntax>
    {
        private Await(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.AWAIT)) { }

        public static Expression Create(ExpressionNodeInfo info) => new Await(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(Context, Syntax.Expression, this, 0);
        }
    }
}
