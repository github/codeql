using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class Tuple : Expression<TupleExpressionSyntax>
    {
        public static Expression Create(ExpressionNodeInfo info) => new Tuple(info).TryPopulate();

        private Tuple(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.TUPLE))
        {
        }

        protected override void PopulateExpression(TextWriter trapFile)
        {
            PopulateArguments(trapFile, Syntax.Arguments, 0);
        }
    }
}
