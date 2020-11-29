using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Populators;
using Semmle.Extraction.Kinds;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class VariableDeclaration : Expression
    {
        private VariableDeclaration(IExpressionInfo info) : base(info) { }

        public static VariableDeclaration Create(Context cx, ISymbol symbol, AnnotatedType type, TypeSyntax optionalSyntax, Extraction.Entities.Location exprLocation, bool isVar, IExpressionParentEntity parent, int child)
        {
            var ret = new VariableDeclaration(new ExpressionInfo(cx, type, exprLocation, ExprKind.LOCAL_VAR_DECL, parent, child, false, null));
            cx.Try(null, null, () =>
            {
                var l = LocalVariable.Create(cx, symbol);
                l.PopulateManual(ret, isVar);
                if (optionalSyntax != null)
                    TypeMention.Create(cx, optionalSyntax, ret, type);
            });
            return ret;
        }

        private static VariableDeclaration CreateSingle(Context cx, DeclarationExpressionSyntax node, SingleVariableDesignationSyntax designation, IExpressionParentEntity parent, int child)
        {
            var variableSymbol = cx.GetModel(designation).GetDeclaredSymbol(designation) as ILocalSymbol;
            if (variableSymbol == null)
            {
                cx.ModelError(node, "Failed to determine local variable");
                return Create(cx, node, NullType.Create(cx), parent, child);
            }

            var type = Entities.Type.Create(cx, variableSymbol.GetAnnotatedType());
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
        public static Expression CreateParenthesized(Context cx, DeclarationExpressionSyntax node, ParenthesizedVariableDesignationSyntax designation, IExpressionParentEntity parent, int child)
        {
            var type = Entities.NullType.Create(cx); // Should ideally be a corresponding tuple type
            var tuple = new Expression(new ExpressionInfo(cx, type, cx.Create(node.GetLocation()), ExprKind.TUPLE, parent, child, false, null));

            cx.Try(null, null, () =>
            {
                var child0 = 0;
                foreach (var variable in designation.Variables)
                    Create(cx, node, variable, tuple, child0++);
            });

            return tuple;
        }

        public static Expression CreateParenthesized(Context cx, VarPatternSyntax varPattern, ParenthesizedVariableDesignationSyntax designation, IExpressionParentEntity parent, int child)
        {
            var type = NullType.Create(cx); // Should ideally be a corresponding tuple type
            var tuple = new Expression(new ExpressionInfo(cx, type, cx.Create(varPattern.GetLocation()), ExprKind.TUPLE, parent, child, false, null));

            cx.Try(null, null, () =>
            {
                var child0 = 0;
                foreach (var variable in designation.Variables)
                {
                    switch (variable)
                    {
                        case ParenthesizedVariableDesignationSyntax paren:
                            CreateParenthesized(cx, varPattern, paren, tuple, child0++);
                            break;
                        case SingleVariableDesignationSyntax single:
                            if (cx.GetModel(variable).GetDeclaredSymbol(single) is ILocalSymbol local)
                            {
                                var decl = Create(cx, variable, Entities.Type.Create(cx, local.GetAnnotatedType()), tuple, child0++);
                                var l = LocalVariable.Create(cx, local);
                                l.PopulateManual(decl, true);
                            }
                            else
                            {
                                throw new InternalError(single, "Failed to access local variable");
                            }
                            break;
                        case DiscardDesignationSyntax discard:
                            new Discard(cx, discard, tuple, child0++);
                            break;
                        default:
                            throw new InternalError(variable, "Unhandled designation type");
                    }
                }
            });

            return tuple;
        }


        private static Expression Create(Context cx, DeclarationExpressionSyntax node, VariableDesignationSyntax designation, IExpressionParentEntity parent, int child)
        {
            switch (designation)
            {
                case SingleVariableDesignationSyntax single:
                    return CreateSingle(cx, node, single, parent, child);
                case ParenthesizedVariableDesignationSyntax paren:
                    return CreateParenthesized(cx, node, paren, parent, child);
                case DiscardDesignationSyntax discard:
                    var ti = cx.GetType(discard);
                    var type = Entities.Type.Create(cx, ti);
                    return Create(cx, node, type, parent, child);
                default:
                    cx.ModelError(node, "Failed to determine designation type");
                    return Create(cx, node, NullType.Create(cx), parent, child);
            }
        }

        public static Expression Create(Context cx, DeclarationExpressionSyntax node, IExpressionParentEntity parent, int child) =>
            Create(cx, node, node.Designation, parent, child);

        public static VariableDeclaration Create(Context cx, CSharpSyntaxNode c, AnnotatedType type, IExpressionParentEntity parent, int child) =>
            new VariableDeclaration(new ExpressionInfo(cx, type, cx.Create(c.FixedLocation()), ExprKind.LOCAL_VAR_DECL, parent, child, false, null));

        public static VariableDeclaration Create(Context cx, CatchDeclarationSyntax d, bool isVar, IExpressionParentEntity parent, int child)
        {
            var symbol = cx.GetModel(d).GetDeclaredSymbol(d);
            var type = Entities.Type.Create(cx, symbol.GetAnnotatedType());
            var ret = Create(cx, d, type, parent, child);
            cx.Try(d, null, () =>
            {
                var declSymbol = cx.GetModel(d).GetDeclaredSymbol(d);
                var l = LocalVariable.Create(cx, declSymbol);
                l.PopulateManual(ret, isVar);
                TypeMention.Create(cx, d.Type, ret, type);
            });
            return ret;
        }

        public static VariableDeclaration CreateDeclarator(Context cx, VariableDeclaratorSyntax d, AnnotatedType type, bool isVar, IExpressionParentEntity parent, int child)
        {
            var ret = Create(cx, d, type, parent, child);
            cx.Try(d, null, () =>
            {
                var declSymbol = cx.GetModel(d).GetDeclaredSymbol(d);
                var localVar = LocalVariable.Create(cx, declSymbol);
                localVar.PopulateManual(ret, isVar);

                if (d.Initializer != null)
                {
                    Create(cx, d.Initializer.Value, ret, 0);

                    // Create an access
                    var access = new Expression(new ExpressionInfo(cx, type, localVar.Location, ExprKind.LOCAL_VARIABLE_ACCESS, ret, 1, false, null));
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
            var type = Type.Create(cx, cx.GetType(decl.Type));

            foreach (var v in decl.Variables)
            {
                VariableDeclaration.CreateDeclarator(cx, v, type, decl.Type.IsVar, parent, child);
                child += childIncrement;
            }
        }
    }
}
