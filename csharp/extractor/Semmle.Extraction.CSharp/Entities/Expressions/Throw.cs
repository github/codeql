using Microsoft.CodeAnalysis.CSharp.Syntax; // lgtm[cs/similar-file]
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class Throw : Expression<ThrowExpressionSyntax>
    {
        private Throw(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.THROW)) { }

        public static Expression Create(ExpressionNodeInfo info) => new Throw(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(Context, Syntax.Expression, this, 0);
        }
    }
}
