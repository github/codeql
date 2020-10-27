using Microsoft.CodeAnalysis.CSharp.Syntax; // lgtm[cs/similar-file]
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class Checked : Expression<CheckedExpressionSyntax>
    {
        private Checked(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.CHECKED)) { }

        public static Expression Create(ExpressionNodeInfo info) => new Checked(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(cx, Syntax.Expression, this, 0);
        }
    }
}
