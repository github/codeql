using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    public static class Pattern
    {
        internal static Expression Create(Context cx, PatternSyntax syntax, IExpressionParentEntity parent, int child)
        {
            switch (syntax)
            {
                case ConstantPatternSyntax constantPattern:
                    return Expression.Create(cx, constantPattern.Expression, parent, child);

                case DeclarationPatternSyntax declPattern:
                    // Creates a single local variable declaration.
                    {
                        if (declPattern.Designation is VariableDesignationSyntax designation)
                        {
                            if (cx.GetModel(syntax).GetDeclaredSymbol(designation) is ILocalSymbol symbol)
                            {
                                var type = Type.Create(cx, symbol.GetAnnotatedType());
                                return VariableDeclaration.Create(cx, symbol, type, declPattern.Type, cx.Create(syntax.GetLocation()), false, parent, child);
                            }
                            if (designation is DiscardDesignationSyntax)
                            {
                                return Expressions.TypeAccess.Create(cx, declPattern.Type, parent, child);
                            }
                            throw new InternalError(designation, "Designation pattern not handled");
                        }
                        throw new InternalError(declPattern, "Declaration pattern not handled");
                    }

                case RecursivePatternSyntax recPattern:
                    return new RecursivePattern(cx, recPattern, parent, child);

                case VarPatternSyntax varPattern:
                    switch (varPattern.Designation)
                    {
                        case ParenthesizedVariableDesignationSyntax parDesignation:
                            return VariableDeclaration.CreateParenthesized(cx, varPattern, parDesignation, parent, child);
                        case SingleVariableDesignationSyntax varDesignation:
                            if (cx.GetModel(syntax).GetDeclaredSymbol(varDesignation) is ILocalSymbol symbol)
                            {
                                var type = Type.Create(cx, symbol.GetAnnotatedType());

                                return VariableDeclaration.Create(cx, symbol, type, null, cx.Create(syntax.GetLocation()), true, parent, child);
                            }

                            throw new InternalError(varPattern, "Unable to get the declared symbol of the var pattern designation.");
                        case DiscardDesignationSyntax discard:
                            return new Expressions.Discard(cx, discard, parent, child);
                        default:
                            throw new InternalError("var pattern designation is unhandled");
                    }

                case DiscardPatternSyntax dp:
                    return new Discard(cx, dp, parent, child);

                default:
                    throw new InternalError(syntax, "Pattern not handled");
            }
        }
    }
}
