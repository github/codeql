using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class Tuple : Expression<TupleExpressionSyntax>
    {
        public static Expression Create(ExpressionNodeInfo info) => new Tuple(info).TryPopulate();

        Tuple(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.TUPLE))
        {
        }

        protected override void Populate()
        {
            int child = 0;
            foreach (var argument in Syntax.Arguments.Select(a => a.Expression))
            {
                Expression.Create(cx, argument, this, child++);
            }
        }
    }
}
