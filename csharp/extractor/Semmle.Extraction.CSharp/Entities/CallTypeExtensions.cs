using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities
{
    internal static class CallTypeExtensions
    {
        /// <summary>
        /// Adjust the expression kind <paramref name="k"/> to match this call type.
        /// </summary>
        public static ExprKind AdjustKind(this Expression.CallType ct, ExprKind k)
        {
            if (k == ExprKind.ADDRESS_OF || k == ExprKind.SUPPRESS_NULLABLE_WARNING)
            {
                return k;
            }

            switch (ct)
            {
                case Expression.CallType.Dynamic:
                case Expression.CallType.UserOperator:
                    return ExprKind.OPERATOR_INVOCATION;
                default:
                    return k;
            }
        }
    }
}
