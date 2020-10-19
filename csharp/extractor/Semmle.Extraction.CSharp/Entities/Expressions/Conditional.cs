using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class Conditional : Expression<ConditionalExpressionSyntax>
    {
        private Conditional(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.CONDITIONAL)) { }

        public static Expression Create(ExpressionNodeInfo info) => new Conditional(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(cx, Syntax.Condition, this, 0);
            Create(cx, Syntax.WhenTrue, this, 1);
            Create(cx, Syntax.WhenFalse, this, 2);
        }
    }
}
