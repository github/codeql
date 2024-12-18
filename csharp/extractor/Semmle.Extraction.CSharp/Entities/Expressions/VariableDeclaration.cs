using System.Collections.Immutable;
using System.Collections.Generic;
using System.Linq;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Populators;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class VariableDeclaration : Expression
    {
        private VariableDeclaration(IExpressionInfo info) : base(info) { }

        public static VariableDeclaration Create(Context cx, ISymbol symbol, AnnotatedTypeSymbol? type, TypeSyntax? optionalSyntax, Location exprLocation, bool isVar, IExpressionParentEntity parent, int child)
        {
            var ret = new VariableDeclaration(new ExpressionInfo(cx, type, exprLocation, ExprKind.LOCAL_VAR_DECL, parent, child, isCompilerGenerated: false, null));
            cx.Try(null, null, () =>
            {
                var l = LocalVariable.Create(cx, symbol);
                l.PopulateManual(ret, isVar);
                if (optionalSyntax is not null)
                    TypeMention.Create(cx, optionalSyntax, ret, type);
            });
            return ret;
        }

        private static VariableDeclaration CreateSingle(Context cx, DeclarationExpressionSyntax node, SingleVariableDesignationSyntax designation, IExpressionParentEntity parent, int child)
        {
            var variableSymbol = cx.GetModel(designation).GetDeclaredSymbol(designation) as ILocalSymbol;
            if (variableSymbol is null)
            {
                cx.ModelError(node, "Failed to determine local variable");
                return Create(cx, node, (AnnotatedTypeSymbol?)null, parent, child);
            }

            var type = variableSymbol.GetAnnotatedType();
            var ret = Create(cx, designation, type, parent, child);
            cx.Try(null, null, () =>
            {
                var l = LocalVariable.Create(cx, variableSymbol);
                l.PopulateManual(ret, node.Type.IsVar);
            });
            return ret;
        }

        /// <summary>
        /// Create a tuple expression representing a parenthesized variable declaration.
        /// That is, we consider `var (x, y) = ...` to be equivalent to `(var x, var y) = ...`.
        /// </summary>
        public static Expression CreateParenthesized(Context cx, DeclarationExpressionSyntax node, ParenthesizedVariableDesignationSyntax designation, IExpressionParentEntity parent, int child, INamedTypeSymbol? t)
        {
            var type = t is null ? (AnnotatedTypeSymbol?)null : new AnnotatedTypeSymbol(t, t.NullableAnnotation);
            var tuple = new Expression(new ExpressionInfo(cx, type, cx.CreateLocation(node.GetLocation()), ExprKind.TUPLE, parent, child, isCompilerGenerated: false, null));

            cx.Try(null, null, () =>
            {
                for (var child0 = 0; child0 < designation.Variables.Count; child0++)
                {
                    Create(cx, node, designation.Variables[child0], tuple, child0, t?.TypeArguments[child0] as INamedTypeSymbol);
                }
            });

            return tuple;
        }

        public static Expression CreateParenthesized(Context cx, VarPatternSyntax varPattern, ParenthesizedVariableDesignationSyntax designation, IExpressionParentEntity parent, int child)
        {
            var tuple = new Expression(
                new ExpressionInfo(cx, null, cx.CreateLocation(varPattern.GetLocation()), ExprKind.TUPLE, parent, child, isCompilerGenerated: false, null),
                shouldPopulate: false);

            var elementTypes = new List<ITypeSymbol?>();
            cx.Try(null, null, () =>
            {
                var child0 = 0;
                foreach (var variable in designation.Variables)
                {
                    Expression sub;
                    switch (variable)
                    {
                        case ParenthesizedVariableDesignationSyntax paren:
                            sub = CreateParenthesized(cx, varPattern, paren, tuple, child0++);
                            break;
                        case SingleVariableDesignationSyntax single:
                            if (cx.GetModel(variable).GetDeclaredSymbol(single) is ILocalSymbol local)
                            {
                                var decl = Create(cx, variable, local.GetAnnotatedType(), tuple, child0++);
                                var l = LocalVariable.Create(cx, local);
                                l.PopulateManual(decl, true);
                                sub = decl;
                            }
                            else
                            {
                                throw new InternalError(single, "Failed to access local variable");
                            }
                            break;
                        case DiscardDesignationSyntax discard:
                            sub = new Discard(cx, discard, tuple, child0++);
                            if (!sub.Type.HasValue || sub.Type.Value.Symbol is null)
                            {
                                // The type is only updated in memory, it will not be written to the trap file.
                                sub.SetType(cx.Compilation.GetSpecialType(SpecialType.System_Object));
                            }
                            break;
                        default:
                            var type = variable.GetType().ToString() ?? "null";
                            throw new InternalError(variable, $"Unhandled designation type {type}");
                    }

                    elementTypes.Add(sub.Type.HasValue && sub.Type.Value.Symbol?.Kind != SymbolKind.ErrorType
                        ? sub.Type.Value.Symbol
                        : null);
                }
            });

            INamedTypeSymbol? tupleType = null;
            if (!elementTypes.Any(et => et is null))
            {
                tupleType = cx.Compilation.CreateTupleTypeSymbol(elementTypes.ToImmutableArray()!);
            }

            tuple.SetType(tupleType);
            tuple.TryPopulate();

            return tuple;
        }

        private static Expression Create(Context cx, DeclarationExpressionSyntax node, VariableDesignationSyntax? designation, IExpressionParentEntity parent, int child, INamedTypeSymbol? declarationType)
        {
            switch (designation)
            {
                case SingleVariableDesignationSyntax single:
                    return CreateSingle(cx, node, single, parent, child);
                case ParenthesizedVariableDesignationSyntax paren:
                    return CreateParenthesized(cx, node, paren, parent, child, declarationType);
                case DiscardDesignationSyntax discard:
                    var type = cx.GetType(discard);
                    return Create(cx, node, type, parent, child);
                default:
                    cx.ModelError(node, "Failed to determine designation type");
                    return Create(cx, node, null, parent, child);
            }
        }

        public static Expression Create(Context cx, DeclarationExpressionSyntax node, IExpressionParentEntity parent, int child) =>
            Create(cx, node, node.Designation, parent, child, cx.GetTypeInfo(node).Type.DisambiguateType() as INamedTypeSymbol);

        public static VariableDeclaration Create(Context cx, CSharpSyntaxNode c, AnnotatedTypeSymbol? type, IExpressionParentEntity parent, int child) =>
            new VariableDeclaration(new ExpressionInfo(cx, type, cx.CreateLocation(c.FixedLocation()), ExprKind.LOCAL_VAR_DECL, parent, child, isCompilerGenerated: false, null));

        public static VariableDeclaration Create(Context cx, CatchDeclarationSyntax d, bool isVar, IExpressionParentEntity parent, int child)
        {
            var symbol = cx.GetModel(d).GetDeclaredSymbol(d)!;
            var type = symbol.GetAnnotatedType();
            var ret = Create(cx, d, type, parent, child);
            cx.Try(d, null, () =>
            {
                var declSymbol = cx.GetModel(d).GetDeclaredSymbol(d)!;
                var l = LocalVariable.Create(cx, declSymbol);
                l.PopulateManual(ret, isVar);
                TypeMention.Create(cx, d.Type, ret, type);
            });
            return ret;
        }

        public static VariableDeclaration CreateDeclarator(Context cx, VariableDeclaratorSyntax d, AnnotatedTypeSymbol type, bool isVar, IExpressionParentEntity parent, int child)
        {
            var ret = Create(cx, d, type, parent, child);
            cx.Try(d, null, () =>
            {
                var declSymbol = cx.GetModel(d).GetDeclaredSymbol(d)!;
                var localVar = LocalVariable.Create(cx, declSymbol);
                localVar.PopulateManual(ret, isVar);

                if (d.Initializer is not null)
                {
                    Create(cx, d.Initializer.Value, ret, 0);

                    // Create an access
                    var access = new Expression(new ExpressionInfo(cx, type, localVar.Location, ExprKind.LOCAL_VARIABLE_ACCESS, ret, 1, isCompilerGenerated: false, null));
                    cx.TrapWriter.Writer.expr_access(access, localVar);
                }

                if (d.Parent is VariableDeclarationSyntax decl)
                    TypeMention.Create(cx, decl.Type, ret, type);
            });
            return ret;
        }
    }

    internal static class VariableDeclarations
    {
        public static void Populate(Context cx, VariableDeclarationSyntax decl, IExpressionParentEntity parent, int child, int childIncrement = 1)
        {
            var type = cx.GetType(decl.Type);

            foreach (var v in decl.Variables)
            {
                VariableDeclaration.CreateDeclarator(cx, v, type, decl.Type.IsVar, parent, child);
                child += childIncrement;
            }
        }
    }
}
