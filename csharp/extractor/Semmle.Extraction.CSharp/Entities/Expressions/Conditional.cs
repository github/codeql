using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class Conditional : Expression<ConditionalExpressionSyntax>
    {
        Conditional(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.CONDITIONAL)) { }

        public static Expression Create(ExpressionNodeInfo info) => new Conditional(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(Cx, Syntax.Condition, this, 0);
            Create(Cx, Syntax.WhenTrue, this, 1);
            Create(Cx, Syntax.WhenFalse, this, 2);
        }
    }
}
