using System.IO; // lgtm[cs/similar-file]
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class TypeOf : Expression<TypeOfExpressionSyntax>
    {
        private const int TypeAccessIndex = 0;

        private TypeOf(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.TYPEOF)) { }

        public static Expression Create(ExpressionNodeInfo info) => new TypeOf(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            TypeAccess.Create(Context, Syntax.Type, this, TypeAccessIndex);
        }

        public static Expression CreateGenerated(Context cx, IExpressionParentEntity parent, int childIndex, Microsoft.CodeAnalysis.ITypeSymbol type, Location location)
        {
            var info = new ExpressionInfo(
                cx,
                AnnotatedTypeSymbol.CreateNotAnnotated(type),
                location,
                ExprKind.TYPEOF,
                parent,
                childIndex,
                isCompilerGenerated: true,
                null);

            var ret = new Expression(info);

            TypeAccess.CreateGenerated(cx, ret, TypeOf.TypeAccessIndex, type, location);

            return ret;
        }
    }
}
