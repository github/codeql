using System.IO;
using System.Linq;
using Microsoft.CodeAnalysis;
using Semmle.Extraction.CSharp.Util;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class DateTimeObjectCreation : Expression
    {
        private readonly IMethodSymbol constructorSymbol;

        private DateTimeObjectCreation(IMethodSymbol constructorSymbol, ExpressionInfo info) : base(info)
        {
            this.constructorSymbol = constructorSymbol;
        }

        // Gets the value of a System.DateTime object as a string containing the ticks.
        private static long ValueAsLong(object? value) =>
            value is System.DateTime d ? d.Ticks : 0;

        // Gets the System.DateTime(long) constructor from the `type` symbol.
        private static IMethodSymbol? GetDateTimeConstructor(ITypeSymbol? type)
        {
            return type?.GetMembers()
                .Where(m =>
                    m is IMethodSymbol c &&
                    c.GetName() == "ctor" &&
                    c.Parameters.Length == 1 &&
                    c.Parameters[0].Type.SpecialType == SpecialType.System_Int64)
                .Cast<IMethodSymbol>()
                .FirstOrDefault();
        }


        protected void PopulateExpression(TextWriter trapFile)
        {
            var constructor = Constructor.Create(Context, constructorSymbol);
            trapFile.expr_call(this, constructor);
        }

        protected new Expression TryPopulate()
        {
            Context.Try(null, null, () => PopulateExpression(Context.TrapWriter.Writer));
            return this;
        }

        // Gets an expression that represents a System.DateTime object creation.
        // The `type` symbol must be a System.DateTime type and the value must be a System.DateTime object.
        // The expression that is being created is a call to the System.DateTime(long) constructor, where
        // the number of ticks from the `value` object is used as the argument to the constructor call.
        public static Expression CreateGenerated(Context cx, IExpressionParentEntity parent, int childIndex, ITypeSymbol type, object? value, Location location)
        {
            var constructorSymbol = GetDateTimeConstructor(type) ?? throw new InternalError("Could not find symbol for System.DateTime(long)");
            var expr = new DateTimeObjectCreation(constructorSymbol, new ExpressionInfo(
                cx,
                AnnotatedTypeSymbol.CreateNotAnnotated(type),
                location,
                ExprKind.OBJECT_CREATION,
                parent,
                childIndex,
                isCompilerGenerated: true,
                null));

            var longTypeSymbol = constructorSymbol.Parameters[0].Type;
            Literal.CreateGenerated(cx, expr, 0, longTypeSymbol, ValueAsLong(value), location);

            return expr.TryPopulate();
        }
    }
}
