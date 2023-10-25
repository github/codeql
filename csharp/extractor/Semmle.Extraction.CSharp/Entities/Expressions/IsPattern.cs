using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class IsPattern : Expression<IsPatternExpressionSyntax>
    {
        private IsPattern(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.IS))
        {
        }

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(Context, Syntax.Expression, this, 0);
            Expressions.Pattern.Create(Context, Syntax.Pattern, this, 1);
        }

        public static Expression Create(ExpressionNodeInfo info) => new IsPattern(info).TryPopulate();
    }
}
