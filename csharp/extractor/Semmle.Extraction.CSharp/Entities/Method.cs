using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Populators;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    public abstract class Method : CachedSymbol<IMethodSymbol>, IExpressionParentEntity, IStatementParentEntity
    {
        protected Method(Context cx, IMethodSymbol init)
            : base(cx, init) { }

        protected void PopulateParameters()
        {
            var originalMethod = OriginalDefinition;
            IEnumerable<IParameterSymbol> parameters = Symbol.Parameters;
            IEnumerable<IParameterSymbol> originalParameters = originalMethod.Symbol.Parameters;

            if (IsReducedExtension)
            {
                if (this == originalMethod)
                {
                    // Non-generic reduced extensions must be extracted exactly like the
                    // non-reduced counterparts
                    parameters = Symbol.ReducedFrom.Parameters;
                }
                else
                {
                    // Constructed reduced extensions are special because their non-reduced
                    // counterparts are not constructed. Therefore, we need to manually add
                    // the `this` parameter based on the type of the receiver
                    var originalThisParamSymbol = originalMethod.Symbol.Parameters.First();
                    var originalThisParam = Parameter.Create(Context, originalThisParamSymbol, originalMethod);
                    ConstructedExtensionParameter.Create(Context, this, originalThisParam);
                    originalParameters = originalParameters.Skip(1);
                }
            }

            foreach (var p in parameters.Zip(originalParameters, (paramSymbol, originalParam) => new { paramSymbol, originalParam }))
            {
                var original = SymbolEqualityComparer.Default.Equals(p.paramSymbol, p.originalParam) ? null : Parameter.Create(Context, p.originalParam, originalMethod);
                Parameter.Create(Context, p.paramSymbol, this, original);
            }

            if (Symbol.IsVararg)
            {
                // Mono decided that "__arglist" should be an explicit parameter,
                // so now we need to populate it.

                VarargsParam.Create(Context, this);
            }
        }

        /// <summary>
        /// Extracts constructor initializers.
        /// </summary>
        protected virtual void ExtractInitializers(TextWriter trapFile)
        {
            // Normal methods don't have initializers,
            // so there's nothing to extract.
        }

        void PopulateMethodBody(TextWriter trapFile)
        {
            if (!IsSourceDeclaration)
                return;

            var block = Block;
            var expr = ExpressionBody;

            if (block != null || expr != null)
                Context.PopulateLater(
                    () =>
                    {
                        ExtractInitializers(trapFile);
                        if (block != null)
                            Statements.Block.Create(Context, block, this, 0);
                        else
                            Expression.Create(Context, expr, this, 0);

                        LineCounter.NumberOfLines(trapFile, BodyDeclaringSymbol, this);
                    });
        }

        public void Overrides(TextWriter trapFile)
        {
            foreach (var explicitInterface in Symbol.ExplicitInterfaceImplementations.
                Where(sym => sym.MethodKind == MethodKind.Ordinary).
                Select(impl => Type.Create(Context, impl.ContainingType)))
            {
                trapFile.explicitly_implements(this, explicitInterface.TypeRef);

                if (IsSourceDeclaration)
                    foreach (var syntax in Symbol.DeclaringSyntaxReferences.Select(d => d.GetSyntax()).OfType<MethodDeclarationSyntax>())
                        TypeMention.Create(Context, syntax.ExplicitInterfaceSpecifier.Name, this, explicitInterface);
            }

            if (Symbol.OverriddenMethod != null)
            {
                trapFile.overrides(this, Method.Create(Context, Symbol.OverriddenMethod));
            }
        }

        /// <summary>
        ///  Factored out to share logic between `Method` and `UserOperator`.
        /// </summary>
        protected static void BuildMethodId(Method m, TextWriter trapFile)
        {
            m.Symbol.ReturnType.BuildOrWriteId(m.Context, trapFile, m.Symbol);
            trapFile.Write(" ");

            trapFile.WriteSubId(m.ContainingType);

            AddExplicitInterfaceQualifierToId(m.Context, trapFile, m.Symbol.ExplicitInterfaceImplementations);

            trapFile.Write(".");
            trapFile.Write(m.Symbol.Name);

            if (m.Symbol.IsGenericMethod)
            {
                if (SymbolEqualityComparer.Default.Equals(m.Symbol, m.Symbol.OriginalDefinition))
                {
                    trapFile.Write('`');
                    trapFile.Write(m.Symbol.TypeParameters.Length);
                }
                else
                {
                    trapFile.Write('<');
                    // Encode the nullability of the type arguments in the label.
                    // Type arguments with different nullability can result in
                    // a constructed method with different nullability of its parameters and return type,
                    // so we need to create a distinct database entity for it.
                    trapFile.BuildList(",", m.Symbol.GetAnnotatedTypeArguments(), (ta, tb0) => { ta.Symbol.BuildOrWriteId(m.Context, tb0, m.Symbol); trapFile.Write((int)ta.Nullability); });
                    trapFile.Write('>');
                }
            }

            AddParametersToId(m.Context, trapFile, m.Symbol);
            switch (m.Symbol.MethodKind)
            {
                case MethodKind.PropertyGet:
                    trapFile.Write(";getter");
                    break;
                case MethodKind.PropertySet:
                    trapFile.Write(";setter");
                    break;
                case MethodKind.EventAdd:
                    trapFile.Write(";adder");
                    break;
                case MethodKind.EventRaise:
                    trapFile.Write(";raiser");
                    break;
                case MethodKind.EventRemove:
                    trapFile.Write(";remover");
                    break;
                default:
                    trapFile.Write(";method");
                    break;
            }
        }

        public override void WriteId(TextWriter trapFile)
        {
            BuildMethodId(this, trapFile);
        }

        protected static void AddParametersToId(Context cx, TextWriter trapFile, IMethodSymbol method)
        {
            trapFile.Write('(');
            int index = 0;

            var @params = method.MethodKind == MethodKind.ReducedExtension
                ? method.ReducedFrom.Parameters
                : method.Parameters;

            foreach (var param in @params)
            {
                trapFile.WriteSeparator(",", ref index);
                param.Type.BuildOrWriteId(cx, trapFile, method);
                trapFile.Write(" ");
                trapFile.Write(param.Name);
                switch (param.RefKind)
                {
                    case RefKind.Out:
                        trapFile.Write(" out");
                        break;
                    case RefKind.Ref:
                        trapFile.Write(" ref");
                        break;
                }
            }

            if (method.IsVararg)
            {
                trapFile.WriteSeparator(",", ref index);
                trapFile.Write("__arglist");
            }

            trapFile.Write(')');
        }

        public static void AddExplicitInterfaceQualifierToId(Context cx, System.IO.TextWriter trapFile, IEnumerable<ISymbol> explicitInterfaceImplementations)
        {
            if (explicitInterfaceImplementations.Any())
                trapFile.AppendList(",", explicitInterfaceImplementations.Select(impl => cx.CreateEntity(impl.ContainingType)));
        }

        public virtual string Name => Symbol.Name;

        /// <summary>
        /// Creates a method of the appropriate subtype.
        /// </summary>
        /// <param name="cx"></param>
        /// <param name="methodDecl"></param>
        /// <returns></returns>
        public static Method Create(Context cx, IMethodSymbol methodDecl)
        {
            if (methodDecl == null) return null;

            var methodKind = methodDecl.MethodKind;

            if (methodKind == MethodKind.ExplicitInterfaceImplementation)
            {
                // Retrieve the original method kind
                methodKind = methodDecl.ExplicitInterfaceImplementations.Select(m => m.MethodKind).FirstOrDefault();
            }

            switch (methodKind)
            {
                case MethodKind.StaticConstructor:
                case MethodKind.Constructor:
                    return Constructor.Create(cx, methodDecl);
                case MethodKind.ReducedExtension:
                case MethodKind.Ordinary:
                case MethodKind.DelegateInvoke:
                    return OrdinaryMethod.Create(cx, methodDecl);
                case MethodKind.Destructor:
                    return Destructor.Create(cx, methodDecl);
                case MethodKind.PropertyGet:
                case MethodKind.PropertySet:
                    return methodDecl.AssociatedSymbol is null ? OrdinaryMethod.Create(cx, methodDecl) : (Method)Accessor.Create(cx, methodDecl);
                case MethodKind.EventAdd:
                case MethodKind.EventRemove:
                    return EventAccessor.Create(cx, methodDecl);
                case MethodKind.UserDefinedOperator:
                case MethodKind.BuiltinOperator:
                    return UserOperator.Create(cx, methodDecl);
                case MethodKind.Conversion:
                    return Conversion.Create(cx, methodDecl);
                case MethodKind.AnonymousFunction:
                    throw new InternalError(methodDecl, "Attempt to create a lambda");
                case MethodKind.LocalFunction:
                    return LocalFunction.Create(cx, methodDecl);
                default:
                    throw new InternalError(methodDecl, $"Unhandled method '{methodDecl}' of kind '{methodDecl.MethodKind}'");
            }
        }

        public Method OriginalDefinition =>
            IsReducedExtension
                ? Create(Context, Symbol.ReducedFrom)
                : Create(Context, Symbol.OriginalDefinition);

        public override Microsoft.CodeAnalysis.Location FullLocation => ReportingLocation;

        public override bool IsSourceDeclaration => Symbol.IsSourceDeclaration();

        /// <summary>
        /// Whether this method has type parameters.
        /// </summary>
        public bool IsGeneric => Symbol.IsGenericMethod;

        /// <summary>
        /// Whether this method has unbound type parameters.
        /// </summary>
        public bool IsUnboundGeneric => IsGeneric && SymbolEqualityComparer.Default.Equals(Symbol.ConstructedFrom, Symbol);

        public bool IsBoundGeneric => IsGeneric && !IsUnboundGeneric;

        bool IsReducedExtension => Symbol.MethodKind == MethodKind.ReducedExtension;

        protected IMethodSymbol ConstructedFromSymbol => Symbol.ConstructedFrom.ReducedFrom ?? Symbol.ConstructedFrom;

        bool IExpressionParentEntity.IsTopLevelParent => true;

        bool IStatementParentEntity.IsTopLevelParent => true;

        protected void PopulateGenerics(TextWriter trapFile)
        {
            var isFullyConstructed = IsBoundGeneric;

            if (IsGeneric)
            {
                int child = 0;

                if (isFullyConstructed)
                {
                    trapFile.constructed_generic(this, Method.Create(Context, ConstructedFromSymbol));
                    foreach (var tp in Symbol.GetAnnotatedTypeArguments())
                    {
                        trapFile.type_arguments(Type.Create(Context, tp.Symbol), child, this);
                        child++;
                    }

                    var nullability = new Nullability(Symbol);
                    if (!nullability.IsOblivious)
                        trapFile.type_nullability(this, NullabilityEntity.Create(Context, nullability));
                }
                else
                {
                    foreach (var typeParam in Symbol.TypeParameters.Select(tp => TypeParameter.Create(Context, tp)))
                    {
                        trapFile.type_parameters(typeParam, child, this);
                        child++;
                    }
                }
            }
        }

        protected void ExtractRefReturn(TextWriter trapFile)
        {
            if (Symbol.ReturnsByRef)
                trapFile.type_annotation(this, Kinds.TypeAnnotation.Ref);
            if (Symbol.ReturnsByRefReadonly)
                trapFile.type_annotation(this, Kinds.TypeAnnotation.ReadonlyRef);
        }

        protected void PopulateMethod(TextWriter trapFile)
        {
            // Common population code for all callables
            BindComments();
            PopulateAttributes();
            PopulateParameters();
            PopulateMethodBody(trapFile);
            PopulateGenerics(trapFile);
            PopulateMetadataHandle(trapFile);
            PopulateNullability(trapFile, Symbol.GetAnnotatedReturnType());
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.PushesLabel;
    }
}
