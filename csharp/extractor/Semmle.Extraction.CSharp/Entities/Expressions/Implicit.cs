using System.Linq;
using Microsoft.CodeAnalysis;
using Semmle.Extraction.CSharp.Util;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal sealed class Implicit : Expression
    {
        private Implicit(ExpressionNodeInfo info)
            : base(new ExpressionInfo(info.Context, info.ConvertedType, info.Location, ExprKind.CAST, info.Parent, info.Child, isCompilerGenerated: true, info.ExprValue))
        {
            Factory.Create(new ExpressionNodeInfo(Context, info.Node, this, 0));
        }

        private Implicit(ExpressionNodeInfo info, IMethodSymbol method, ExprKind kind, int child)
            : base(new ExpressionInfo(info.Context, info.ConvertedType, info.Location, kind, info.Parent, info.Child, isCompilerGenerated: true, info.ExprValue))
        {
            Factory.Create(info.SetParent(this, child));

            AddCall(method);
        }

        private Implicit(ExpressionInfo info, IMethodSymbol method, object value) : base(info)
        {
            Literal.CreateGenerated(Context, this, 0, method.Parameters[0].Type, value, info.Location);

            AddCall(method);
        }

        private void AddCall(IMethodSymbol method)
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
                return new Implicit(info, method, value);
            }
            else
            {
                cx.ModelError(location, "Failed to resolve target for implicit operator invocation for a parameter default.");
                return new Expression(create(ExprKind.UNKNOWN, ValueAsString(value)));
            }
        }

        /// <summary>
        /// Gets the `ToString` method for the given type.
        /// </summary>
        private static IMethodSymbol? GetToStringMethod(ITypeSymbol type)
        {
            return type
                .GetMembers()
                .OfType<IMethodSymbol>()
                .Where(method =>
                    method.GetName() == "ToString" &&
                    method.Parameters.Length == 0
                )
                .FirstOrDefault();
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
                    return new Implicit(info, conversion.MethodSymbol, ExprKind.OPERATOR_INVOCATION, 0);
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
                return new Implicit(info);
            }

            // Implicit call to ToString.
            if (!conversion.IsIdentity &&
                resolvedType.Symbol is not null &&
                implicitUpcast && // Maybe write the condition explicitly.
                info.Parent is Expression par && // TODO: Only choose a specific set of parents (maybe BinaryExpression and StringInterpolation expressions?)
                par.Type.HasValue && par.Type.Value.Symbol?.SpecialType == SpecialType.System_String)
            {
                return GetToStringMethod(resolvedType.Symbol) is IMethodSymbol toString
                    ? new Implicit(info, toString, ExprKind.METHOD_INVOCATION, -1)
                    : Factory.Create(info);
            }

            if (conversion.IsIdentity && conversion.IsImplicit &&
                convertedType.Symbol is IPointerTypeSymbol &&
                !(resolvedType.Symbol is IPointerTypeSymbol))
            {
                // int[] -> int*
                // string -> char*
                return new Implicit(info);
            }

            // Default: Just create the expression without a conversion.
            return Factory.Create(info);
        }
    }
}
