using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class InterpolatedStringInsert : Expression
    {
        public InterpolatedStringInsert(Context cx, InterpolationSyntax syntax, Expression parent, int child) :
            base(new ExpressionInfo(cx, null, cx.CreateLocation(syntax.GetLocation()), ExprKind.INTERPOLATED_STRING_INSERT, parent, child, isCompilerGenerated: false, null))
        {
            var exp = syntax.Expression;
            if (parent.Type.IsStringType() &&
                cx.GetTypeInfo(exp).Type is ITypeSymbol type &&
                !type.ImplementsIFormattable())
            {
                ImplicitToString.Create(cx, exp, this, 0);
            }
            else
            {
                Create(cx, exp, this, 0);
            }

            // Hardcode the child number of the optional alignment clause to 1 and format clause to 2.
            // This simplifies the logic in QL.
            if (syntax.AlignmentClause?.Value is ExpressionSyntax alignment)
            {
                Create(cx, alignment, this, 1);
            }

            if (syntax.FormatClause is InterpolationFormatClauseSyntax format)
            {
                var f = format.FormatStringToken.ValueText;
                var t = AnnotatedTypeSymbol.CreateNotAnnotated(cx.Compilation.GetSpecialType(SpecialType.System_String));
                new Expression(new ExpressionInfo(cx, t, cx.CreateLocation(format.GetLocation()), ExprKind.UTF16_STRING_LITERAL, this, 2, isCompilerGenerated: false, f));
            }

        }
    }

}
