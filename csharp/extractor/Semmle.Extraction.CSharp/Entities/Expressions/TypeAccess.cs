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
                    if (Type.Type.ContainingType == null)
                    {
                        // namespace qualifier
                        TypeMention.Create(cx, maes.Name, this, Type, Syntax.GetLocation());
                    }
                    else
                    {
                        // type qualifier
                        TypeMention.Create(cx, maes.Name, this, Type);
                        Create(cx, maes.Expression, this, -1);
                    }
                    return;
                default:
                    TypeMention.Create(cx, (TypeSyntax)Syntax, this, Type);
                    return;
            }
        }

        public static Expression Create(ExpressionNodeInfo info) => new TypeAccess(info).TryPopulate();
    }
}
