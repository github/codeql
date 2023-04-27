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
                case SyntaxKind.Utf8StringLiteralExpression:
                    return ExprKind.UTF8_STRING_LITERAL;
                case SyntaxKind.NullLiteralExpression:
                    info.SetType(null);  // Don't use converted type.
                    return ExprKind.NULL_LITERAL;
            }

            // short circuit bool literals, because they have no type in `#if A = true`
            if (info.IsBoolLiteral())
            {
                return ExprKind.BOOL_LITERAL;
            }

            var type = info.Type?.Symbol;
            return GetExprKind(type, info.Node, info.Location, info.Context);
        }

        private static ExprKind GetExprKind(ITypeSymbol? type, ExpressionSyntax? expr, Extraction.Entities.Location loc, Context context)
        {
            switch (type?.SpecialType)
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
                    return ExprKind.UTF16_STRING_LITERAL;

                case SpecialType.System_UInt16:
                case SpecialType.System_UInt32:
                case SpecialType.System_SByte:      // ??
                    return ExprKind.UINT_LITERAL;

                case SpecialType.System_UInt64:
                    return ExprKind.ULONG_LITERAL;

                case null:
                default:
                    var kind = type?.SpecialType.ToString() ?? "null";
                    if (expr is not null)
                        context.ModelError(expr, $"Unhandled literal type {kind}");
                    else
                        context.ModelError(loc, $"Unhandled literal type {kind}");
                    return ExprKind.UNKNOWN;
            }
        }

        public static Expression CreateGenerated(Context cx, IExpressionParentEntity parent, int childIndex, ITypeSymbol type, object? value,
            Extraction.Entities.Location location)
        {
            var kind = value is null ? ExprKind.NULL_LITERAL : GetExprKind(type, null, location, cx);
            var info = new ExpressionInfo(
                cx,
                AnnotatedTypeSymbol.CreateNotAnnotated(type),
                location,
                kind,
                parent,
                childIndex,
                true,
                ValueAsString(value));

            return new Expression(info);
        }

        public static Expression CreateGeneratedNullLiteral(Context cx, IExpressionParentEntity parent, int childIndex, Extraction.Entities.Location location)
        {
            var info = new ExpressionInfo(
                cx,
                null,
                location,
                ExprKind.NULL_LITERAL,
                parent,
                childIndex,
                true,
                ValueAsString(null));

            return new Expression(info);
        }
    }
}
