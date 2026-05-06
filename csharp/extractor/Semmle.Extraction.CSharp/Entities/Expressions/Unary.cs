using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class Unary : Expression<PrefixUnaryExpressionSyntax>
    {
        private Unary(ExpressionNodeInfo info)
            : base(info)
        {
        }


        public static Expression Create(ExpressionNodeInfo info) => new Unary(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(Context, Syntax.Operand, this, 0);
            AddOperatorCall(trapFile, Syntax);

            if (Kind == ExprKind.PRE_INCR || Kind == ExprKind.PRE_DECR)
            {
                trapFile.mutator_invocation_mode(this, 1);
            }
        }
    }
}
