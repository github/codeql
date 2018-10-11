using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class Unary : Expression<PrefixUnaryExpressionSyntax>
    {
        Unary(ExpressionNodeInfo info, ExprKind kind)
            : base(info.SetKind(UnaryOperatorKind(info.Context, info.Kind, info.Node)))
        {
            OperatorKind = kind;
        }

        readonly ExprKind OperatorKind;

        public static Unary Create(ExpressionNodeInfo info)
        {
            var ret = new Unary(info, info.Kind);
            ret.TryPopulate();
            return ret;
        }

        protected override void Populate()
        {
            Create(cx, Syntax.Operand, this, 0);
            OperatorCall(Syntax);

            if ((OperatorKind == ExprKind.PRE_INCR || OperatorKind == ExprKind.PRE_DECR) &&
                Kind == ExprKind.OPERATOR_INVOCATION)
            {
                cx.Emit(Tuples.mutator_invocation_mode(this, 1));
            }
        }
    }
}
