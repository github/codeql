using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Populators;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities
{
    /// <summary>
    /// Expression information constructed from a syntax node.
    /// </summary>
    internal class ExpressionNodeInfo : IExpressionInfo
    {
        public ExpressionNodeInfo(Context cx, ExpressionSyntax node, IExpressionParentEntity parent, int child) :
            this(cx, node, parent, child, cx.GetTypeInfo(node))
        {
        }

        public ExpressionNodeInfo(Context cx, ExpressionSyntax node, IExpressionParentEntity parent, int child, TypeInfo typeInfo)
        {
            Context = cx;
            Node = node;
            Parent = parent;
            Child = child;
            TypeInfo = typeInfo;
            Conversion = cx.GetModel(node).GetConversion(node);
        }

        public Context Context { get; }
        public ExpressionSyntax Node { get; private set; }
        public IExpressionParentEntity Parent { get; set; }
        public int Child { get; set; }
        public TypeInfo TypeInfo { get; }
        public Microsoft.CodeAnalysis.CSharp.Conversion Conversion { get; }

        public AnnotatedTypeSymbol ResolvedType => new AnnotatedTypeSymbol(TypeInfo.Type.DisambiguateType(), TypeInfo.Nullability.Annotation);
        public AnnotatedTypeSymbol ConvertedType => new AnnotatedTypeSymbol(TypeInfo.ConvertedType.DisambiguateType(), TypeInfo.ConvertedNullability.Annotation);

        private AnnotatedTypeSymbol? cachedType;
        private bool cachedTypeSet;
        public AnnotatedTypeSymbol? Type
        {
            get
            {
                if (cachedTypeSet)
                    return cachedType;

                var type = ResolvedType;

                if (type.Symbol is null)
                    type.Symbol = (TypeInfo.Type ?? TypeInfo.ConvertedType).DisambiguateType();

                // Roslyn workaround: It can't work out the type of "new object[0]"
                // Clearly a bug.
                if (type.Symbol?.TypeKind == Microsoft.CodeAnalysis.TypeKind.Error)
                {
                    if (Node is ArrayCreationExpressionSyntax arrayCreation)
                    {
                        var elementType = Context.GetType(arrayCreation.Type.ElementType);

                        if (elementType.Symbol is not null)
                            // There seems to be no way to create an array with a nullable element at present.
                            return new AnnotatedTypeSymbol(Context.Compilation.CreateArrayTypeSymbol(elementType.Symbol, arrayCreation.Type.RankSpecifiers.Count), NullableAnnotation.NotAnnotated);
                    }

                    Context.ModelError(Node, "Failed to determine type");
                }

                cachedType = type;
                cachedTypeSet = true;

                return type;
            }
        }

        private Microsoft.CodeAnalysis.Location? location;

        public Microsoft.CodeAnalysis.Location CodeAnalysisLocation
        {
            get
            {
                if (location is null)
                    location = Node.FixedLocation();
                return location;
            }
            set
            {
                location = value;
            }
        }

        public SemanticModel Model => Context.GetModel(Node);

        public string? ExprValue
        {
            get
            {
                var c = Model.GetConstantValue(Node);
                if (c.HasValue)
                {
                    return Expression.ValueAsString(c.Value);
                }

                if (TryGetBoolValueFromLiteral(out var val))
                {
                    return Expression.ValueAsString(val);
                }

                if (TryGetStringValueFromUtf8Literal(out var s))
                {
                    return s;
                }

                return null;
            }
        }

        private Location? cachedLocation;

        public Location Location
        {
            get
            {
                if (cachedLocation is null)
                    cachedLocation = Context.CreateLocation(CodeAnalysisLocation);
                return cachedLocation;
            }
        }

        public ExprKind Kind { get; set; } = ExprKind.UNKNOWN;

        public bool IsCompilerGenerated { get; init; }

        /// <summary>
        /// Whether the expression should have a compiler generated `ToString` call added,
        /// if there is no suitable implicit cast.
        /// </summary>
        public bool ImplicitToString { get; private set; }

        public ExpressionNodeInfo SetParent(IExpressionParentEntity parent, int child)
        {
            Parent = parent;
            Child = child;
            return this;
        }

        public ExpressionNodeInfo SetKind(ExprKind kind)
        {
            Kind = kind;
            return this;
        }

        public ExpressionNodeInfo SetType(AnnotatedTypeSymbol? type)
        {
            cachedType = type;
            cachedTypeSet = true;
            return this;
        }

        public ExpressionNodeInfo SetNode(ExpressionSyntax node)
        {
            Node = node;
            return this;
        }

        public ExpressionNodeInfo SetImplicitToString(bool value)
        {
            ImplicitToString = value;
            return this;
        }

        private SymbolInfo cachedSymbolInfo;

        public SymbolInfo SymbolInfo
        {
            get
            {
                if (cachedSymbolInfo.Symbol is null && cachedSymbolInfo.CandidateReason == CandidateReason.None)
                    cachedSymbolInfo = Model.GetSymbolInfo(Node);
                return cachedSymbolInfo;
            }
        }

        public NullableFlowState FlowState => TypeInfo.Nullability.FlowState;

        private bool TryGetBoolValueFromLiteral(out bool val)
        {
            var isTrue = Node.IsKind(SyntaxKind.TrueLiteralExpression);
            var isFalse = Node.IsKind(SyntaxKind.FalseLiteralExpression);

            val = isTrue;
            return isTrue || isFalse;
        }

        private bool TryGetStringValueFromUtf8Literal(out string? value)
        {
            value = null;
            if (Node.IsKind(SyntaxKind.Utf8StringLiteralExpression) && Node is LiteralExpressionSyntax literal)
            {
                value = literal.Token.ValueText;
                return true;
            }
            return false;
        }

        public bool IsBoolLiteral()
        {
            return TryGetBoolValueFromLiteral(out _);
        }
    }
}
