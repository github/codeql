using System.Linq;
using Microsoft.CodeAnalysis;
using Semmle.Extraction.CSharp.Util;
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

        private ImplicitCast(ExpressionNodeInfo info)
            : base(new ExpressionInfo(info.Context, info.ConvertedType, info.Location, ExprKind.CAST, info.Parent, info.Child, isCompilerGenerated: true, info.ExprValue))
        {
            Expr = Factory.Create(new ExpressionNodeInfo(Context, info.Node, this, 0));
        }

        private ImplicitCast(ExpressionNodeInfo info, IMethodSymbol method)
            : base(new ExpressionInfo(info.Context, info.ConvertedType, info.Location, ExprKind.OPERATOR_INVOCATION, info.Parent, info.Child, isCompilerGenerated: true, info.ExprValue))
        {
            Expr = Factory.Create(info.SetParent(this, 0));

            AddOperatorCall(method);
        }

        private ImplicitCast(ExpressionInfo info, IMethodSymbol method, object value) : base(info)
        {
            Expr = Literal.CreateGenerated(Context, this, 0, method.Parameters[0].Type, value, info.Location);

            AddOperatorCall(method);
        }

        private void AddOperatorCall(IMethodSymbol method)
        {
            var target = Method.Create(Context, method);
            Context.TrapWriter.Writer.expr_call(this, target);
        }

        private static IMethodSymbol? GetImplicitConversionMethod(ITypeSymbol type, object value) =>
            type
                .GetMembers()
                .OfType<IMethodSymbol>()
                .Where(method =>
                    method.GetName() == "op_Implicit" &&
                    method.Parameters.Length == 1 &&
                    method.Parameters[0].Type.Name == value.GetType().Name
                )
                .FirstOrDefault();

        /// <summary>
        /// Creates a new generated expression with an implicit conversion added.
        /// </summary>
        public static Expression CreateGeneratedConversion(Context cx, IExpressionParentEntity parent, int childIndex, ITypeSymbol type, object value,
            Location location)
        {
            ExpressionInfo create(ExprKind kind, string? v) =>
                new ExpressionInfo(
                    cx,
                    AnnotatedTypeSymbol.CreateNotAnnotated(type),
                    location,
                    kind,
                    parent,
                    childIndex,
                    isCompilerGenerated: true,
                    v);

            var method = GetImplicitConversionMethod(type, value);
            if (method is not null)
            {
                var info = create(ExprKind.OPERATOR_INVOCATION, null);
                return new ImplicitCast(info, method, value);
            }
            else
            {
                cx.ModelError(location, "Failed to resolve target for implicit operator invocation for a parameter default.");
                return new Expression(create(ExprKind.UNKNOWN, ValueAsString(value)));
            }
        }

        /// <summary>
        /// Creates a new generated cast expression.
        /// </summary>
        public static Expression CreateGenerated(Context cx, IExpressionParentEntity parent, int childIndex, ITypeSymbol type, object value,
                    Location location)
        {
            var info = new ExpressionInfo(cx,
                    AnnotatedTypeSymbol.CreateNotAnnotated(type),
                    location,
                    ExprKind.CAST,
                    parent,
                    childIndex,
                    isCompilerGenerated: true,
                    ValueAsString(value));

            return new Expression(info);
        }

        /// <summary>
        /// Creates a new expression, adding casts as required.
        /// </summary>
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

            if (info.ImplicitToString)
            {
                // x -> x.ToString() in "abc" + x
                return ImplicitToString.Wrap(info);
            }

            // Default: Just create the expression without a conversion.
            return Factory.Create(info);
        }
    }
}
