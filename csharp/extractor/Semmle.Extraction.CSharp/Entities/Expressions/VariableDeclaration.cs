using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Populators;
using Semmle.Extraction.Kinds;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class VariableDeclaration : Expression
    {
        VariableDeclaration(IExpressionInfo info) : base(info) { }

        public static VariableDeclaration Create(Context cx, ISymbol symbol, Type type, Extraction.Entities.Location exprLocation, Extraction.Entities.Location declLocation, bool isVar, IExpressionParentEntity parent, int child)
        {
            var ret = new VariableDeclaration(new ExpressionInfo(cx, type, exprLocation, ExprKind.LOCAL_VAR_DECL, parent, child, false, null));
            cx.Try(null, null, () => LocalVariable.Create(cx, symbol, ret, isVar, declLocation));
            return ret;
        }

        static VariableDeclaration CreateSingle(Context cx, DeclarationExpressionSyntax node, SingleVariableDesignationSyntax designation, IExpressionParentEntity parent, int child)
        {
            bool isVar = node.Type.IsVar;

            var variableSymbol = cx.Model(designation).GetDeclaredSymbol(designation) as ILocalSymbol;
            if (variableSymbol == null)
            {
                cx.ModelError(node, "Failed to determine local variable");
                return Create(cx, node, null, isVar, parent, child);
            }

            var type = Type.Create(cx, variableSymbol.Type);
            var location = cx.Create(designation.GetLocation());

            var ret = Create(cx, designation, type, isVar, parent, child);
            cx.Try(null, null, () => LocalVariable.Create(cx, variableSymbol, ret, isVar, location));
            return ret;
        }

        /// <summary>
        /// Create a tuple expression representing a parenthesized variable declaration.
        /// That is, we consider `var (x, y) = ...` to be equivalent to `(var x, var y) = ...`.
        /// </summary>
        public static Expression CreateParenthesized(Context cx, DeclarationExpressionSyntax node, ParenthesizedVariableDesignationSyntax designation, IExpressionParentEntity parent, int child)
        {
            var type = Type.Create(cx, null); // Should ideally be a corresponding tuple type
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
            var type = Type.Create(cx, null); // Should ideally be a corresponding tuple type
            var tuple = new Expression(new ExpressionInfo(cx, type, cx.Create(varPattern.GetLocation()), ExprKind.TUPLE, parent, child, false, null));

            cx.Try(null, null, () =>
            {
                var child0 = 0;
                foreach (var variable in designation.Variables)
                    switch(variable)
                    {
                        case ParenthesizedVariableDesignationSyntax paren:
                            CreateParenthesized(cx, varPattern, paren, tuple, child0++);
                            break;
                        case SingleVariableDesignationSyntax single:
                            if (cx.Model(variable).GetDeclaredSymbol(single) is ILocalSymbol local)
                            {
                                var decl = Create(cx, variable, Type.Create(cx, local.Type), true, tuple, child0++);
                                var id = single.Identifier;
                                var declSymbol = cx.Model(single).GetDeclaredSymbol(single);
                                var location = cx.Create(id.GetLocation());
                                LocalVariable.Create(cx, local, decl, true, location);
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
            });

            return tuple;
        }


        static Expression Create(Context cx, DeclarationExpressionSyntax node, VariableDesignationSyntax designation, IExpressionParentEntity parent, int child)
        {
            switch(designation)
            {
                case SingleVariableDesignationSyntax single:
                    return CreateSingle(cx, node, single, parent, child);
                case ParenthesizedVariableDesignationSyntax paren:
                    return CreateParenthesized(cx, node, paren, parent, child);
                case DiscardDesignationSyntax discard:
                    var type = cx.Model(discard).GetTypeInfo(discard).Type;
                    return Create(cx, node, Type.Create(cx, type), node.Type.IsVar, parent, child);
                default:
                    cx.ModelError(node, "Failed to determine designation type");
                    return Create(cx, node, null, node.Type.IsVar, parent, child);
            }
        }

        public static Expression Create(Context cx, DeclarationExpressionSyntax node, IExpressionParentEntity parent, int child) =>
            Create(cx, node, node.Designation, parent, child);

        public static VariableDeclaration Create(Context cx, CSharpSyntaxNode c, Type type, bool isVar, IExpressionParentEntity parent, int child) =>
            new VariableDeclaration(new ExpressionInfo(cx, type, cx.Create(c.FixedLocation()), ExprKind.LOCAL_VAR_DECL, parent, child, false, null));

        public static VariableDeclaration Create(Context cx, CatchDeclarationSyntax d, bool isVar, IExpressionParentEntity parent, int child)
        {
            var type = Type.Create(cx, cx.Model(d).GetDeclaredSymbol(d).Type);
            var ret = Create(cx, d, type, isVar, parent, child);
            cx.Try(d, null, () =>
            {
                var id = d.Identifier;
                var declSymbol = cx.Model(d).GetDeclaredSymbol(d);
                var location = cx.Create(id.GetLocation());
                LocalVariable.Create(cx, declSymbol, ret, isVar, location);
                TypeMention.Create(cx, d.Type, ret, type);
            });
            return ret;
        }

        public static VariableDeclaration CreateDeclarator(Context cx, VariableDeclaratorSyntax d, Type type, bool isVar, IExpressionParentEntity parent, int child)
        {
            var ret = Create(cx, d, type, isVar, parent, child);
            cx.Try(d, null, () =>
            {
                var id = d.Identifier;
                var declSymbol = cx.Model(d).GetDeclaredSymbol(d);
                var location = cx.Create(id.GetLocation());
                var localVar = LocalVariable.Create(cx, declSymbol, ret, isVar, location);

                if (d.Initializer != null)
                {
                    Create(cx, d.Initializer.Value, ret, 0);

                    // Create an access
                    var access = new Expression(new ExpressionInfo(cx, type, location, ExprKind.LOCAL_VARIABLE_ACCESS, ret, 1, false, null));
                    cx.Emit(Tuples.expr_access(access, localVar));
                }

                var decl = d.Parent as VariableDeclarationSyntax;
                if (decl != null)
                    TypeMention.Create(cx, decl.Type, ret, type);
            });
            return ret;
        }
    }

    static class VariableDeclarations
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
