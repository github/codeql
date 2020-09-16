using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Populators;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class ImplicitCast : Expression
    {
        public Expression Expr
        {
            get;
            private set;
        }

        public ImplicitCast(ExpressionNodeInfo info)
            : base(new ExpressionInfo(info.Context, Entities.Type.Create(info.Context, info.ConvertedType), info.Location, ExprKind.CAST, info.Parent, info.Child, true, info.ExprValue))
        {
            Expr = Factory.Create(new ExpressionNodeInfo(cx, info.Node, this, 0));
        }

        public ImplicitCast(ExpressionNodeInfo info, IMethodSymbol method)
            : base(new ExpressionInfo(info.Context, Entities.Type.Create(info.Context, info.ConvertedType), info.Location, ExprKind.OPERATOR_INVOCATION, info.Parent, info.Child, true, info.ExprValue))
        {
            Expr = Factory.Create(info.SetParent(this, 0));

            var target = Method.Create(cx, method);
            if (target != null)
                cx.TrapWriter.Writer.expr_call(this, target);
            else
                cx.ModelError(info.Node, "Failed to resolve target for operator invocation");
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

            if (conversion.MethodSymbol != null)
            {
                bool convertedToDelegate = Entities.Type.IsDelegate(convertedType.Symbol);

                if (convertedToDelegate)
                {
                    bool isExplicitConversion =
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

                if (resolvedType.Symbol != null)
                    return new ImplicitCast(info, conversion.MethodSymbol);
            }

            bool implicitUpcast = conversion.IsImplicit &&
                convertedType.Symbol != null &&
                !conversion.IsBoxing &&
                (
                    resolvedType.Symbol == null ||
                    conversion.IsReference ||
                    convertedType.Symbol.SpecialType == SpecialType.System_Object)
                ;

            if (!conversion.IsIdentity && !implicitUpcast)
            {
                return new ImplicitCast(info);
            }

            // Default: Just create the expression without a conversion.
            return Factory.Create(info);
        }
    }
}
