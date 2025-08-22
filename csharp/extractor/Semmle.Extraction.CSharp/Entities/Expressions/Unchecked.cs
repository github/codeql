using System.IO; // lgtm[cs/similar-file]
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class Unchecked : Expression<CheckedExpressionSyntax>
    {
        private Unchecked(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.UNCHECKED)) { }

        public static Expression Create(ExpressionNodeInfo info) => new Unchecked(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(Context, Syntax.Expression, this, 0);
        }
    }
}
