using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class TypeAccess : Expression<ExpressionSyntax>
    {
        private TypeAccess(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.TYPE_ACCESS)) { }

        protected override void PopulateExpression(TextWriter trapFile)
        {
            switch (Syntax.Kind())
            {
                case SyntaxKind.SimpleMemberAccessExpression:
                    var maes = (MemberAccessExpressionSyntax)Syntax;
                    if (Type?.Symbol?.ContainingType is null)
                    {
                        // namespace qualifier
                        TypeMention.Create(Context, maes.Name, this, Type, Syntax.GetLocation());
                    }
                    else
                    {
                        // type qualifier
                        TypeMention.Create(Context, maes.Name, this, Type);
                        Create(Context, maes.Expression, this, -1);
                    }
                    return;
                default:
                    TypeMention.Create(Context, (TypeSyntax)Syntax, this, Type);
                    return;
            }
        }

        public static Expression Create(ExpressionNodeInfo info) => new TypeAccess(info).TryPopulate();

        public static Expression CreateGenerated(Context cx, IExpressionParentEntity parent, int childIndex, Microsoft.CodeAnalysis.ITypeSymbol type, Extraction.Entities.Location location)
        {
            var typeAccessInfo = new ExpressionInfo(
                cx,
                AnnotatedTypeSymbol.CreateNotAnnotated(type),
                location,
                ExprKind.TYPE_ACCESS,
                parent,
                childIndex,
                true,
                null);

            return new Expression(typeAccessInfo);
        }
    }
}
