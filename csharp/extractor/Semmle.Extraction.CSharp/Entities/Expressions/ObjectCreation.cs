using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Populators;
using Semmle.Extraction.Entities;
using Semmle.Extraction.Kinds;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    abstract class ObjectCreation<TSyntaxNode> : Expression<TSyntaxNode> where TSyntaxNode : ExpressionSyntax
    {
        protected ObjectCreation(ExpressionNodeInfo info)
            : base(info) { }
    }

    // new Foo(...) { ... }.
    class ExplicitObjectCreation : ObjectCreation<ObjectCreationExpressionSyntax>
    {
        static bool IsDynamicObjectCreation(Context cx, ObjectCreationExpressionSyntax node)
        {
            return node.ArgumentList != null && node.ArgumentList.Arguments.Any(arg => IsDynamic(cx, arg.Expression));
        }

        static ExprKind GetKind(Context cx, ObjectCreationExpressionSyntax node)
        {
            var si = cx.GetModel(node).GetSymbolInfo(node.Type);
            return Entities.Type.IsDelegate(si.Symbol as INamedTypeSymbol) ? ExprKind.EXPLICIT_DELEGATE_CREATION : ExprKind.OBJECT_CREATION;
        }

        ExplicitObjectCreation(ExpressionNodeInfo info)
            : base(info.SetKind(GetKind(info.Context, (ObjectCreationExpressionSyntax)info.Node))) { }

        public static Expression Create(ExpressionNodeInfo info) => new ExplicitObjectCreation(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            if (Syntax.ArgumentList != null)
            {
                PopulateArguments(trapFile, Syntax.ArgumentList, 0);
            }

            var target = Cx.GetModel(Syntax).GetSymbolInfo(Syntax);
            var method = (IMethodSymbol)target.Symbol;

            if (method != null)
            {
                trapFile.expr_call(this, Method.Create(Cx, method));
            }

            if (IsDynamicObjectCreation(Cx, Syntax))
            {
                var name = GetDynamicName(Syntax.Type);
                if (name.HasValue)
                    trapFile.dynamic_member_name(this, name.Value.Text);
                else
                    Cx.ModelError(Syntax, "Unable to get name for dynamic object creation.");
            }

            if (Syntax.Initializer != null)
            {
                switch (Syntax.Initializer.Kind())
                {
                    case SyntaxKind.CollectionInitializerExpression:
                        CollectionInitializer.Create(new ExpressionNodeInfo(Cx, Syntax.Initializer, this, -1) { Type = Type });
                        break;
                    case SyntaxKind.ObjectInitializerExpression:
                        ObjectInitializer.Create(new ExpressionNodeInfo(Cx, Syntax.Initializer, this, -1) { Type = Type });
                        break;
                    default:
                        Cx.ModelError("Unhandled initializer in object creation");
                        break;
                }
            }

            TypeMention.Create(Cx, Syntax.Type, this, Type);
        }

        static SyntaxToken? GetDynamicName(CSharpSyntaxNode name)
        {
            switch (name.Kind())
            {
                case SyntaxKind.IdentifierName:
                    return ((IdentifierNameSyntax)name).Identifier;
                case SyntaxKind.GenericName:
                    return ((GenericNameSyntax)name).Identifier;
                case SyntaxKind.QualifiedName:
                    // We ignore any qualifiers, for now
                    return GetDynamicName(((QualifiedNameSyntax)name).Right);
                default:
                    return null;
            }
        }
    }

    class ImplicitObjectCreation : ObjectCreation<AnonymousObjectCreationExpressionSyntax>
    {
        public ImplicitObjectCreation(ExpressionNodeInfo info)
            : base(info.SetKind(ExprKind.OBJECT_CREATION)) { }

        public static Expression Create(ExpressionNodeInfo info) =>
            new ImplicitObjectCreation(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            var target = Cx.GetSymbolInfo(Syntax);
            var method = (IMethodSymbol)target.Symbol;

            if (method != null)
            {
                trapFile.expr_call(this, Method.Create(Cx, method));
            }
            var child = 0;

            var objectInitializer = Syntax.Initializers.Any() ?
                new Expression(new ExpressionInfo(Cx, Type, Location, ExprKind.OBJECT_INIT, this, -1, false, null)) :
                null;

            foreach (var init in Syntax.Initializers)
            {
                // Create an "assignment"
                var property = Cx.GetModel(init).GetDeclaredSymbol(init);
                var propEntity = Property.Create(Cx, property);
                var type = Entities.Type.Create(Cx, property.GetAnnotatedType());
                var loc = Cx.Create(init.GetLocation());

                var assignment = new Expression(new ExpressionInfo(Cx, type, loc, ExprKind.SIMPLE_ASSIGN, objectInitializer, child++, false, null));
                Create(Cx, init.Expression, assignment, 0);
                Property.Create(Cx, property);

                var access = new Expression(new ExpressionInfo(Cx, type, loc, ExprKind.PROPERTY_ACCESS, assignment, 1, false, null));
                trapFile.expr_access(access, propEntity);
            }
        }
    }
}
