using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Entities.Expressions;
using Semmle.Extraction.CSharp.Populators;
using Semmle.Extraction.Entities;
using Semmle.Extraction.Kinds;
using System;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    public interface IExpressionParentEntity : IEntity
    {
        /// <summary>
        /// Whether this entity is the parent of a top-level expression.
        /// </summary>
        bool IsTopLevelParent { get; }
    }

    internal class Expression : FreshEntity, IExpressionParentEntity
    {
        private readonly IExpressionInfo info;
        public AnnotatedType Type { get; }
        public Extraction.Entities.Location Location { get; }
        public ExprKind Kind { get; }

        internal Expression(IExpressionInfo info)
            : base(info.Context)
        {
            this.info = info;
            Location = info.Location;
            Kind = info.Kind;
            Type = info.Type;
            if (Type.Type is null)
                Type = NullType.Create(cx);

            TryPopulate();
        }

        protected sealed override void Populate(TextWriter trapFile)
        {
            trapFile.expressions(this, Kind, Type.Type.TypeRef);
            if (info.Parent.IsTopLevelParent)
                trapFile.expr_parent_top_level(this, info.Child, info.Parent);
            else
                trapFile.expr_parent(this, info.Child, info.Parent);
            trapFile.expr_location(this, Location);

            var annotatedType = Type.Symbol;
            if (!annotatedType.HasObliviousNullability())
            {
                var n = NullabilityEntity.Create(cx, Nullability.Create(annotatedType));
                trapFile.type_nullability(this, n);
            }

            if (info.FlowState != NullableFlowState.None)
            {
                trapFile.expr_flowstate(this, (int)info.FlowState);
            }

            if (info.IsCompilerGenerated)
                trapFile.expr_compiler_generated(this);

            if (info.ExprValue is string value)
                trapFile.expr_value(this, value);

            Type.Type.PopulateGenerics();
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => Location.symbol;

        bool IExpressionParentEntity.IsTopLevelParent => false;

        /// <summary>
        /// Gets a string represention of a constant value.
        /// </summary>
        /// <param name="obj">The value.</param>
        /// <returns>The string representation.</returns>
        public static string ValueAsString(object value)
        {
            return value == null
                ? "null"
                : value is bool b
                    ? b
                        ? "true"
                        : "false"
                    : value.ToString();
        }

        /// <summary>
        /// Creates an expression from a syntax node.
        /// Inserts type conversion as required.
        /// </summary>
        /// <param name="cx">The extraction context.</param>
        /// <param name="node">The node to extract.</param>
        /// <param name="parent">The parent entity.</param>
        /// <param name="child">The child index.</param>
        /// <param name="type">A type hint.</param>
        /// <returns>The new expression.</returns>
        public static Expression Create(Context cx, ExpressionSyntax node, IExpressionParentEntity parent, int child) =>
            CreateFromNode(new ExpressionNodeInfo(cx, node, parent, child));

        public static Expression CreateFromNode(ExpressionNodeInfo info) => Expressions.ImplicitCast.Create(info);

        /// <summary>
        /// Creates an expression from a syntax node.
        /// Inserts type conversion as required.
        /// Population is deferred to avoid overflowing the stack.
        /// </summary>
        /// <param name="cx">The extraction context.</param>
        /// <param name="node">The node to extract.</param>
        /// <param name="parent">The parent entity.</param>
        /// <param name="child">The child index.</param>
        /// <param name="type">A type hint.</param>
        public static void CreateDeferred(Context cx, ExpressionSyntax node, IExpressionParentEntity parent, int child)
        {
            if (ContainsPattern(node))
                // Expressions with patterns should be created right away, as they may introduce
                // local variables referenced in `LocalVariable::GetAlreadyCreated()`
                Create(cx, node, parent, child);
            else
                cx.PopulateLater(() => Create(cx, node, parent, child));
        }

        private static bool ContainsPattern(SyntaxNode node) =>
            node is PatternSyntax || node is VariableDesignationSyntax || node.ChildNodes().Any(ContainsPattern);

        /// <summary>
        /// Creates a generated expression from a typed constant.
        /// </summary>
        public static Expression CreateGenerated(Context cx, TypedConstant constant, IExpressionParentEntity parent,
            int childIndex, Semmle.Extraction.Entities.Location location)
        {
            if (constant.IsNull)
            {
                return Literal.CreateGeneratedNullLiteral(cx, parent, childIndex, location);
            }

            switch (constant.Kind)
            {
                case TypedConstantKind.Primitive:
                    return Literal.CreateGenerated(cx, parent, childIndex, constant.Type, constant.Value, location);
                case TypedConstantKind.Enum:
                    // Enum value is generated in the following format: (Enum)value
                    Action<Expression, int> createChild = (parent, index) => Literal.CreateGenerated(cx, parent, index, ((INamedTypeSymbol)constant.Type).EnumUnderlyingType, constant.Value, location);
                    var cast = Cast.CreateGenerated(cx, parent, childIndex, constant.Type, constant.Value, createChild, location);
                    return cast;
                case TypedConstantKind.Type:
                    var type = ((ITypeSymbol)constant.Value).OriginalDefinition;
                    return TypeOf.CreateGenerated(cx, parent, childIndex, type, location);
                case TypedConstantKind.Array:
                    // Single dimensional arrays are in the following format:
                    // * new Type[N] { item1, item2, ..., itemN }
                    // * new Type[0]
                    //
                    // itemI is generated recursively.
                    return NormalArrayCreation.CreateGenerated(cx, parent, childIndex, constant.Type, constant.Values, location);
                default:
                    cx.ExtractionError("Couldn't extract constant in attribute", constant.ToString(), location);
                    return null;
            }
        }

        /// <summary>
        /// Adapt the operator kind depending on whether it's a dynamic call or a user-operator call.
        /// </summary>
        /// <param name="cx"></param>
        /// <param name="node"></param>
        /// <param name="originalKind"></param>
        /// <returns></returns>
        public static ExprKind UnaryOperatorKind(Context cx, ExprKind originalKind, ExpressionSyntax node) =>
            GetCallType(cx, node).AdjustKind(originalKind);

        /// <summary>
        /// If the expression calls an operator, add an expr_call()
        /// to show the target of the call. Also note the dynamic method
        /// name if available.
        /// </summary>
        /// <param name="cx">Context</param>
        /// <param name="node">The expression.</param>
        public void OperatorCall(TextWriter trapFile, ExpressionSyntax node)
        {
            var @operator = cx.GetSymbolInfo(node);
            if (@operator.Symbol is IMethodSymbol method)
            {
                var callType = GetCallType(cx, node);
                if (callType == CallType.Dynamic)
                {
                    UserOperator.OperatorSymbol(method.Name, out var operatorName);
                    trapFile.dynamic_member_name(this, operatorName);
                    return;
                }

                trapFile.expr_call(this, Method.Create(cx, method));
            }
        }

        public enum CallType
        {
            None,
            BuiltInOperator,
            Dynamic,
            UserOperator
        }

        /// <summary>
        /// Determine what type of method was called for this expression.
        /// </summary>
        /// <param name="cx">The context.</param>
        /// <param name="node">The expression</param>
        /// <returns>The call type.</returns>
        public static CallType GetCallType(Context cx, ExpressionSyntax node)
        {
            var @operator = cx.GetSymbolInfo(node);

            if (@operator.Symbol is IMethodSymbol method)
            {
                if (method.ContainingSymbol is ITypeSymbol containingSymbol && containingSymbol.TypeKind == Microsoft.CodeAnalysis.TypeKind.Dynamic)
                {
                    return CallType.Dynamic;
                }

                switch (method.MethodKind)
                {
                    case MethodKind.BuiltinOperator:
                        if (method.ContainingType != null && method.ContainingType.TypeKind == Microsoft.CodeAnalysis.TypeKind.Delegate)
                            return CallType.UserOperator;
                        return CallType.BuiltInOperator;
                    case MethodKind.Constructor:
                        // The index operator ^... generates a constructor call to System.Index.
                        // Instead, treat this as a regular operator.
                        return CallType.None;
                    default:
                        return CallType.UserOperator;
                }
            }

            return CallType.None;
        }


        public static bool IsDynamic(Context cx, ExpressionSyntax node)
        {
            var ti = cx.GetTypeInfo(node).ConvertedType;
            return ti != null && ti.TypeKind == Microsoft.CodeAnalysis.TypeKind.Dynamic;
        }

        /// <summary>
        /// Given b in a?.b.c, return a.
        /// </summary>
        /// <param name="node">A MemberBindingExpression.</param>
        /// <returns>The qualifier of the conditional access.</returns>
        protected static ExpressionSyntax FindConditionalQualifier(ExpressionSyntax node)
        {
            for (SyntaxNode n = node; n != null; n = n.Parent)
            {
                if (n.Parent is ConditionalAccessExpressionSyntax conditionalAccess &&
                    conditionalAccess.WhenNotNull == n)
                {
                    return conditionalAccess.Expression;
                }
            }

            throw new InternalError(node, "Unable to locate a ConditionalAccessExpression");
        }

        public void MakeConditional(TextWriter trapFile)
        {
            trapFile.conditional_access(this);
        }

        public void PopulateArguments(TextWriter trapFile, BaseArgumentListSyntax args, int child)
        {
            foreach (var arg in args.Arguments)
                PopulateArgument(trapFile, arg, child++);
        }

        private void PopulateArgument(TextWriter trapFile, ArgumentSyntax arg, int child)
        {
            var expr = Create(cx, arg.Expression, this, child);
            int mode;
            switch (arg.RefOrOutKeyword.Kind())
            {
                case SyntaxKind.RefKeyword:
                    mode = 1;
                    break;
                case SyntaxKind.OutKeyword:
                    mode = 2;
                    break;
                case SyntaxKind.None:
                    mode = 0;
                    break;
                case SyntaxKind.InKeyword:
                    mode = 3;
                    break;
                default:
                    throw new InternalError(arg, "Unknown argument type");
            }
            trapFile.expr_argument(expr, mode);

            if (arg.NameColon != null)
            {
                trapFile.expr_argument_name(expr, arg.NameColon.Name.Identifier.Text);
            }
        }

        public override string ToString() => Label.ToString();

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }

    internal static class CallTypeExtensions
    {
        /// <summary>
        /// Adjust the expression kind <paramref name="k"/> to match this call type.
        /// </summary>
        public static ExprKind AdjustKind(this Expression.CallType ct, ExprKind k)
        {
            switch (ct)
            {
                case Expression.CallType.Dynamic:
                case Expression.CallType.UserOperator:
                    return ExprKind.OPERATOR_INVOCATION;
                default:
                    return k;
            }
        }
    }

    internal abstract class Expression<TExpressionSyntax> : Expression
        where TExpressionSyntax : ExpressionSyntax
    {
        public TExpressionSyntax Syntax { get; }

        protected Expression(ExpressionNodeInfo info)
            : base(info)
        {
            Syntax = (TExpressionSyntax)info.Node;
        }

        /// <summary>
        /// Populates expression-type specific relations in the trap file. The general relations
        /// <code>expressions</code> and <code>expr_location</code> are populated by the constructor
        /// (should not fail), so even if expression-type specific population fails (e.g., in
        /// standalone extraction), the expression created via
        /// <see cref="Expression.Create(Context, ExpressionSyntax, IEntity, int, ITypeSymbol)"/> will
        /// still be valid.
        /// </summary>
        protected abstract void PopulateExpression(TextWriter trapFile);

        protected new Expression TryPopulate()
        {
            cx.Try(Syntax, null, () => PopulateExpression(cx.TrapWriter.Writer));
            return this;
        }
    }

    /// <summary>
    /// Holds all information required to create an Expression entity.
    /// </summary>
    internal interface IExpressionInfo
    {
        Context Context { get; }

        /// <summary>
        /// The type of the expression.
        /// </summary>
        AnnotatedType Type { get; }

        /// <summary>
        /// The location of the expression.
        /// </summary>
        Extraction.Entities.Location Location { get; }

        /// <summary>
        /// The kind of the expression.
        /// </summary>
        ExprKind Kind { get; }

        /// <summary>
        /// The parent of the expression.
        /// </summary>
        IExpressionParentEntity Parent { get; }

        /// <summary>
        /// The child index of the expression.
        /// </summary>
        int Child { get; }

        /// <summary>
        /// Holds if this is an implicit expression.
        /// </summary>
        bool IsCompilerGenerated { get; }

        /// <summary>
        /// Gets a string representation of the value.
        /// null is encoded as the string "null".
        /// If the expression does not have a value, then this
        /// is null.
        /// </summary>
        string ExprValue { get; }

        NullableFlowState FlowState { get; }
    }

    /// <summary>
    /// Explicitly constructed expression information.
    /// </summary>
    internal class ExpressionInfo : IExpressionInfo
    {
        public Context Context { get; }
        public AnnotatedType Type { get; }
        public Extraction.Entities.Location Location { get; }
        public ExprKind Kind { get; }
        public IExpressionParentEntity Parent { get; }
        public int Child { get; }
        public bool IsCompilerGenerated { get; }
        public string ExprValue { get; }

        public ExpressionInfo(Context cx, AnnotatedType type, Extraction.Entities.Location location, ExprKind kind,
            IExpressionParentEntity parent, int child, bool isCompilerGenerated, string value)
        {
            Context = cx;
            Type = type;
            Location = location;
            Kind = kind;
            Parent = parent;
            Child = child;
            ExprValue = value;
            IsCompilerGenerated = isCompilerGenerated;
        }

        // Synthetic expressions don't have a flow state.
        public NullableFlowState FlowState => NullableFlowState.None;
    }

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

        public AnnotatedTypeSymbol ExpressionType
        {
            get
            {
                var type = ResolvedType;

                if (type.Symbol == null)
                    type.Symbol = (TypeInfo.Type ?? TypeInfo.ConvertedType).DisambiguateType();

                // Roslyn workaround: It can't work out the type of "new object[0]"
                // Clearly a bug.
                if (type.Symbol?.TypeKind == Microsoft.CodeAnalysis.TypeKind.Error)
                {
                    if (Node is ArrayCreationExpressionSyntax arrayCreation)
                    {
                        var elementType = Context.GetType(arrayCreation.Type.ElementType);

                        if (elementType.Symbol != null)
                            // There seems to be no way to create an array with a nullable element at present.
                            return new AnnotatedTypeSymbol(Context.Compilation.CreateArrayTypeSymbol(elementType.Symbol, arrayCreation.Type.RankSpecifiers.Count), NullableAnnotation.NotAnnotated);
                    }

                    Context.ModelError(Node, "Failed to determine type");
                }

                return type;
            }
        }

        private Microsoft.CodeAnalysis.Location location;

        public Microsoft.CodeAnalysis.Location CodeAnalysisLocation
        {
            get
            {
                if (location == null)
                    location = Node.FixedLocation();
                return location;
            }
            set
            {
                location = value;
            }
        }

        public SemanticModel Model => Context.GetModel(Node);

        public string ExprValue
        {
            get
            {
                var c = Model.GetConstantValue(Node);
                return c.HasValue ? Expression.ValueAsString(c.Value) : null;
            }
        }

        private AnnotatedType cachedType;

        public AnnotatedType Type
        {
            get
            {
                if (cachedType.Type == null)
                    cachedType = Entities.Type.Create(Context, ExpressionType);
                return cachedType;
            }
            set
            {
                cachedType = value;
            }
        }

        private Extraction.Entities.Location cachedLocation;

        public Extraction.Entities.Location Location
        {
            get
            {
                if (cachedLocation == null)
                    cachedLocation = Context.Create(CodeAnalysisLocation);
                return cachedLocation;
            }

            set
            {
                cachedLocation = value;
            }
        }

        public ExprKind Kind { get; set; } = ExprKind.UNKNOWN;

        public bool IsCompilerGenerated { get; set; }

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

        public ExpressionNodeInfo SetType(AnnotatedType type)
        {
            Type = type;
            return this;
        }

        public ExpressionNodeInfo SetNode(ExpressionSyntax node)
        {
            Node = node;
            return this;
        }

        private SymbolInfo cachedSymbolInfo;

        public SymbolInfo SymbolInfo
        {
            get
            {
                if (cachedSymbolInfo.Symbol == null && cachedSymbolInfo.CandidateReason == CandidateReason.None)
                    cachedSymbolInfo = Model.GetSymbolInfo(Node);
                return cachedSymbolInfo;
            }
        }

        public NullableFlowState FlowState => TypeInfo.Nullability.FlowState;
    }
}
