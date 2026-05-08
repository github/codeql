using Microsoft.CodeAnalysis;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal static class Not
    {
        public static Expression Create(ExpressionNodeInfo info)
        {
            var cx = info.Context;
            if (cx.GetSymbolInfo(info.Node).Symbol is IMethodSymbol @operator &&
               @operator.MethodKind == MethodKind.BuiltinOperator)
            {
                return PrefixUnary.Create(info.SetKind(ExprKind.LOG_NOT));
            }
            return PrefixUnary.Create(info.SetKind(ExprKind.NOT));
        }
    }
}
