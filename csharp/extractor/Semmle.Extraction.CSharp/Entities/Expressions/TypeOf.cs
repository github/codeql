using Microsoft.CodeAnalysis.CSharp.Syntax; // lgtm[cs/similar-file]
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class TypeOf : Expression<TypeOfExpressionSyntax>
    {
        private const int TypeAccessIndex = 0;

        private TypeOf(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.TYPEOF)) { }

        public static Expression Create(ExpressionNodeInfo info) => new TypeOf(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            TypeAccess.Create(cx, Syntax.Type, this, TypeAccessIndex);
        }

        public static Expression CreateGenerated(Context cx, IExpressionParentEntity parent, int childIndex, Microsoft.CodeAnalysis.ITypeSymbol type, Extraction.Entities.Location location)
        {
            var info = new ExpressionInfo(
                cx,
                new AnnotatedType(Entities.Type.Create(cx, type), Microsoft.CodeAnalysis.NullableAnnotation.None),
                location,
                ExprKind.TYPEOF,
                parent,
                childIndex,
                true,
                null);

            var ret = new Expression(info);

            TypeAccess.CreateGenerated(cx, ret, TypeOf.TypeAccessIndex, type, location);

            return ret;
        }
    }
}
