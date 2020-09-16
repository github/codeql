using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class TypeAccess : Expression<ExpressionSyntax>
    {
        TypeAccess(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.TYPE_ACCESS)) { }

        protected override void PopulateExpression(TextWriter trapFile)
        {
            switch (Syntax.Kind())
            {
                case SyntaxKind.SimpleMemberAccessExpression:
                    var maes = (MemberAccessExpressionSyntax)Syntax;
                    if (Type.Type.ContainingType == null)
                    {
                        // namespace qualifier
                        TypeMention.Create(Cx, maes.Name, this, Type, Syntax.GetLocation());
                    }
                    else
                    {
                        // type qualifier
                        TypeMention.Create(Cx, maes.Name, this, Type);
                        Create(Cx, maes.Expression, this, -1);
                    }
                    return;
                default:
                    TypeMention.Create(Cx, (TypeSyntax)Syntax, this, Type);
                    return;
            }
        }

        public static Expression Create(ExpressionNodeInfo info) => new TypeAccess(info).TryPopulate();
    }
}

