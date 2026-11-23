using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    public static class Pattern
    {
        internal static Expression Create(Context cx, PatternSyntax syntax, IExpressionParentEntity parent, int child)
        {
            switch (syntax)
            {
                case ParenthesizedPatternSyntax parenthesizedPattern:
                    return Pattern.Create(cx, parenthesizedPattern.Pattern, parent, child);

                case ConstantPatternSyntax constantPattern:
                    return Expression.Create(cx, constantPattern.Expression, parent, child);

                case TypePatternSyntax typePattern:
                    return Expressions.TypeAccess.Create(cx, typePattern.Type, parent, child);

                case UnaryPatternSyntax unaryPattern:
                    return new UnaryPattern(cx, unaryPattern, parent, child);

                case BinaryPatternSyntax binaryPattern:
                    return new BinaryPattern(cx, binaryPattern, parent, child);

                case DeclarationPatternSyntax declPattern:
                    // Creates a single local variable declaration.
                    {
                        switch (declPattern.Designation)
                        {
                            case SingleVariableDesignationSyntax singleDesignation:
                                if (cx.GetModel(syntax).GetDeclaredSymbol(singleDesignation) is ILocalSymbol symbol)
                                {
                                    var type = symbol.GetAnnotatedType();
                                    return VariableDeclaration.Create(cx, symbol, type, declPattern.Type, cx.CreateLocation(syntax.GetLocation()), false, parent, child);
                                }
                                throw new InternalError(singleDesignation, "Unable to get the declared symbol of the declaration pattern designation.");
                            case DiscardDesignationSyntax _:
                                return Expressions.TypeAccess.Create(cx, declPattern.Type, parent, child);
                            default:
                                throw new InternalError($"declaration pattern designation of type {declPattern.Designation.GetType()} is unhandled");
                        }
                    }

                case RecursivePatternSyntax recPattern:
                    return new RecursivePattern(cx, recPattern, parent, child);

                case RelationalPatternSyntax relPattern:
                    return new RelationalPattern(cx, relPattern, parent, child);

                case VarPatternSyntax varPattern:
                    switch (varPattern.Designation)
                    {
                        case ParenthesizedVariableDesignationSyntax parDesignation:
                            return VariableDeclaration.CreateParenthesized(cx, varPattern, parDesignation, parent, child);
                        case SingleVariableDesignationSyntax varDesignation:
                            if (cx.GetModel(syntax).GetDeclaredSymbol(varDesignation) is ILocalSymbol symbol)
                            {
                                var type = symbol.GetAnnotatedType();
                                return VariableDeclaration.Create(cx, symbol, type, null, cx.CreateLocation(syntax.GetLocation()), true, parent, child);
                            }

                            throw new InternalError(varPattern, "Unable to get the declared symbol of the var pattern designation.");
                        case DiscardDesignationSyntax discard:
                            return new Expressions.Discard(cx, discard, parent, child);
                        default:
                            throw new InternalError($"var pattern designation of type {varPattern.Designation.GetType()} is unhandled");
                    }

                case DiscardPatternSyntax dp:
                    return new Discard(cx, dp, parent, child);

                case ListPatternSyntax listPattern:
                    return new ListPattern(cx, listPattern, parent, child);

                case SlicePatternSyntax slicePattern:
                    return new SlicePattern(cx, slicePattern, parent, child);

                default:
                    throw new InternalError(syntax, "Pattern not handled");
            }
        }
    }
}
