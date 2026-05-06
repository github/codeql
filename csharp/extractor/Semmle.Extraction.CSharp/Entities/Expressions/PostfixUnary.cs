using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class PostfixUnary : Expression<PostfixUnaryExpressionSyntax>
    {
        private PostfixUnary(ExpressionNodeInfo info)
            : base(info)
        {
        }

        public static Expression Create(ExpressionNodeInfo info) => new PostfixUnary(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(Context, Syntax.Operand, this, 0);
            AddOperatorCall(trapFile, Syntax);

            if (Kind == ExprKind.POST_INCR || Kind == ExprKind.POST_DECR)
            {
                trapFile.mutator_invocation_mode(this, 2);
            }
        }
    }
}
