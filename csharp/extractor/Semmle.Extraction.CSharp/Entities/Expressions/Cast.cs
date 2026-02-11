using System;
using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class Cast : Expression<CastExpressionSyntax>
    {
        private const int ExpressionIndex = 0;
        private const int TypeAccessIndex = 1;

        private Cast(ExpressionNodeInfo info) : base(info.SetKind(UnaryOperatorKind(info.Context, ExprKind.CAST, info.Node))) { }

        public static Expression Create(ExpressionNodeInfo info) => new Cast(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(Context, Syntax.Expression, this, ExpressionIndex);

            if (Kind == ExprKind.CAST)
            {  // Type cast
                TypeAccess.Create(new ExpressionNodeInfo(Context, Syntax.Type, this, TypeAccessIndex));
            }
            else
            {
                // Type conversion
                OperatorCall(trapFile, Syntax);
                TypeMention.Create(Context, Syntax.Type, this, Type);
            }
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => Syntax.GetLocation();

        public static Expression CreateGenerated(Context cx, IExpressionParentEntity parent, int childIndex, Microsoft.CodeAnalysis.ITypeSymbol type, object? value, Action<Expression, int> createChild, Location location)
        {
            var info = new ExpressionInfo(
                cx,
                AnnotatedTypeSymbol.CreateNotAnnotated(type),
                location,
                ExprKind.CAST,
                parent,
                childIndex,
                isCompilerGenerated: true,
                ValueAsString(value));

            var ret = new Expression(info);

            createChild(ret, ExpressionIndex);

            TypeAccess.CreateGenerated(cx, ret, TypeAccessIndex, type, location);

            return ret;
        }
    }
}
