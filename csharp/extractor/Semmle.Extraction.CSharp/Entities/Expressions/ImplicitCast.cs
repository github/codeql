using Microsoft.CodeAnalysis;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal sealed class ImplicitCast : Expression
    {
        public Expression Expr
        {
            get;
            private set;
        }

        public ImplicitCast(ExpressionNodeInfo info)
            : base(new ExpressionInfo(info.Context, info.ConvertedType, info.Location, ExprKind.CAST, info.Parent, info.Child, true, info.ExprValue))
        {
            Expr = Factory.Create(new ExpressionNodeInfo(Context, info.Node, this, 0));
        }

        public ImplicitCast(ExpressionNodeInfo info, IMethodSymbol method)
            : base(new ExpressionInfo(info.Context, info.ConvertedType, info.Location, ExprKind.OPERATOR_INVOCATION, info.Parent, info.Child, true, info.ExprValue))
        {
            Expr = Factory.Create(info.SetParent(this, 0));

            var target = Method.Create(Context, method);
            if (target is not null)
                Context.TrapWriter.Writer.expr_call(this, target);
            else
                Context.ModelError(info.Node, "Failed to resolve target for operator invocation");
        }

        /// <summary>
        /// Creates a new expression, adding casts as required.
        /// </summary>
        /// <param name="cx">The extraction context.</param>
        /// <param name="node">The expression node.</param>
        /// <param name="parent">The parent of the expression.</param>
        /// <param name="child">The child number.</param>
        /// <param name="type">A type hint.</param>
        /// <returns>A new expression.</returns>
        public static Expression Create(ExpressionNodeInfo info)
        {
            var resolvedType = info.ResolvedType;
            var convertedType = info.ConvertedType;
            var conversion = info.Conversion;

            if (conversion.MethodSymbol is not null)
            {
                var convertedToDelegate = Entities.Type.IsDelegate(convertedType.Symbol);

                if (convertedToDelegate)
                {
                    var isExplicitConversion =
                        info.Parent is ExplicitObjectCreation objectCreation &&
                        objectCreation.Kind == ExprKind.EXPLICIT_DELEGATE_CREATION;

                    if (!isExplicitConversion)
                    {
                        info.Kind = ExprKind.IMPLICIT_DELEGATE_CREATION;
                        var parent = new Expression(info);
                        return Factory.Create(new ExpressionNodeInfo(info.Context, info.Node, parent, 0));
                    }

                    info.Kind = ExprKind.UNKNOWN;
                    return Factory.Create(info);
                }

                if (resolvedType.Symbol is not null)
                    return new ImplicitCast(info, conversion.MethodSymbol);
            }

            var implicitUpcast = conversion.IsImplicit &&
                convertedType.Symbol is not null &&
                !conversion.IsBoxing &&
                (
                    resolvedType.Symbol is null ||
                    conversion.IsReference ||
                    convertedType.Symbol.SpecialType == SpecialType.System_Object)
                ;

            if (!conversion.IsIdentity && !implicitUpcast)
            {
                return new ImplicitCast(info);
            }

            if (conversion.IsIdentity && conversion.IsImplicit &&
                convertedType.Symbol is IPointerTypeSymbol &&
                !(resolvedType.Symbol is IPointerTypeSymbol))
            {
                // int[] -> int*
                // string -> char*
                return new ImplicitCast(info);
            }

            // Default: Just create the expression without a conversion.
            return Factory.Create(info);
        }
    }
}
