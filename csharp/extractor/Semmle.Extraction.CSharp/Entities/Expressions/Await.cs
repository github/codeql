using Microsoft.CodeAnalysis.CSharp.Syntax; // lgtm[cs/similar-file]
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class Await : Expression<AwaitExpressionSyntax>
    {
        private Await(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.AWAIT)) { }

        public static Expression Create(ExpressionNodeInfo info) => new Await(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(cx, Syntax.Expression, this, 0);
        }
    }
}
