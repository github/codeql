using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Populators;
using System.Collections.Generic;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    public abstract class Method : CachedSymbol<IMethodSymbol>, IExpressionParentEntity, IStatementParentEntity
    {
        public Method(Context cx, IMethodSymbol init)
            : base(cx, init) { }

        protected void ExtractParameters()
        {
            var originalMethod = OriginalDefinition;
            IEnumerable<IParameterSymbol> parameters = symbol.Parameters;
            IEnumerable<IParameterSymbol> originalParameters = originalMethod.symbol.Parameters;

            if (IsReducedExtension)
            {
                if (this == originalMethod)
                {
                    // Non-generic reduced extensions must be extracted exactly like the
                    // non-reduced counterparts
                    parameters = symbol.ReducedFrom.Parameters;
                }
                else
                {
                    // Constructed reduced extensions are special because their non-reduced
                    // counterparts are not constructed. Therefore, we need to manually add
                    // the `this` parameter based on the type of the receiver
                    var originalThisParamSymbol = originalMethod.symbol.Parameters.First();
                    var originalThisParam = Parameter.Create(Context, originalThisParamSymbol, originalMethod);
                    ConstructedExtensionParameter.Create(Context, this, originalThisParam);
                    originalParameters = originalParameters.Skip(1);
                }
            }

            foreach (var p in parameters.Zip(originalParameters, (paramSymbol, originalParam) => new { paramSymbol, originalParam }))
            {
                var original = Equals(p.paramSymbol, p.originalParam) ? null : Parameter.Create(Context, p.originalParam, originalMethod);
                Parameter.Create(Context, p.paramSymbol, this, original);
            }

            if (symbol.IsVararg)
            {
                // Mono decided that "__arglist" should be an explicit parameter,
                // so now we need to populate it.

                VarargsParam.Create(Context, this);
            }
        }

        /// <summary>
        /// Extracts constructor initializers.
        /// </summary>
        protected virtual void ExtractInitializers()
        {
            // Normal methods don't have initializers,
            // so there's nothing to extract.
        }

        void ExtractMethodBody()
        {
            if (!IsSourceDeclaration)
                return;

            var block = Block;
            var expr = ExpressionBody;

            if (block != null || expr != null)
                Context.PopulateLater(
                    () =>
                    {
                        ExtractInitializers();
                        if (block != null)
                            Statements.Block.Create(Context, block, this, 0);
                        else
                            Expression.Create(Context, expr, this, 0);

                        Context.NumberOfLines(symbol, this);
                    });
        }

        public void Overrides()
        {
            foreach (var explicitInterface in symbol.ExplicitInterfaceImplementations.
                Where(sym => sym.MethodKind == MethodKind.Ordinary).
                Select(impl => Type.Create(Context, impl.ContainingType)))
            {
                Context.Emit(Tuples.explicitly_implements(this, explicitInterface.TypeRef));

                if (IsSourceDeclaration)
                    foreach (var syntax in symbol.DeclaringSyntaxReferences.Select(d => d.GetSyntax()).OfType<MethodDeclarationSyntax>())
                        TypeMention.Create(Context, syntax.ExplicitInterfaceSpecifier.Name, this, explicitInterface);
            }

            if (symbol.OverriddenMethod != null)
            {
                Context.Emit(Tuples.overrides(this, Method.Create(Context, symbol.OverriddenMethod)));
            }
        }

        /// <summary>
        ///  Factored out to share logic between `Method` and `UserOperator`.
        /// </summary>
        protected static void BuildMethodId(Method m, ITrapBuilder tb)
        {
            tb.Append(m.ContainingType);

            AddExplicitInterfaceQualifierToId(m.Context, tb, m.symbol.ExplicitInterfaceImplementations);

            tb.Append(".").Append(m.symbol.Name);

            if (m.symbol.IsGenericMethod)
            {
                if (Equals(m.symbol, m.symbol.OriginalDefinition))
                {
                    tb.Append("`").Append(m.symbol.TypeParameters.Length);
                }
                else
                {
                    tb.Append("<");
                    tb.BuildList(",", m.symbol.TypeArguments, (ta, tb0) => AddSignatureTypeToId(m.Context, tb0, m.symbol, ta));
                    tb.Append(">");
                }
            }

            AddParametersToId(m.Context, tb, m.symbol);
            switch (m.symbol.MethodKind)
            {
                case MethodKind.PropertyGet:
                    tb.Append(";getter");
                    break;
                case MethodKind.PropertySet:
                    tb.Append(";setter");
                    break;
                case MethodKind.EventAdd:
                    tb.Append(";adder");
                    break;
                case MethodKind.EventRaise:
                    tb.Append(";raiser");
                    break;
                case MethodKind.EventRemove:
                    tb.Append(";remover");
                    break;
                default:
                    tb.Append(";method");
                    break;
            }
        }

        public override IId Id => new Key(tb => BuildMethodId(this, tb));

        /// <summary>
        /// Adds an appropriate label ID to the trap builder <paramref name="tb"/>
        /// for the type <paramref name="type"/> belonging to the signature of method
        /// <paramref name="method"/>.
        ///
        /// For methods without type parameters this will always add the key of the
        /// corresponding type.
        ///
        /// For methods with type parameters, this will add the key of the
        /// corresponding type if the type does *not* contain one of the method
        /// type parameters, otherwise it will add a textual representation of
        /// the type. This distinction is required because type parameter IDs
        /// refer to their declaring methods.
        ///
        /// Example:
        ///
        /// <code>
        /// int Count&lt;T&gt;(IEnumerable<T> items)
        /// </code>
        ///
        /// The label definitions for <code>Count</code> (<code>#4</code>) and <code>T</code>
        /// (<code>#5</code>) will look like:
        ///
        /// <code>
        /// #1=&lt;label for System.Int32&gt;
        /// #2=&lt;label for type containing Count&gt;
        /// #3=&lt;label for IEnumerable`1&gt;
        /// #4=@"{#1} {#2}.Count`2(#3<T>);method"
        /// #5=@"{#4}T;typeparameter"
        /// </code>
        ///
        /// Note how <code>int</code> is referenced in the label definition <code>#3</code> for
        /// <code>Count</code>, while <code>T[]</code> is represented textually in order
        /// to make the reference to <code>#3</code> in the label definition <code>#4</code> for
        /// <code>T</code> valid.
        /// </summary>
        protected static void AddSignatureTypeToId(Context cx, ITrapBuilder tb, IMethodSymbol method, ITypeSymbol type)
        {
            if (type.ContainsTypeParameters(cx, method))
                type.BuildTypeId(cx, tb, (cx0, tb0, type0) => AddSignatureTypeToId(cx, tb0, method, type0));
            else
                tb.Append(Type.Create(cx, type));
        }

        protected static void AddParametersToId(Context cx, ITrapBuilder tb, IMethodSymbol method)
        {
            tb.Append("(");
            tb.AppendList(",", AddParameterPartsToId(cx, tb, method));
            tb.Append(")");
        }

        // This is a slight abuse of ITrapBuilder.AppendList().
        // yield return "" is used to insert a list separator
        // at the desired location.
        static IEnumerable<object> AddParameterPartsToId(Context cx, ITrapBuilder tb, IMethodSymbol method)
        {
            if (method.MethodKind == MethodKind.ReducedExtension)
            {
                AddSignatureTypeToId(cx, tb, method, method.ReceiverType);
                yield return "";    // The next yield return outputs a ","
            }

            foreach (var param in method.Parameters)
            {
                yield return "";    // Maybe print ","
                AddSignatureTypeToId(cx, tb, method, param.Type);
                switch (param.RefKind)
                {
                    case RefKind.Out:
                        yield return " out";
                        break;
                    case RefKind.Ref:
                        yield return " ref";
                        break;
                }
            }

            if (method.IsVararg)
            {
                yield return "__arglist";
            }
        }

        public static void AddExplicitInterfaceQualifierToId(Context cx, ITrapBuilder tb, IEnumerable<ISymbol> explicitInterfaceImplementations)
        {
            if (explicitInterfaceImplementations.Any())
            {
                tb.AppendList(",", explicitInterfaceImplementations.Select(impl => cx.CreateEntity(impl.ContainingType)));
            }
        }

        public virtual string Name => symbol.Name;

        /// <summary>
        /// Creates a method of the appropriate subtype.
        /// </summary>
        /// <param name="cx"></param>
        /// <param name="methodDecl"></param>
        /// <returns></returns>
        public static Method Create(Context cx, IMethodSymbol methodDecl)
        {
            if (methodDecl == null) return null;

            switch (methodDecl.MethodKind)
            {
                case MethodKind.StaticConstructor:
                case MethodKind.Constructor:
                    return Constructor.Create(cx, methodDecl);
                case MethodKind.ReducedExtension:
                case MethodKind.Ordinary:
                case MethodKind.DelegateInvoke:
                case MethodKind.ExplicitInterfaceImplementation:
                    return OrdinaryMethod.Create(cx, methodDecl);
                case MethodKind.Destructor:
                    return Destructor.Create(cx, methodDecl);
                case MethodKind.PropertyGet:
                case MethodKind.PropertySet:
                    return Accessor.Create(cx, methodDecl);
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
                    throw new InternalError(methodDecl, "Unhandled method '{0}' of kind '{1}'", methodDecl, methodDecl.MethodKind);
            }
        }

        public Method OriginalDefinition =>
            IsReducedExtension
                ? Create(Context, symbol.ReducedFrom)
                : Create(Context, symbol.OriginalDefinition);

        public override Microsoft.CodeAnalysis.Location FullLocation => ReportingLocation;

        public override bool IsSourceDeclaration => symbol.IsSourceDeclaration();

        /// <summary>
        /// Whether this method has type parameters.
        /// </summary>
        public bool IsGeneric => symbol.IsGenericMethod;

        /// <summary>
        /// Whether this method has unbound type parameters.
        /// </summary>
        public bool IsUnboundGeneric => IsGeneric && Equals(symbol.ConstructedFrom, symbol);

        public bool IsBoundGeneric => IsGeneric && !IsUnboundGeneric;

        bool IsReducedExtension => symbol.MethodKind == MethodKind.ReducedExtension;

        protected IMethodSymbol ConstructedFromSymbol => symbol.ConstructedFrom.ReducedFrom ?? symbol.ConstructedFrom;

        bool IExpressionParentEntity.IsTopLevelParent => true;

        bool IStatementParentEntity.IsTopLevelParent => true;

        protected void ExtractGenerics()
        {
            var isFullyConstructed = IsBoundGeneric;

            if (IsGeneric)
            {
                int child = 0;

                if (isFullyConstructed)
                {
                    Context.Emit(Tuples.is_constructed(this));
                    Context.Emit(Tuples.constructed_generic(this, Method.Create(Context, ConstructedFromSymbol)));
                    foreach (var tp in symbol.TypeArguments)
                    {
                        Context.Emit(Tuples.type_arguments(Type.Create(Context, tp), child++, this));
                    }
                }
                else
                {
                    Context.Emit(Tuples.is_generic(this));
                    foreach (var typeParam in symbol.TypeParameters.Select(tp => TypeParameter.Create(Context, tp)))
                    {
                        Context.Emit(Tuples.type_parameters(typeParam, child++, this));
                    }
                }
            }
        }

        protected void ExtractRefReturn()
        {
            if (symbol.ReturnsByRef)
                Context.Emit(Tuples.ref_returns(this));
            if (symbol.ReturnsByRefReadonly)
                Context.Emit(Tuples.ref_readonly_returns(this));
        }

        protected void PopulateMethod()
        {
            // Common population code for all callables
            BindComments();
            ExtractAttributes();
            ExtractParameters();
            ExtractMethodBody();
            ExtractGenerics();
            ExtractMetadataHandle();
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.PushesLabel;
    }
}
