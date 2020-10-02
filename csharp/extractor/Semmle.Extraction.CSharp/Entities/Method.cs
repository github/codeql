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
                var original = SymbolEqualityComparer.Default.Equals(p.paramSymbol, p.originalParam) ? null : Parameter.Create(Context, p.originalParam, originalMethod);
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
        protected virtual void ExtractInitializers(TextWriter trapFile)
        {
            // Normal methods don't have initializers,
            // so there's nothing to extract.
        }

        private void PopulateMethodBody(TextWriter trapFile)
        {
            if (!IsSourceDeclaration)
                return;

            var block = Block;
            var expr = ExpressionBody;

            if (block != null || expr != null)
            {
                Context.PopulateLater(
                   () =>
                   {
                       ExtractInitializers(trapFile);
                       if (block != null)
                           Statements.Block.Create(Context, block, this, 0);
                       else
                           Expression.Create(Context, expr, this, 0);

                       Context.NumberOfLines(trapFile, BodyDeclaringSymbol, this);
                   });
            }
        }

        public void Overrides(TextWriter trapFile)
        {
            foreach (var explicitInterface in symbol.ExplicitInterfaceImplementations
                .Where(sym => sym.MethodKind == MethodKind.Ordinary)
                .Select(impl => Type.Create(Context, impl.ContainingType)))
            {
                trapFile.explicitly_implements(this, explicitInterface.TypeRef);

                if (IsSourceDeclaration)
                {
                    foreach (var syntax in symbol.DeclaringSyntaxReferences.Select(d => d.GetSyntax()).OfType<MethodDeclarationSyntax>())
                        TypeMention.Create(Context, syntax.ExplicitInterfaceSpecifier.Name, this, explicitInterface);
                }
            }

            if (symbol.OverriddenMethod != null)
            {
                trapFile.overrides(this, Method.Create(Context, symbol.OverriddenMethod));
            }
        }

        /// <summary>
        ///  Factored out to share logic between `Method` and `UserOperator`.
        /// </summary>
        protected static void BuildMethodId(Method m, TextWriter trapFile)
        {
            m.symbol.ReturnType.BuildOrWriteId(m.Context, trapFile, m.symbol);
            trapFile.Write(" ");

            trapFile.WriteSubId(m.ContainingType);

            AddExplicitInterfaceQualifierToId(m.Context, trapFile, m.symbol.ExplicitInterfaceImplementations);

            trapFile.Write(".");
            trapFile.Write(m.symbol.Name);

            if (m.symbol.IsGenericMethod)
            {
                if (SymbolEqualityComparer.Default.Equals(m.symbol, m.symbol.OriginalDefinition))
                {
                    trapFile.Write('`');
                    trapFile.Write(m.symbol.TypeParameters.Length);
                }
                else
                {
                    trapFile.Write('<');
                    // Encode the nullability of the type arguments in the label.
                    // Type arguments with different nullability can result in
                    // a constructed method with different nullability of its parameters and return type,
                    // so we need to create a distinct database entity for it.
                    trapFile.BuildList(",", m.symbol.GetAnnotatedTypeArguments(), (ta, tb0) => { ta.Symbol.BuildOrWriteId(m.Context, tb0, m.symbol); trapFile.Write((int)ta.Nullability); });
                    trapFile.Write('>');
                }
            }

            AddParametersToId(m.Context, trapFile, m.symbol);
            switch (m.symbol.MethodKind)
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
            var index = 0;

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

        public virtual string Name => symbol.Name;

        /// <summary>
        /// Creates a method of the appropriate subtype.
        /// </summary>
        /// <param name="cx"></param>
        /// <param name="methodDecl"></param>
        /// <returns></returns>
        public static Method Create(Context cx, IMethodSymbol methodDecl)
        {
            if (methodDecl == null)
                return null;

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
                    return Accessor.GetPropertySymbol(methodDecl) is null ? OrdinaryMethod.Create(cx, methodDecl) : (Method)Accessor.Create(cx, methodDecl);
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
        public bool IsUnboundGeneric => IsGeneric && SymbolEqualityComparer.Default.Equals(symbol.ConstructedFrom, symbol);

        public bool IsBoundGeneric => IsGeneric && !IsUnboundGeneric;

        private bool IsReducedExtension => symbol.MethodKind == MethodKind.ReducedExtension;

        protected IMethodSymbol ConstructedFromSymbol => symbol.ConstructedFrom.ReducedFrom ?? symbol.ConstructedFrom;

        bool IExpressionParentEntity.IsTopLevelParent => true;

        bool IStatementParentEntity.IsTopLevelParent => true;

        protected void PopulateGenerics(TextWriter trapFile)
        {
            var isFullyConstructed = IsBoundGeneric;

            if (IsGeneric)
            {
                var child = 0;

                if (isFullyConstructed)
                {
                    trapFile.constructed_generic(this, Method.Create(Context, ConstructedFromSymbol));
                    foreach (var tp in symbol.GetAnnotatedTypeArguments())
                    {
                        trapFile.type_arguments(Type.Create(Context, tp.Symbol), child, this);
                        child++;
                    }

                    var nullability = new Nullability(symbol);
                    if (!nullability.IsOblivious)
                        trapFile.type_nullability(this, NullabilityEntity.Create(Context, nullability));
                }
                else
                {
                    foreach (var typeParam in symbol.TypeParameters.Select(tp => TypeParameter.Create(Context, tp)))
                    {
                        trapFile.type_parameters(typeParam, child, this);
                        child++;
                    }
                }
            }
        }

        protected void ExtractRefReturn(TextWriter trapFile)
        {
            if (symbol.ReturnsByRef)
                trapFile.type_annotation(this, Kinds.TypeAnnotation.Ref);
            if (symbol.ReturnsByRefReadonly)
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
            PopulateNullability(trapFile, symbol.GetAnnotatedReturnType());
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.PushesLabel;
    }
}
