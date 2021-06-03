using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Entities.Expressions;
using Semmle.Extraction.Kinds;
using System;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class Expression : FreshEntity, IExpressionParentEntity
    {
        private readonly IExpressionInfo info;
        public AnnotatedTypeSymbol? Type { get; private set; }
        public Extraction.Entities.Location Location { get; }
        public ExprKind Kind { get; }

        internal Expression(IExpressionInfo info, bool shouldPopulate = true)
            : base(info.Context)
        {
            this.info = info;
            Location = info.Location;
            Kind = info.Kind;
            Type = info.Type;

            if (shouldPopulate)
            {
                TryPopulate();
            }
        }

        protected sealed override void Populate(TextWriter trapFile)
        {
            var type = Type.HasValue ? Entities.Type.Create(Context, Type.Value) : NullType.Create(Context);
            trapFile.expressions(this, Kind, type.TypeRef);
            if (info.Parent.IsTopLevelParent)
                trapFile.expr_parent_top_level(this, info.Child, info.Parent);
            else
                trapFile.expr_parent(this, info.Child, info.Parent);
            trapFile.expr_location(this, Location);

            if (Type.HasValue && !Type.Value.HasObliviousNullability())
            {
                var n = NullabilityEntity.Create(Context, Nullability.Create(Type.Value));
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

            type.PopulateGenerics();
        }

        public override Location? ReportingLocation => Location.Symbol;

        internal void SetType(ITypeSymbol? type)
        {
            if (type is not null)
            {
                Type = new AnnotatedTypeSymbol(type, type.NullableAnnotation);
            }
        }

        bool IExpressionParentEntity.IsTopLevelParent => false;

        /// <summary>
        /// Gets a string represention of a constant value.
        /// </summary>
        /// <param name="obj">The value.</param>
        /// <returns>The string representation.</returns>
        public static string ValueAsString(object? value)
        {
            return value is null
                ? "null"
                : value is bool b
                    ? b
                        ? "true"
                        : "false"
                    : value.ToString()!;
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
        public static Expression? CreateGenerated(Context cx, TypedConstant constant, IExpressionParentEntity parent,
            int childIndex, Extraction.Entities.Location location)
        {
            if (constant.IsNull ||
                constant.Type is null)
            {
                return Literal.CreateGeneratedNullLiteral(cx, parent, childIndex, location);
            }

            switch (constant.Kind)
            {
                case TypedConstantKind.Primitive:
                    return Literal.CreateGenerated(cx, parent, childIndex, constant.Type, constant.Value, location);
                case TypedConstantKind.Enum:
                    // Enum value is generated in the following format: (Enum)value
                    Action<Expression, int> createChild = (parent, index) => Literal.CreateGenerated(cx, parent, index, ((INamedTypeSymbol)constant.Type).EnumUnderlyingType!, constant.Value, location);
                    var cast = Cast.CreateGenerated(cx, parent, childIndex, constant.Type!, constant.Value, createChild, location);
                    return cast;
                case TypedConstantKind.Type:
                    var type = ((ITypeSymbol)constant.Value!).OriginalDefinition;
                    return TypeOf.CreateGenerated(cx, parent, childIndex, type, location);
                case TypedConstantKind.Array:
                    // Single dimensional arrays are in the following format:
                    // * new Type[N] { item1, item2, ..., itemN }
                    // * new Type[0]
                    //
                    // itemI is generated recursively.
                    return NormalArrayCreation.CreateGenerated(cx, parent, childIndex, constant.Type, constant.Values, location);
                case TypedConstantKind.Error:
                default:
                    cx.ExtractionError("Couldn't extract constant in attribute", constant.ToString(), location);
                    return null;
            }
        }

        /// <summary>
        /// Creates a generated expression for a default argument value.
        /// </summary>
        public static Expression? CreateGenerated(Context cx, IParameterSymbol parameter, IExpressionParentEntity parent,
            int childIndex, Extraction.Entities.Location location)
        {
            if (!parameter.HasExplicitDefaultValue ||
                parameter.Type is IErrorTypeSymbol)
            {
                return null;
            }

            var defaultValue = parameter.ExplicitDefaultValue;

            if (parameter.Type is INamedTypeSymbol nt && nt.EnumUnderlyingType is not null)
            {
                // = (MyEnum)1, = MyEnum.Value1, = default(MyEnum), = new MyEnum()
                // we're generating a (MyEnum)value cast expression:
                defaultValue ??= 0;
                Action<Expression, int> createChild = (parent, index) => Literal.CreateGenerated(cx, parent, index, nt.EnumUnderlyingType, defaultValue, location);
                return Cast.CreateGenerated(cx, parent, childIndex, parameter.Type, defaultValue, createChild, location);
            }

            if (defaultValue is null)
            {
                // = null, = default, = default(T), = new MyStruct()
                // we're generating a default expression:
                return Default.CreateGenerated(cx, parent, childIndex, location, parameter.Type.IsReferenceType ? ValueAsString(null) : null);
            }

            if (parameter.Type.SpecialType == SpecialType.System_Object)
            {
                // this can happen in VB.NET
                cx.ExtractionError($"Extracting default argument value 'object {parameter.Name} = default' instead of 'object {parameter.Name} = {defaultValue}'. The latter is not supported in C#.",
                    null, null, severity: Util.Logging.Severity.Warning);

                // we're generating a default expression:
                return Default.CreateGenerated(cx, parent, childIndex, location, ValueAsString(null));
            }

            // const literal:
            return Literal.CreateGenerated(cx, parent, childIndex, parameter.Type, defaultValue, location);
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
            var @operator = Context.GetSymbolInfo(node);
            if (@operator.Symbol is IMethodSymbol method)
            {
                var callType = GetCallType(Context, node);
                if (callType == CallType.Dynamic)
                {
                    UserOperator.OperatorSymbol(method.Name, out var operatorName);
                    trapFile.dynamic_member_name(this, operatorName);
                    return;
                }

                trapFile.expr_call(this, Method.Create(Context, method));
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
                        if (method.ContainingType is not null && method.ContainingType.TypeKind == Microsoft.CodeAnalysis.TypeKind.Delegate)
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
            return ti is not null && ti.TypeKind == Microsoft.CodeAnalysis.TypeKind.Dynamic;
        }

        /// <summary>
        /// Given b in a?.b.c, return a.
        /// </summary>
        /// <param name="node">A MemberBindingExpression.</param>
        /// <returns>The qualifier of the conditional access.</returns>
        protected static ExpressionSyntax FindConditionalQualifier(ExpressionSyntax node)
        {
            for (SyntaxNode? n = node; n is not null; n = n.Parent)
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
            var expr = Create(Context, arg.Expression, this, child);
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

            if (arg.NameColon is not null)
            {
                trapFile.expr_argument_name(expr, arg.NameColon.Name.Identifier.Text);
            }
        }

        public override string ToString() => Label.ToString();

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}
