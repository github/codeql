using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class PostfixUnary : Expression<ExpressionSyntax>
    {
        PostfixUnary(ExpressionNodeInfo info, ExprKind kind, ExpressionSyntax operand)
            : base(info.SetKind(UnaryOperatorKind(info.Context, kind, info.Node)))
        {
            Operand = operand;
            OperatorKind = kind;
        }

        readonly ExpressionSyntax Operand;
        readonly ExprKind OperatorKind;

        public static Expression Create(ExpressionNodeInfo info, ExpressionSyntax operand) => new PostfixUnary(info, info.Kind, operand).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(cx, Operand, this, 0);
            OperatorCall(trapFile, Syntax);

            if ((OperatorKind == ExprKind.POST_INCR || OperatorKind == ExprKind.POST_DECR) &&
                Kind == ExprKind.OPERATOR_INVOCATION)
            {
                trapFile.Emit(Tuples.mutator_invocation_mode(this, 2));
            }
        }
    }
}
