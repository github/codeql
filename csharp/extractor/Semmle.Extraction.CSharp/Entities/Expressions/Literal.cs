using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class Literal : Expression<LiteralExpressionSyntax>
    {
        private Literal(ExpressionNodeInfo info) : base(info.SetKind(GetKind(info))) { }

        public static Expression Create(ExpressionNodeInfo info) => new Literal(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile) { }

        private static ExprKind GetKind(ExpressionNodeInfo info)
        {
            switch (info.Node.Kind())
            {
                case SyntaxKind.DefaultLiteralExpression:
                    return ExprKind.DEFAULT;
                case SyntaxKind.NullLiteralExpression:
                    info.Type = Entities.NullType.Create(info.Context);  // Don't use converted type.
                    return ExprKind.NULL_LITERAL;
            }

            var type = info.Type.Type.symbol;

            switch (type.SpecialType)
            {
                case SpecialType.System_Boolean:
                    return ExprKind.BOOL_LITERAL;

                case SpecialType.System_Int16:
                case SpecialType.System_Int32:
                case SpecialType.System_Byte:       // ??
                    return ExprKind.INT_LITERAL;

                case SpecialType.System_Char:
                    return ExprKind.CHAR_LITERAL;

                case SpecialType.System_Decimal:
                    return ExprKind.DECIMAL_LITERAL;

                case SpecialType.System_Double:
                    return ExprKind.DOUBLE_LITERAL;

                case SpecialType.System_Int64:
                    return ExprKind.LONG_LITERAL;

                case SpecialType.System_Single:
                    return ExprKind.FLOAT_LITERAL;

                case SpecialType.System_String:
                    return ExprKind.STRING_LITERAL;

                case SpecialType.System_UInt16:
                case SpecialType.System_UInt32:
                case SpecialType.System_SByte:      // ??
                    return ExprKind.UINT_LITERAL;

                case SpecialType.System_UInt64:
                    return ExprKind.ULONG_LITERAL;

                default:
                    info.Context.ModelError(info.Node, "Unhandled literal type");
                    return ExprKind.UNKNOWN;
            }
        }
    }
}
