using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class Cast : Expression<CastExpressionSyntax>
    {
        public const int ExpressionIndex = 0;
        public const int TypeAccessIndex = 1;

        private Cast(ExpressionNodeInfo info) : base(info.SetKind(UnaryOperatorKind(info.Context, ExprKind.CAST, info.Node))) { }

        public static Expression Create(ExpressionNodeInfo info) => new Cast(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(cx, Syntax.Expression, this, ExpressionIndex);

            if (Kind == ExprKind.CAST)
            {  // Type cast
                TypeAccess.Create(new ExpressionNodeInfo(cx, Syntax.Type, this, TypeAccessIndex));
            }
            else
            {
                // Type conversion
                OperatorCall(trapFile, Syntax);
                TypeMention.Create(cx, Syntax.Type, this, Type);
            }
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => Syntax.GetLocation();

        public static Expression CreateGenerated(Context cx, IExpressionParentEntity parent, int childIndex, Microsoft.CodeAnalysis.ITypeSymbol type, object value)
        {
            var info = new ExpressionInfo(
                cx,
                new AnnotatedType(Entities.Type.Create(cx, type), Microsoft.CodeAnalysis.NullableAnnotation.None),
                Extraction.Entities.GeneratedLocation.Create(cx),
                ExprKind.CAST,
                parent,
                childIndex,
                true,
                ValueAsString(value));

            return new Expression(info);
        }
    }
}
