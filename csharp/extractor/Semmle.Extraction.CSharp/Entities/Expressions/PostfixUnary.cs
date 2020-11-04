using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class PostfixUnary : Expression<ExpressionSyntax>
    {
        private PostfixUnary(ExpressionNodeInfo info, ExprKind kind, ExpressionSyntax operand)
            : base(info.SetKind(UnaryOperatorKind(info.Context, kind, info.Node)))
        {
            this.operand = operand;
            operatorKind = kind;
        }

        private readonly ExpressionSyntax operand;
        private readonly ExprKind operatorKind;

        public static Expression Create(ExpressionNodeInfo info, ExpressionSyntax operand) => new PostfixUnary(info, info.Kind, operand).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(cx, operand, this, 0);
            OperatorCall(trapFile, Syntax);

            if ((operatorKind == ExprKind.POST_INCR || operatorKind == ExprKind.POST_DECR) &&
                Kind == ExprKind.OPERATOR_INVOCATION)
            {
                trapFile.mutator_invocation_mode(this, 2);
            }
        }
    }
}
