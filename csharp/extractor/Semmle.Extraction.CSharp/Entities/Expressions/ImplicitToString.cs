using System.Linq;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Util;
using Semmle.Extraction.Kinds;


namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal sealed class ImplicitToString : Expression
    {
        /// <summary>
        /// Gets the `ToString` method for the given type.
        /// </summary>
        private static IMethodSymbol? GetToStringMethod(ITypeSymbol? type)
        {
            if (type is null)
            {
                return null;
            }

            var toString = type
                .GetMembers()
                .OfType<IMethodSymbol>()
                .Where(method =>
                    method.GetName() == "ToString" &&
                    method.Parameters.Length == 0
                )
                .FirstOrDefault();

            return toString ?? GetToStringMethod(type.BaseType);
        }

        private ImplicitToString(ExpressionNodeInfo info, IMethodSymbol toString) : base(new ExpressionInfo(info.Context, AnnotatedTypeSymbol.CreateNotAnnotated(toString.ReturnType), info.Location, ExprKind.METHOD_INVOCATION, info.Parent, info.Child, isCompilerGenerated: true, info.ExprValue))
        {
            Factory.Create(info.SetParent(this, -1));

            var target = Method.Create(Context, toString);
            Context.TrapWriter.Writer.expr_call(this, target);
        }

        private static bool IsStringType(AnnotatedTypeSymbol? type) =>
            type.HasValue && type.Value.Symbol?.SpecialType == SpecialType.System_String;

        /// <summary>
        /// Creates a new expression, adding a compiler generated `ToString` call if required.
        /// </summary>
        public static Expression Create(Context cx, ExpressionSyntax node, Expression parent, int child)
        {
            var info = new ExpressionNodeInfo(cx, node, parent, child);
            return CreateFromNode(info.SetImplicitToString(IsStringType(parent.Type) && !IsStringType(info.Type)));
        }

        /// <summary>
        /// Wraps the resulting expression in a `ToString` call, if a suitable `ToString` method is available.
        /// </summary>
        public static Expression Wrap(ExpressionNodeInfo info)
        {
            if (GetToStringMethod(info.Type?.Symbol) is IMethodSymbol toString)
            {
                return new ImplicitToString(info, toString);
            }
            return Factory.Create(info);
        }
    }
}
