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

        private Expression MakeSubtractionExpression(IExpressionParentEntity parent, int child)
        {
            var info = new ExpressionInfo(
                                Context,
                                AnnotatedTypeSymbol.CreateNotAnnotated(Context.Compilation.GetSpecialType(SpecialType.System_Int32)),
                                Location,
                                ExprKind.SUB,
                                parent,
                                child,
                                isCompilerGenerated: true,
                                null);

            return new Expression(info);
        }

        private Expression MakeLengthPropertyCall(TextWriter trapFile, IPropertySymbol lengthPropertySymbol, IExpressionParentEntity parent, int child)
        {
            var lengthInfo = new ExpressionInfo(
                    Context,
                    AnnotatedTypeSymbol.CreateNotAnnotated(Context.Compilation.GetSpecialType(SpecialType.System_Int32)),
                    Location,
                    ExprKind.PROPERTY_ACCESS,
                    parent,
                    child,
                    isCompilerGenerated: true,
                    null);
            var length = new Expression(lengthInfo);
            Create(Context, qualifier, length, -1);

            var lengthProp = Property.Create(Context, lengthPropertySymbol);
            trapFile.expr_access(length, lengthProp);
            return length;
        }

        private Expression CreateFromIndexExpression(TextWriter trapFile, IPropertySymbol lengthPropertySymbol, IExpressionParentEntity parent, int child, PrefixUnaryExpressionSyntax index)
        {
            var sub = MakeSubtractionExpression(parent, child);
            MakeLengthPropertyCall(trapFile, lengthPropertySymbol, sub, 0);
            var info = new ExpressionNodeInfo(Context, index.Operand, sub, 1)
            {
                IsCompilerGenerated = true
            };
            Factory.Create(info);
            return sub;
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
        private Expression CreateFromRangeEndpoint(TextWriter trapFile, IPropertySymbol lengthPropertySymbol, ExpressionSyntax syntax, IExpressionParentEntity parent, int child)
        {
            if (syntax.Kind() == SyntaxKind.IndexExpression && syntax is PrefixUnaryExpressionSyntax index)
            {
                return CreateFromIndexExpression(trapFile, lengthPropertySymbol, parent, child, index);
            }

            var info = new ExpressionNodeInfo(Context, syntax, parent, child)
            {
                IsCompilerGenerated = true
            };
            return Factory.Create(info);
        }

        /// <summary>
        /// Determines whether the given method is a slice method, which is defined as a method with
        /// the name "Slice" or "SubString" and two parameters.
        /// </summary> <param name="method">The method symbol to check.</param>
        /// <returns>True if the method is a slice method, false otherwise.</returns>
        private bool IsSliceWithRange(IMethodSymbol method, [NotNullWhen(true)] out IPropertySymbol? lengthPropertySymbol, [NotNullWhen(true)] out RangeExpressionSyntax? range)
        {
            range = null;
            lengthPropertySymbol = method
                .ContainingType
                .GetMembers("Length")
                .OfType<IPropertySymbol>()
                .FirstOrDefault();

            if (argumentList.Arguments.Count == 1)
            {
                range = argumentList.Arguments[0].Expression as RangeExpressionSyntax;
            }

            return (method.Name == "Slice" || method.Name == "Substring")
                && method.Parameters.Length == 2
                && lengthPropertySymbol is not null
                && range is not null;
        }

        /// <summary>
        /// Populates a slice method call based on the given range and length property symbol.
        /// </summary>
        /// <param name="trapFile">The trap file to write to.</param>
        /// <param name="lengthPropertySymbol">The length property symbol.</param>
        /// <param name="slice">The slice method symbol.</param>
        /// <param name="range">The range expression syntax.</param>
        private void PopulateSlice(TextWriter trapFile, IPropertySymbol lengthPropertySymbol, IMethodSymbol slice, RangeExpressionSyntax range)
        {
            // 1. s[a..b] -> s.Slice(a, b - a)
            // 2. s[..b] -> s.Slice(0, b)
            // 3. s[a..] -> s.Slice(a, s.Length - a)
            // 4. s[..] -> s.Slice(0, s.Length)
            // Furthermore, note that uses of index expressions (e.g. s[2..^1]) within the range 
            // get translated to length - index, so we need to handle this as well.
            switch (range.LeftOperand, range.RightOperand)
            {
                case (ExpressionSyntax lsyntax, ExpressionSyntax rsyntax):
                    {
                        var left = CreateFromRangeEndpoint(trapFile, lengthPropertySymbol, lsyntax, this, 0);
                        var right = MakeSubtractionExpression(this, 1);

                        CreateFromRangeEndpoint(trapFile, lengthPropertySymbol, rsyntax, right, 0);
                        CreateFromRangeEndpoint(trapFile, lengthPropertySymbol, lsyntax, right, 1);
                        SetExprArgument(trapFile, left, right);
                        break;
                    }
                case (null, ExpressionSyntax rsyntax):
                    {
                        var left = Literal.CreateGenerated(Context, this, 0, Context.Compilation.GetSpecialType(SpecialType.System_Int32), 0, Location);
                        var right = CreateFromRangeEndpoint(trapFile, lengthPropertySymbol, rsyntax, this, 1);
                        SetExprArgument(trapFile, left, right);
                        break;
                    }
                case (ExpressionSyntax lsyntax, null):
                    {

                        var left = CreateFromRangeEndpoint(trapFile, lengthPropertySymbol, lsyntax, this, 0);
                        var right = MakeSubtractionExpression(this, 1);
                        MakeLengthPropertyCall(trapFile, lengthPropertySymbol, right, 0);
                        CreateFromRangeEndpoint(trapFile, lengthPropertySymbol, lsyntax, right, 1);
                        SetExprArgument(trapFile, left, right);
                        break;
                    }
                case (null, null):
                    {
                        var left = Literal.CreateGenerated(Context, this, 0, Context.Compilation.GetSpecialType(SpecialType.System_Int32), 0, Location);
                        var right = MakeLengthPropertyCall(trapFile, lengthPropertySymbol, this, 1);
                        SetExprArgument(trapFile, left, right);
                        break;
                    }
            }

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
                if (target is IMethodSymbol method && IsSliceWithRange(method, out var lengthPropertySymbol, out var range))
                {
                    // When an indexer on a span or string is used in conjunction with a range expression, the compiler translates
                    // this into a call to the "Slice" or "Substring" method.
                    // In this case, we want to populate a slice/substring method call instead of an indexer access.
                    // E.g s[1..4] gets translated to s.Slice(1, 4 - 1) if s is a span.
                    PopulateSlice(trapFile, lengthPropertySymbol, method, range);
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
