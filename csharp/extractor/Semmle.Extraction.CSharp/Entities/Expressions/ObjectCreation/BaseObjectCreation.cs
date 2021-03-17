using System.IO;
using System.Linq;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal abstract class BaseObjectCreation<TExpressionSyntax> : Expression<TExpressionSyntax>
        where TExpressionSyntax : BaseObjectCreationExpressionSyntax
    {
        protected BaseObjectCreation(ExpressionNodeInfo info)
            : base(info.SetKind(GetKind(info.Context, (BaseObjectCreationExpressionSyntax)info.Node)))
        {
        }

        protected override void PopulateExpression(TextWriter trapFile)
        {
            if (Syntax.ArgumentList is not null)
            {
                PopulateArguments(trapFile, Syntax.ArgumentList, 0);
            }

            var target = Context.GetModel(Syntax).GetSymbolInfo(Syntax);
            if (target.Symbol is IMethodSymbol method)
            {
                trapFile.expr_call(this, Method.Create(Context, method));
            }

            if (IsDynamicObjectCreation(Context, Syntax))
            {
                if (Context.GetModel(Syntax).GetTypeInfo(Syntax).Type is INamedTypeSymbol type &&
                    !string.IsNullOrEmpty(type.Name))
                {
                    trapFile.dynamic_member_name(this, type.Name);
                }
                else
                {
                    Context.ModelError(Syntax, "Unable to get name for dynamic object creation.");
                }
            }

            if (Syntax.Initializer is not null)
            {
                switch (Syntax.Initializer.Kind())
                {
                    case SyntaxKind.CollectionInitializerExpression:
                        CollectionInitializer.Create(new ExpressionNodeInfo(Context, Syntax.Initializer, this, -1).SetType(Type));
                        break;
                    case SyntaxKind.ObjectInitializerExpression:
                        ObjectInitializer.Create(new ExpressionNodeInfo(Context, Syntax.Initializer, this, -1).SetType(Type));
                        break;
                    default:
                        Context.ModelError(Syntax.Initializer, "Unhandled initializer in object creation");
                        break;
                }
            }
        }

        private static ExprKind GetKind(Context cx, BaseObjectCreationExpressionSyntax node)
        {
            var type = cx.GetModel(node).GetTypeInfo(node).Type;
            return Entities.Type.IsDelegate(type as INamedTypeSymbol)
                ? ExprKind.EXPLICIT_DELEGATE_CREATION
                : ExprKind.OBJECT_CREATION;
        }

        private static bool IsDynamicObjectCreation(Context cx, BaseObjectCreationExpressionSyntax node)
        {
            return node.ArgumentList is not null &&
                node.ArgumentList.Arguments.Any(arg => IsDynamic(cx, arg.Expression));
        }
    }
}
