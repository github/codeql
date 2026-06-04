using System.Diagnostics.CodeAnalysis;
using System.IO;
using System.Linq;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal abstract class ElementAccess : Expression<ExpressionSyntax>
    {
        protected ElementAccess(ExpressionNodeInfo info, ExpressionSyntax qualifier, BracketedArgumentListSyntax argumentList)
            : base(info.SetKind(GetKind(info.Context, info.Node, qualifier)))
        {
            this.qualifier = qualifier;
            this.argumentList = argumentList;
        }

        private readonly ExpressionSyntax qualifier;
        private readonly BracketedArgumentListSyntax argumentList;


        private ISymbol? GetTargetSymbol()
        {
            return Context.GetSymbolInfo(base.Syntax).Symbol;
        }

        private static void SetExprArgument(TextWriter trapFile, Expression left, Expression right)
        {
            trapFile.expr_argument(left, 0);
            trapFile.expr_argument(right, 0);
        }

        private Expression MakeZeroFromEndExpression(IExpressionParentEntity parent, int child)
        {
            var info = new ExpressionInfo(
                                Context,
                                AnnotatedTypeSymbol.CreateNotAnnotated(Context.Compilation.GetSpecialType(SpecialType.System_Int32)),
                                Location,
                                ExprKind.INDEX,
                                parent,
                                child,
                                isCompilerGenerated: true,
                                null);

            var index = new Expression(info);

            MakeZeroLiteral(index, 0);
            return index;
        }

        private Expression MakeZeroLiteral(IExpressionParentEntity parent, int child)
        {
            return Literal.CreateGenerated(Context, parent, child, Context.Compilation.GetSpecialType(SpecialType.System_Int32), 0, Location);
        }


        /// <summary>
        /// It is assumed that either the input is
        /// 1. A normal expression that can be used as endpoint (e.g a constant like "3").
        /// 2. An index expression indicating that we should read from the end (e.g "^1").
        /// </summary>
        /// <param name="syntax">The syntax node representing the range endpoint.</param>
        /// <param name="parent">The parent expression entity.</param>
        /// <param name="child">The child index within the parent.</param>
        /// <returns>An expression representing the endpoint of a range to be used in conjunction with a slice operation.</returns>
        private Expression MakeFromRangeEndpoint(ExpressionSyntax syntax, IExpressionParentEntity parent, int child)
        {
            var info = new ExpressionNodeInfo(Context, syntax, parent, child)
            {
                IsCompilerGenerated = true
            };

            return syntax.Kind() == SyntaxKind.IndexExpression
                ? PrefixUnary.Create(info.SetKind(ExprKind.INDEX))
                : Factory.Create(info);
        }

        /// <summary>
        /// Determines whether the given method is a slice method, which is defined as a method with
        /// the name "Slice" or "Substring" and two parameters.
        /// </summary>
        /// <param name="method">The method symbol to check.</param>
        /// <returns>True if the method is a slice method; false otherwise.</returns>
        private bool IsSliceWithRange(IMethodSymbol method, [NotNullWhen(true)] out RangeExpressionSyntax? range)
        {
            range = null;

            if (argumentList.Arguments.Count == 1)
            {
                range = argumentList.Arguments[0].Expression as RangeExpressionSyntax;
            }

            return (method.Name == "Slice" || method.Name == "Substring")
                && method.Parameters.Length == 2
                && range is not null;
        }

        /// <summary>
        /// Populates a slice method call based on the given range.
        /// Roslyn translates indexer accesses with range expressions in the following way.
        ///   1. s[a..b] -> s.Slice(a, b - a)
        ///   2. s[..b] -> s.Slice(0, b)
        ///   3. s[a..] -> s.Slice(a, s.Length - a)
        ///   4. s[..] -> s.Slice(0, s.Length)
        /// However, it is possible that both the qualifier or the index endpoints may contain method calls.
        /// If we want to translate this accurately, we would need to introduce synthetic statements for qualifier and 
        /// the endpoints, which should then be used in the slice method call.
        /// To avoid this, we translate as follows.
        /// 1. s[a..b] -> s.Slice(a, b)
        /// 2. s[..b] -> s.Slice(0, b)
        /// 3. s[a..] -> s.Slice(a, ^0)
        /// 4. s[..] -> s.Slice(0, ^0)
        /// 
        /// Even though index expressions can't technically be used in this way, they signal that we
        /// could perceive ^b as "length - b".
        /// </summary>
        /// <param name="trapFile">The trap file to write to.</param>
        /// <param name="slice">The slice method symbol.</param>
        /// <param name="range">The range expression syntax.</param>
        private void PopulateSlice(TextWriter trapFile, IMethodSymbol slice, RangeExpressionSyntax range)
        {
            var left = range.LeftOperand is ExpressionSyntax lsyntax
                ? MakeFromRangeEndpoint(lsyntax, this, 0)
                : MakeZeroLiteral(this, 0);

            var right = range.RightOperand is ExpressionSyntax rsyntax
                ? MakeFromRangeEndpoint(rsyntax, this, 1)
                : MakeZeroFromEndExpression(this, 1);

            SetExprArgument(trapFile, left, right);
            trapFile.expr_call(this, Method.Create(Context, slice));
        }

        protected override void PopulateExpression(TextWriter trapFile)
        {
            if (Kind == ExprKind.POINTER_INDIRECTION)
            {
                var qualifierInfo = new ExpressionNodeInfo(Context, qualifier, this, 0);
                var add = new Expression(new ExpressionInfo(Context, qualifierInfo.Type, Location, ExprKind.ADD, this, 0, isCompilerGenerated: false, null));
                qualifierInfo.SetParent(add, 0);
                CreateFromNode(qualifierInfo);
                PopulateArguments(trapFile, argumentList, 1);
            }
            else
            {
                Create(Context, qualifier, this, -1);

                var target = GetTargetSymbol();
                if (target is IMethodSymbol method && IsSliceWithRange(method, out var range))
                {
                    // When an indexer on a span or string is used in conjunction with a range expression, the compiler translates
                    // this into a call to the "Slice" or "Substring" method.
                    // In this case, we want to populate a slice/substring method call instead of an indexer access.
                    PopulateSlice(trapFile, method, range);
                    return;
                }

                PopulateArguments(trapFile, argumentList, 0);
                if (target is IPropertySymbol { IsIndexer: true } indexer)
                {
                    trapFile.expr_access(this, Indexer.Create(Context, indexer));
                }
            }
        }

        public sealed override Microsoft.CodeAnalysis.Location? ReportingLocation => base.ReportingLocation;

        private static bool IsArray(ITypeSymbol symbol) =>
            symbol.TypeKind == Microsoft.CodeAnalysis.TypeKind.Array || symbol.IsInlineArray();

        private static ExprKind GetKind(Context cx, ExpressionSyntax syntax, ExpressionSyntax qualifier)
        {
            if (cx.GetSymbolInfo(syntax).Symbol is IMethodSymbol)
                return ExprKind.METHOD_INVOCATION;

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
                : IsArray(qualifierType.Symbol)
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
            : base(info, FindConditionalQualifier(info.Node), ((ElementBindingExpressionSyntax)info.Node).ArgumentList)
        {
        }

        public static Expression Create(ExpressionNodeInfo info) => new BindingElementAccess(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            base.PopulateExpression(trapFile);
            MakeConditional(trapFile);
        }
    }
}
