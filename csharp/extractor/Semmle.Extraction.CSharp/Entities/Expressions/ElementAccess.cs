using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Populators;
using Semmle.Extraction.Kinds;
using Microsoft.CodeAnalysis;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal abstract class ElementAccess : Expression<ExpressionSyntax>
    {
        protected ElementAccess(ExpressionNodeInfo info, ExpressionSyntax qualifier, BracketedArgumentListSyntax argumentList)
            : base(info.SetKind(GetKind(info.Context, qualifier)))
        {
            this.qualifier = qualifier;
            this.argumentList = argumentList;
        }

        private readonly ExpressionSyntax qualifier;
        private readonly BracketedArgumentListSyntax argumentList;

        protected override void PopulateExpression(TextWriter trapFile)
        {
            if (Kind == ExprKind.POINTER_INDIRECTION)
            {
                var qualifierInfo = new ExpressionNodeInfo(Context, qualifier, this, 0);
                var add = new Expression(new ExpressionInfo(Context, qualifierInfo.Type, Location, ExprKind.ADD, this, 0, false, null));
                qualifierInfo.SetParent(add, 0);
                CreateFromNode(qualifierInfo);
                PopulateArguments(trapFile, argumentList, 1);
            }
            else
            {
                Create(Context, qualifier, this, -1);
                PopulateArguments(trapFile, argumentList, 0);

                var symbolInfo = Context.GetSymbolInfo(base.Syntax);

                if (symbolInfo.Symbol is IPropertySymbol indexer)
                {
                    trapFile.expr_access(this, Indexer.Create(Context, indexer));
                }
            }
        }

        public sealed override Microsoft.CodeAnalysis.Location? ReportingLocation => base.ReportingLocation;

        private static ExprKind GetKind(Context cx, ExpressionSyntax qualifier)
        {
            var qualifierType = cx.GetType(qualifier);

            // This is a compilation error, so make a guess and continue.
            if (qualifierType.Symbol is null)
                return ExprKind.ARRAY_ACCESS;

            if (qualifierType.Symbol.TypeKind == Microsoft.CodeAnalysis.TypeKind.Pointer)
            {
                // Convert expressions of the form a[b] into *(a+b)
                return ExprKind.POINTER_INDIRECTION;
            }

            return IsDynamic(cx, qualifier)
                ? ExprKind.DYNAMIC_ELEMENT_ACCESS
                : qualifierType.Symbol.TypeKind == Microsoft.CodeAnalysis.TypeKind.Array
                    ? ExprKind.ARRAY_ACCESS
                    : ExprKind.INDEXER_ACCESS;
        }
    }

    internal class NormalElementAccess : ElementAccess
    {
        private NormalElementAccess(ExpressionNodeInfo info)
            : base(info, ((ElementAccessExpressionSyntax)info.Node).Expression, ((ElementAccessExpressionSyntax)info.Node).ArgumentList) { }

        public static Expression Create(ExpressionNodeInfo info) => new NormalElementAccess(info).TryPopulate();
    }

    internal class BindingElementAccess : ElementAccess
    {
        private BindingElementAccess(ExpressionNodeInfo info)
            : base(info, FindConditionalQualifier(info.Node), ((ElementBindingExpressionSyntax)info.Node).ArgumentList) { }

        public static Expression Create(ExpressionNodeInfo info) => new BindingElementAccess(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            base.PopulateExpression(trapFile);
            MakeConditional(trapFile);
        }
    }
}
