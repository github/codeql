using Microsoft.CodeAnalysis.CSharp.Syntax; // lgtm[cs/similar-file]
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class Await : Expression<AwaitExpressionSyntax>
    {
        Await(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.AWAIT)) { }

        public static Expression Create(ExpressionNodeInfo info) => new Await(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(Cx, Syntax.Expression, this, 0);
        }
    }
}
