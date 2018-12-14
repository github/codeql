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
                return new VariableDeclaration(cx, node, null, isVar, parent, child);
            }

            var type = Type.Create(cx, variableSymbol.Type);
            var location = cx.Create(designation.GetLocation());

            var ret = new VariableDeclaration(cx, designation, type, isVar, parent, child);
            cx.Try(null, null, () => LocalVariable.Create(cx, variableSymbol, ret, isVar, location));
            return ret;
        }

        /// <summary>
        /// Create a tuple expression representing a parenthesized variable declaration.
        /// That is, we consider `var (x, y) = ...` to be equivalent to `(var x, var y) = ...`.
        /// </summary>
        static Expression CreateParenthesized(Context cx, DeclarationExpressionSyntax node, ParenthesizedVariableDesignationSyntax designation, IExpressionParentEntity parent, int child)
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

        static Expression Create(Context cx, DeclarationExpressionSyntax node, VariableDesignationSyntax designation, IExpressionParentEntity parent, int child)
        {
            var single = designation as SingleVariableDesignationSyntax;
            if (single != null)
                return CreateSingle(cx, node, single, parent, child);

            var paren = designation as ParenthesizedVariableDesignationSyntax;
            if (paren != null)
                return CreateParenthesized(cx, node, paren, parent, child);

            var discard = designation as DiscardDesignationSyntax;
            if (discard != null)
            {
                var type = cx.Model(node).GetTypeInfo(node).Type;
                return new VariableDeclaration(cx, node, Type.Create(cx, type), node.Type.IsVar, parent, child);
            }

            cx.ModelError(node, "Failed to determine designation type");
            return new VariableDeclaration(cx, node, null, node.Type.IsVar, parent, child);
        }

        public static Expression Create(Context cx, DeclarationExpressionSyntax node, IExpressionParentEntity parent, int child)
        {
            return Create(cx, node, node.Designation, parent, child);
        }

        VariableDeclaration(Context cx, CSharpSyntaxNode d, Type type, bool isVar, IExpressionParentEntity parent, int child)
            : base(new ExpressionInfo(cx, type, cx.Create(d.FixedLocation()), ExprKind.LOCAL_VAR_DECL, parent, child, false, null))
        {
        }

        public static VariableDeclaration Create(Context cx, CatchDeclarationSyntax d, bool isVar, IExpressionParentEntity parent, int child)
        {
            var type = Type.Create(cx, cx.Model(d).GetDeclaredSymbol(d).Type);
            var ret = new VariableDeclaration(cx, d, type, isVar, parent, child);
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

        public static VariableDeclaration Create(Context cx, VariableDeclaratorSyntax d, Type type, bool isVar, IExpressionParentEntity parent, int child)
        {
            var ret = new VariableDeclaration(cx, d, type, isVar, parent, child);
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
                VariableDeclaration.Create(cx, v, type, decl.Type.IsVar, parent, child);
                child += childIncrement;
            }
        }
    }
}
