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

        private Cast(ExpressionNodeInfo info) : base(info.SetKind(GetKind(info.Context, ExprKind.CAST, info.Node))) { }

        /// <summary>
        /// Adapt the operator kind depending on whether it's a dynamic call or a user-operator call.
        /// </summary>
        /// <param name="cx"></param>
        /// <param name="node"></param>
        /// <param name="originalKind"></param>
        /// <returns></returns>
        public static ExprKind GetKind(Context cx, ExprKind originalKind, ExpressionSyntax node) =>
            GetCallType(cx, node).AdjustKind(originalKind);

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
                AddOperatorCall(trapFile, Syntax);
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
