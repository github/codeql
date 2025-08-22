using System.IO; // lgtm[cs/similar-file]
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class Checked : Expression<CheckedExpressionSyntax>
    {
        private Checked(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.CHECKED)) { }

        public static Expression Create(ExpressionNodeInfo info) => new Checked(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(Context, Syntax.Expression, this, 0);
        }
    }
}
