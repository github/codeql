using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Extraction.Kinds;
using Semmle.Extraction.Entities;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal static class PatternExtensions
    {
        public static Expression CreatePattern(this Context cx, PatternSyntax syntax, IExpressionParentEntity parent, int child)
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

    internal class PropertyPattern : Expression
    {
        internal PropertyPattern(Context cx, PropertyPatternClauseSyntax pp, IExpressionParentEntity parent, int child) :
            base(new ExpressionInfo(cx, Entities.NullType.Create(cx), cx.Create(pp.GetLocation()), ExprKind.PROPERTY_PATTERN, parent, child, false, null))
        {
            child = 0;
            var trapFile = cx.TrapWriter.Writer;
            foreach (var sub in pp.Subpatterns)
            {
                var p = cx.CreatePattern(sub.Pattern, this, child++);
                trapFile.exprorstmt_name(p, sub.NameColon.Name.ToString());
            }
        }
    }

    internal class PositionalPattern : Expression
    {
        internal PositionalPattern(Context cx, PositionalPatternClauseSyntax posPc, IExpressionParentEntity parent, int child) :
            base(new ExpressionInfo(cx, Entities.NullType.Create(cx), cx.Create(posPc.GetLocation()), ExprKind.POSITIONAL_PATTERN, parent, child, false, null))
        {
            child = 0;
            foreach (var sub in posPc.Subpatterns)
            {
                cx.CreatePattern(sub.Pattern, this, child++);
            }
        }
    }

    internal class RecursivePattern : Expression
    {
        /// <summary>
        /// Creates and populates a recursive pattern.
        /// </summary>
        /// <param name="cx">The extraction context.</param>
        /// <param name="syntax">The syntax node of the recursive pattern.</param>
        /// <param name="parent">The parent pattern/expression.</param>
        /// <param name="child">The child index of this pattern.</param>
        /// <param name="isTopLevel">If this pattern is in the top level of a case/is. In that case, the variable and type access are populated elsewhere.</param>
        public RecursivePattern(Context cx, RecursivePatternSyntax syntax, IExpressionParentEntity parent, int child) :
            base(new ExpressionInfo(cx, Entities.NullType.Create(cx), cx.Create(syntax.GetLocation()), ExprKind.RECURSIVE_PATTERN, parent, child, false, null))
        {
            // Extract the type access
            if (syntax.Type is TypeSyntax t)
                Expressions.TypeAccess.Create(cx, t, this, 1);

            // Extract the local variable declaration
            if (syntax.Designation is VariableDesignationSyntax designation && cx.GetModel(syntax).GetDeclaredSymbol(designation) is ILocalSymbol symbol)
            {
                var type = Entities.Type.Create(cx, symbol.GetAnnotatedType());

                VariableDeclaration.Create(cx, symbol, type, null, cx.Create(syntax.GetLocation()), false, this, 0);
            }

            if (syntax.PositionalPatternClause is PositionalPatternClauseSyntax posPc)
            {
                new PositionalPattern(cx, posPc, this, 2);
            }

            if (syntax.PropertyPatternClause is PropertyPatternClauseSyntax pc)
            {
                new PropertyPattern(cx, pc, this, 3);
            }
        }
    }

    internal class IsPattern : Expression<IsPatternExpressionSyntax>
    {
        private IsPattern(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.IS))
        {
        }

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(cx, Syntax.Expression, this, 0);
            cx.CreatePattern(Syntax.Pattern, this, 1);
        }

        public static Expression Create(ExpressionNodeInfo info) => new IsPattern(info).TryPopulate();
    }
}
