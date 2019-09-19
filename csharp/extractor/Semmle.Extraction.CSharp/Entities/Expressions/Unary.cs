using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using System.IO;

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

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(cx, Syntax.Operand, this, 0);
            OperatorCall(trapFile, Syntax);

            if ((OperatorKind == ExprKind.PRE_INCR || OperatorKind == ExprKind.PRE_DECR) &&
                Kind == ExprKind.OPERATOR_INVOCATION)
            {
                trapFile.mutator_invocation_mode(this, 1);
            }
        }
    }
}
