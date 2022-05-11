using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Populators;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    internal abstract class Method : CachedSymbol<IMethodSymbol>, IExpressionParentEntity, IStatementParentEntity
    {
        protected Method(Context cx, IMethodSymbol init)
            : base(cx, init) { }

        protected void PopulateParameters()
        {
            var originalMethod = OriginalDefinition;
            IEnumerable<IParameterSymbol> parameters = Symbol.Parameters;
            IEnumerable<IParameterSymbol> originalParameters = originalMethod.Symbol.Parameters;

            foreach (var p in parameters.Zip(originalParameters, (paramSymbol, originalParam) => new { paramSymbol, originalParam }))
            {
                var original = SymbolEqualityComparer.Default.Equals(p.paramSymbol, p.originalParam)
                    ? null
                    : Parameter.Create(Context, p.originalParam, originalMethod);
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

        private void PopulateMethodBody(TextWriter trapFile)
        {
            if (!IsSourceDeclaration)
                return;

            var block = Block;
            var expr = ExpressionBody;

            if (block is not null || expr is not null)
            {
                Context.PopulateLater(
                   () =>
                   {
                       ExtractInitializers(trapFile);
                       if (block is not null)
                           Statements.Block.Create(Context, block, this, 0);
                       else
                           Expression.Create(Context, expr!, this, 0);

                       NumberOfLines(trapFile, BodyDeclaringSymbol, this);
                   });
            }
        }

        public static void NumberOfLines(TextWriter trapFile, ISymbol symbol, IEntity callable)
        {
            foreach (var decl in symbol.DeclaringSyntaxReferences)
            {
                var node = (CSharpSyntaxNode)decl.GetSyntax();
                var lineCounts = node.Accept(new AstLineCounter());
                if (lineCounts is not null)
                {
                    trapFile.numlines(callable, lineCounts);
                }
            }
        }

        public void Overrides(TextWriter trapFile)
        {
            foreach (var explicitInterface in Symbol.ExplicitInterfaceImplementations
                .Where(sym => sym.MethodKind == MethodKind.Ordinary)
                .Select(impl => Type.Create(Context, impl.ContainingType)))
            {
                trapFile.explicitly_implements(this, explicitInterface.TypeRef);

                if (IsSourceDeclaration)
                {
                    foreach (var syntax in Symbol.DeclaringSyntaxReferences.Select(d => d.GetSyntax()).OfType<MethodDeclarationSyntax>())
                        TypeMention.Create(Context, syntax.ExplicitInterfaceSpecifier!.Name, this, explicitInterface);
                }
            }

            if (Symbol.OverriddenMethod is not null)
            {
                trapFile.overrides(this, Method.Create(Context, Symbol.OverriddenMethod));
            }
        }

        /// <summary>
        ///  Factored out to share logic between `Method` and `UserOperator`.
        /// </summary>
        private static void BuildMethodId(Method m, EscapingTextWriter trapFile)
        {
            if (!SymbolEqualityComparer.Default.Equals(m.Symbol, m.Symbol.OriginalDefinition))
            {
                if (!SymbolEqualityComparer.Default.Equals(m.Symbol, m.ConstructedFromSymbol))
                {
                    trapFile.WriteSubId(Create(m.Context, m.ConstructedFromSymbol));
                    trapFile.Write('<');
                    // Encode the nullability of the type arguments in the label.
                    // Type arguments with different nullability can result in
                    // a constructed method with different nullability of its parameters and return type,
                    // so we need to create a distinct database entity for it.
                    trapFile.BuildList(",", m.Symbol.GetAnnotatedTypeArguments(), ta => { ta.Symbol.BuildOrWriteId(m.Context, trapFile, m.Symbol); trapFile.Write((int)ta.Nullability); });
                    trapFile.Write('>');
                }
                else
                {
                    trapFile.WriteSubId(m.ContainingType!);
                    trapFile.Write(".");
                    trapFile.WriteSubId(m.OriginalDefinition);
                }

                WritePostfix(m, trapFile);
                return;
            }

            m.Symbol.ReturnType.BuildOrWriteId(m.Context, trapFile, m.Symbol);
            trapFile.Write(" ");

            trapFile.WriteSubId(m.ContainingType!);

            AddExplicitInterfaceQualifierToId(m.Context, trapFile, m.Symbol.ExplicitInterfaceImplementations);

            trapFile.Write(".");
            trapFile.Write(m.Symbol.Name);

            if (m.Symbol.IsGenericMethod)
            {
                trapFile.Write('`');
                trapFile.Write(m.Symbol.TypeParameters.Length);
            }

            AddParametersToId(m.Context, trapFile, m.Symbol);
            WritePostfix(m, trapFile);
        }

        private static void WritePostfix(Method m, EscapingTextWriter trapFile)
        {
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

        public override void WriteId(EscapingTextWriter trapFile)
        {
            BuildMethodId(this, trapFile);
        }

        protected static void AddParametersToId(Context cx, EscapingTextWriter trapFile, IMethodSymbol method)
        {
            trapFile.Write('(');
            var index = 0;

            var @params = method.Parameters;

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

        public static void AddExplicitInterfaceQualifierToId(Context cx, EscapingTextWriter trapFile, IEnumerable<ISymbol> explicitInterfaceImplementations)
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
        [return: NotNullIfNotNull("methodDecl")]
        public static Method? Create(Context cx, IMethodSymbol? methodDecl)
        {
            if (methodDecl is null)
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
                    if (SymbolEqualityComparer.Default.Equals(methodDecl, methodDecl.ConstructedFrom))
                    {
                        return OrdinaryMethod.Create(cx, methodDecl.ReducedFrom!);
                    }
                    return OrdinaryMethod.Create(cx, methodDecl.ReducedFrom!.Construct(methodDecl.TypeArguments, methodDecl.TypeArgumentNullableAnnotations));
                case MethodKind.Ordinary:
                case MethodKind.DelegateInvoke:
                    return OrdinaryMethod.Create(cx, methodDecl);
                case MethodKind.Destructor:
                    return Destructor.Create(cx, methodDecl);
                case MethodKind.PropertyGet:
                case MethodKind.PropertySet:
                    return Accessor.GetPropertySymbol(methodDecl) is IPropertySymbol prop ? Accessor.Create(cx, methodDecl, prop) : OrdinaryMethod.Create(cx, methodDecl);
                case MethodKind.EventAdd:
                case MethodKind.EventRemove:
                    return EventAccessor.GetEventSymbol(methodDecl) is IEventSymbol @event ? EventAccessor.Create(cx, methodDecl, @event) : OrdinaryMethod.Create(cx, methodDecl);
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

        public Method OriginalDefinition => Create(Context, Symbol.OriginalDefinition);

        public override Location? FullLocation => ReportingLocation;

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

        protected IMethodSymbol ConstructedFromSymbol => Symbol.ConstructedFrom;

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

        public static void ExtractRefReturn(TextWriter trapFile, IMethodSymbol method, IEntity element)
        {
            if (method.ReturnsByRef)
                trapFile.type_annotation(element, Kinds.TypeAnnotation.Ref);
            if (method.ReturnsByRefReadonly)
                trapFile.type_annotation(element, Kinds.TypeAnnotation.ReadonlyRef);
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
