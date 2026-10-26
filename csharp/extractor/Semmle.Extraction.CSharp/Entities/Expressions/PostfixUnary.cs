using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class PostfixUnary : Expression<PostfixUnaryExpressionSyntax>
    {
        private PostfixUnary(ExpressionNodeInfo info, ExprKind kind)
            : base(info.SetKind(UnaryOperatorKind(info.Context, kind, info.Node)))
        {
            operatorKind = kind;
        }

        private readonly ExprKind operatorKind;

        public static Expression Create(ExpressionNodeInfo info) => new PostfixUnary(info, info.Kind).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(Context, Syntax.Operand, this, 0);

            if (Kind == ExprKind.OPERATOR_INVOCATION)
            {
                AddOperatorCall(trapFile, Syntax);

                if (operatorKind == ExprKind.POST_INCR || operatorKind == ExprKind.POST_DECR)
                {
                    trapFile.mutator_invocation_mode(this, 2);
                }
            }
        }
    }
}
