using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal static class CompoundAssignment
    {
        public static Expression Create(ExpressionNodeInfo info)
        {
            if (info.SymbolInfo.Symbol is IMethodSymbol op &&
                op.MethodKind == MethodKind.UserDefinedOperator &&
                !op.IsStatic)
            {
                // This is a user-defined instance operator such as `a += b` where `a` is of a type that defines an `operator +=`.
                // In this case, we want to extract the operator call rather than desugar it into `a = a + b`.
                return UserCompoundAssignmentInvocation.Create(info);
            }
            return Assignment.Create(info);
        }
    }
}
