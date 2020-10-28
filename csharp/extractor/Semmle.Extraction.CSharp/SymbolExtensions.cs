using Microsoft.CodeAnalysis;
using Semmle.Extraction.CSharp.Entities;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp
{
    /// <summary>
    /// An ITypeSymbol with nullability annotations.
    /// Although a similar class has been implemented in Rolsyn,
    /// https://github.com/dotnet/roslyn/blob/090e52e27c38ad8f1ea4d033114c2a107604ddaa/src/Compilers/CSharp/Portable/Symbols/TypeWithAnnotations.cs
    /// it is an internal struct that has not yet been exposed on the public interface.
    /// </summary>
    public struct AnnotatedTypeSymbol
    {
        public ITypeSymbol Symbol { get; set; }
        public NullableAnnotation Nullability { get; }

        public AnnotatedTypeSymbol(ITypeSymbol symbol, NullableAnnotation nullability)
        {
            Symbol = symbol;
            Nullability = nullability;
        }
    }

    internal static class SymbolExtensions
    {
        /// <summary>
        /// Tries to recover from an ErrorType.
        /// </summary>
        ///
        /// <param name="type">The type to disambiguate.</param>
        /// <returns></returns>
        public static ITypeSymbol DisambiguateType(this ITypeSymbol type)
        {
            /* A type could not be determined.
             * Sometimes this happens due to a missing reference,
             * or sometimes because the same type is defined in multiple places.
             *
             * In the case that a symbol is multiply-defined, Roslyn tells you which
             * symbols are candidates. It usually resolves to the same DB entity,
             * so it's reasonably safe to just pick a candidate.
             *
             * The conservative option would be to resolve all error types as null.
             */


            return type is IErrorTypeSymbol errorType && errorType.CandidateSymbols.Any()
                ? errorType.CandidateSymbols.First() as ITypeSymbol
                : type;
        }

        /// <summary>
        /// Gets the name of this symbol.
        ///
        /// If the symbol implements an explicit interface, only the
        /// name of the member being implemented is included, not the
        /// explicit prefix.
        /// </summary>
        public static string GetName(this ISymbol symbol, bool useMetadataName = false)
        {
            var name = useMetadataName ? symbol.MetadataName : symbol.Name;
            return symbol.CanBeReferencedByName ? name : name.Substring(symbol.Name.LastIndexOf('.') + 1);
        }

        /// <summary>
        /// Gets the source-level modifiers belonging to this symbol, if any.
        /// </summary>
        public static IEnumerable<string> GetSourceLevelModifiers(this ISymbol symbol)
        {
            var methodModifiers = symbol.DeclaringSyntaxReferences
                .Select(r => r.GetSyntax())
                .OfType<Microsoft.CodeAnalysis.CSharp.Syntax.BaseMethodDeclarationSyntax>()
                .SelectMany(md => md.Modifiers);
            var typeModifers = symbol.DeclaringSyntaxReferences
                .Select(r => r.GetSyntax())
                .OfType<Microsoft.CodeAnalysis.CSharp.Syntax.TypeDeclarationSyntax>()
                .SelectMany(cd => cd.Modifiers);
            return methodModifiers.Concat(typeModifers).Select(m => m.Text);
        }

        /// <summary>
        /// Holds if the ID generated for `dependant` will contain a reference to
        /// the ID for `symbol`. If this is the case, then the ID for `symbol` must
        /// not contain a reference back to `dependant`.
        /// </summary>
        public static bool IdDependsOn(this ITypeSymbol dependant, Context cx, ISymbol symbol)
        {
            var seen = new HashSet<ITypeSymbol>(SymbolEqualityComparer.Default);

            bool IdDependsOnImpl(ITypeSymbol type)
            {
                if (SymbolEqualityComparer.Default.Equals(type, symbol))
                    return true;

                if (type is null || seen.Contains(type))
                    return false;

                seen.Add(type);

                using (cx.StackGuard)
                {
                    switch (type.TypeKind)
                    {
                        case TypeKind.Array:
                            var array = (IArrayTypeSymbol)type;
                            return IdDependsOnImpl(array.ElementType);
                        case TypeKind.Class:
                        case TypeKind.Interface:
                        case TypeKind.Struct:
                        case TypeKind.Enum:
                        case TypeKind.Delegate:
                        case TypeKind.Error:
                            var named = (INamedTypeSymbol)type;
                            if (named.IsTupleType && named.TupleUnderlyingType is object)
                                named = named.TupleUnderlyingType;
                            if (IdDependsOnImpl(named.ContainingType))
                                return true;
                            if (IdDependsOnImpl(named.GetNonObjectBaseType(cx)))
                                return true;
                            if (IdDependsOnImpl(named.ConstructedFrom))
                                return true;
                            return named.TypeArguments.Any(IdDependsOnImpl);
                        case TypeKind.Pointer:
                            var ptr = (IPointerTypeSymbol)type;
                            return IdDependsOnImpl(ptr.PointedAtType);
                        case TypeKind.TypeParameter:
                            var tp = (ITypeParameterSymbol)type;
                            return tp.ContainingSymbol is ITypeSymbol cont
                                ? IdDependsOnImpl(cont)
                                : SymbolEqualityComparer.Default.Equals(tp.ContainingSymbol, symbol);
                        default:
                            return false;
                    }
                }
            }

            return IdDependsOnImpl(dependant);
        }

        /// <summary>
        /// Constructs a unique string for this type symbol.
        ///
        /// The supplied action <paramref name="subTermAction"/> is applied to the
        /// syntactic sub terms of this type (if any).
        /// </summary>
        /// <param name="cx">The extraction context.</param>
        /// <param name="trapFile">The trap builder used to store the result.</param>
        /// <param name="symbolBeingDefined">The outer symbol being defined (to avoid recursive ids).</param>
        /// <param name="constructUnderlyingTupleType">Whether to build a type ID for the underlying `System.ValueTuple` struct in the case of tuple types.</param>
        public static void BuildTypeId(this ITypeSymbol type, Context cx, TextWriter trapFile, ISymbol symbolBeingDefined, bool constructUnderlyingTupleType = false) =>
            type.BuildTypeId(cx, trapFile, symbolBeingDefined, true, constructUnderlyingTupleType);

        private static void BuildTypeId(this ITypeSymbol type, Context cx, TextWriter trapFile, ISymbol symbolBeingDefined, bool addBaseClass, bool constructUnderlyingTupleType)
        {
            using (cx.StackGuard)
            {
                switch (type.TypeKind)
                {
                    case TypeKind.Array:
                        var array = (IArrayTypeSymbol)type;
                        array.ElementType.BuildOrWriteId(cx, trapFile, symbolBeingDefined, addBaseClass);
                        array.BuildArraySuffix(trapFile);
                        return;
                    case TypeKind.Class:
                    case TypeKind.Interface:
                    case TypeKind.Struct:
                    case TypeKind.Enum:
                    case TypeKind.Delegate:
                    case TypeKind.Error:
                        var named = (INamedTypeSymbol)type;
                        named.BuildNamedTypeId(cx, trapFile, symbolBeingDefined, addBaseClass, constructUnderlyingTupleType);
                        return;
                    case TypeKind.Pointer:
                        var ptr = (IPointerTypeSymbol)type;
                        ptr.PointedAtType.BuildOrWriteId(cx, trapFile, symbolBeingDefined, addBaseClass);
                        trapFile.Write('*');
                        return;
                    case TypeKind.TypeParameter:
                        var tp = (ITypeParameterSymbol)type;
                        tp.ContainingSymbol.BuildOrWriteId(cx, trapFile, symbolBeingDefined, addBaseClass);
                        trapFile.Write('_');
                        trapFile.Write(tp.Name);
                        return;
                    case TypeKind.Dynamic:
                        trapFile.Write("dynamic");
                        return;
                    default:
                        throw new InternalError(type, $"Unhandled type kind '{type.TypeKind}'");
                }
            }
        }

        private static void BuildOrWriteId(this ISymbol symbol, Context cx, TextWriter trapFile, ISymbol symbolBeingDefined, bool addBaseClass, bool constructUnderlyingTupleType = false)
        {
            // We need to keep track of the symbol being defined in order to avoid cyclic labels.
            // For example, in
            //
            // ```csharp
            // class C<T> : IEnumerable<T> { }
            // ```
            //
            // when we generate the label for ``C`1``, the base class `IEnumerable<T>` has `T` as a type
            // argument, which will be qualified with `__self__` instead of the label we are defining.
            // In effect, the label will (simplified) look like
            //
            // ```
            // #123 = @"C`1 : IEnumerable<__self___T>"
            // ```
            if (SymbolEqualityComparer.Default.Equals(symbol, symbolBeingDefined))
                trapFile.Write("__self__");
            else if (symbol is ITypeSymbol type && type.IdDependsOn(cx, symbolBeingDefined))
                type.BuildTypeId(cx, trapFile, symbolBeingDefined, addBaseClass, constructUnderlyingTupleType);
            else if (symbol is INamedTypeSymbol namedType && namedType.IsTupleType && constructUnderlyingTupleType)
                trapFile.WriteSubId(NamedType.CreateNamedTypeFromTupleType(cx, namedType));
            else
                trapFile.WriteSubId(CreateEntity(cx, symbol));
        }

        /// <summary>
        /// Adds an appropriate ID to the trap builder <paramref name="trapFile"/>
        /// for the symbol <paramref name="symbol"/> belonging to
        /// <paramref name="symbolBeingDefined"/>.
        ///
        /// This will either write a reference to the ID of the entity belonging to
        /// <paramref name="symbol"/> (`{#label}`), or if that will lead to cyclic IDs,
        /// it will generate an appropriate ID that encodes the signature of
        /// <paramref name="symbol" />.
        /// </summary>
        public static void BuildOrWriteId(this ISymbol symbol, Context cx, TextWriter trapFile, ISymbol symbolBeingDefined) =>
            symbol.BuildOrWriteId(cx, trapFile, symbolBeingDefined, true);

        /// <summary>
        /// Constructs an array suffix string for this array type symbol.
        /// </summary>
        /// <param name="trapFile">The trap builder used to store the result.</param>
        public static void BuildArraySuffix(this IArrayTypeSymbol array, TextWriter trapFile)
        {
            trapFile.Write('[');
            for (var i = 0; i < array.Rank - 1; i++)
                trapFile.Write(',');
            trapFile.Write(']');
        }

        private static void BuildAssembly(IAssemblySymbol asm, TextWriter trapFile, bool extraPrecise = false)
        {
            var assembly = asm.Identity;
            trapFile.Write(assembly.Name);
            trapFile.Write('_');
            trapFile.Write(assembly.Version.Major);
            trapFile.Write('.');
            trapFile.Write(assembly.Version.Minor);
            trapFile.Write('.');
            trapFile.Write(assembly.Version.Build);
            if (extraPrecise)
            {
                trapFile.Write('.');
                trapFile.Write(assembly.Version.Revision);
            }
            trapFile.Write("::");
        }

        private static void BuildNamedTypeId(this INamedTypeSymbol named, Context cx, TextWriter trapFile, ISymbol symbolBeingDefined, bool addBaseClass, bool constructUnderlyingTupleType)
        {
            if (!constructUnderlyingTupleType && named.IsTupleType)
            {
                trapFile.Write('(');
                trapFile.BuildList(",", named.TupleElements,
                    (f, tb0) =>
                    {
                        trapFile.Write(f.Name);
                        trapFile.Write(":");
                        f.Type.BuildOrWriteId(cx, tb0, symbolBeingDefined, addBaseClass);
                    }
                    );
                trapFile.Write(")");
                return;
            }

            void AddContaining()
            {
                if (named.ContainingType != null)
                {
                    named.ContainingType.BuildOrWriteId(cx, trapFile, symbolBeingDefined, addBaseClass);
                    trapFile.Write('.');
                }
                else if (named.ContainingNamespace != null)
                {
                    if (cx.ShouldAddAssemblyTrapPrefix && named.ContainingAssembly is object)
                        BuildAssembly(named.ContainingAssembly, trapFile);
                    named.ContainingNamespace.BuildNamespace(cx, trapFile);
                }
            }

            if (named.TypeParameters.IsEmpty)
            {
                AddContaining();
                trapFile.Write(named.Name);
            }
            else if (named.IsReallyUnbound())
            {
                AddContaining();
                trapFile.Write(named.Name);
                trapFile.Write("`");
                trapFile.Write(named.TypeParameters.Length);
            }
            else
            {
                named.ConstructedFrom.BuildOrWriteId(cx, trapFile, symbolBeingDefined, addBaseClass, constructUnderlyingTupleType);
                trapFile.Write('<');
                // Encode the nullability of the type arguments in the label.
                // Type arguments with different nullability can result in
                // a constructed type with different nullability of its members and methods,
                // so we need to create a distinct database entity for it.
                trapFile.BuildList(",", named.GetAnnotatedTypeArguments(),
                    (ta, tb0) => ta.Symbol.BuildOrWriteId(cx, tb0, symbolBeingDefined, addBaseClass)
                    );
                trapFile.Write('>');
            }

            if (addBaseClass && named.GetNonObjectBaseType(cx) is INamedTypeSymbol @base)
            {
                // We need to limit unfolding of base classes. For example, in
                //
                // ```csharp
                // class C1<T> { }
                // class C2<T> : C1<C3<T>> { }
                // class C3<T> : C1<C2<T>> { }
                // class C4 : C3<C4> { }
                // ```
                //
                // when we generate the label for `C4`, the base class `C3<C4>` has itself `C1<C2<C4>>` as
                // a base class, which in turn has `C1<C3<C4>>` as a base class. The latter has the original
                // base class `C3<C4>` as a type argument, which would lead to infinite unfolding.
                trapFile.Write(" : ");
                @base.BuildOrWriteId(cx, trapFile, symbolBeingDefined, addBaseClass: false);
            }
        }

        private static void BuildNamespace(this INamespaceSymbol ns, Context cx, TextWriter trapFile)
        {
            trapFile.WriteSubId(Namespace.Create(cx, ns));
            trapFile.Write('.');
        }

        private static void BuildAnonymousName(this INamedTypeSymbol type, Context cx, TextWriter trapFile)
        {
            var memberCount = type.GetMembers().OfType<IPropertySymbol>().Count();
            var hackTypeNumber = memberCount == 1 ? 1 : 0;
            trapFile.Write("<>__AnonType");
            trapFile.Write(hackTypeNumber);
            trapFile.Write('<');
            trapFile.BuildList(",", type.GetMembers().OfType<IPropertySymbol>(), (prop, tb0) => BuildDisplayName(prop.Type, cx, tb0));
            trapFile.Write('>');
        }

        /// <summary>
        /// Constructs a display name string for this type symbol.
        /// </summary>
        /// <param name="trapFile">The trap builder used to store the result.</param>
        public static void BuildDisplayName(this ITypeSymbol type, Context cx, TextWriter trapFile, bool constructUnderlyingTupleType = false)
        {
            using (cx.StackGuard)
            {
                switch (type.TypeKind)
                {
                    case TypeKind.Array:
                        var array = (IArrayTypeSymbol)type;
                        var elementType = array.ElementType;
                        if (elementType.MetadataName.Contains("`"))
                        {
                            trapFile.Write(elementType.Name);
                            return;
                        }
                        elementType.BuildDisplayName(cx, trapFile);
                        array.BuildArraySuffix(trapFile);
                        return;
                    case TypeKind.Class:
                    case TypeKind.Interface:
                    case TypeKind.Struct:
                    case TypeKind.Enum:
                    case TypeKind.Delegate:
                    case TypeKind.Error:
                        var named = (INamedTypeSymbol)type;
                        named.BuildNamedTypeDisplayName(cx, trapFile, constructUnderlyingTupleType);
                        return;
                    case TypeKind.Pointer:
                        var ptr = (IPointerTypeSymbol)type;
                        ptr.PointedAtType.BuildDisplayName(cx, trapFile);
                        trapFile.Write('*');
                        return;
                    case TypeKind.TypeParameter:
                        trapFile.Write(type.Name);
                        return;
                    case TypeKind.Dynamic:
                        trapFile.Write("dynamic");
                        return;
                    default:
                        throw new InternalError(type, $"Unhandled type kind '{type.TypeKind}'");
                }
            }
        }

        public static void BuildNamedTypeDisplayName(this INamedTypeSymbol namedType, Context cx, TextWriter trapFile, bool constructUnderlyingTupleType)
        {
            if (!constructUnderlyingTupleType && namedType.IsTupleType)
            {
                trapFile.Write('(');
                trapFile.BuildList(",", namedType.TupleElements.Select(f => f.Type),
                    (t, tb0) => t.BuildDisplayName(cx, tb0)
                    );

                trapFile.Write(")");
                return;
            }

            if (namedType.IsAnonymousType)
                namedType.BuildAnonymousName(cx, trapFile);
            else
                trapFile.Write(namedType.Name);
            if (namedType.IsGenericType && namedType.TypeKind != TypeKind.Error && namedType.TypeArguments.Any())
            {
                trapFile.Write('<');
                trapFile.BuildList(",", namedType.TypeArguments, (p, tb0) =>
                {
                    if (IsReallyBound(namedType))
                        p.BuildDisplayName(cx, tb0);
                });
                trapFile.Write('>');
            }
        }

        public static bool IsReallyUnbound(this INamedTypeSymbol type) =>
            SymbolEqualityComparer.Default.Equals(type.ConstructedFrom, type) || type.IsUnboundGenericType;

        public static bool IsReallyBound(this INamedTypeSymbol type) => !IsReallyUnbound(type);

        /// <summary>
        /// Holds if this type is of the form <code>int?</code> or
        /// <code>System.Nullable<int></code>.
        /// </summary>
        public static bool IsBoundNullable(this ITypeSymbol type) =>
            type.SpecialType == SpecialType.None && type.OriginalDefinition.IsUnboundNullable();

        /// <summary>
        /// Holds if this type is <code>System.Nullable<T></code>.
        /// </summary>
        public static bool IsUnboundNullable(this ITypeSymbol type) =>
            type.SpecialType == SpecialType.System_Nullable_T;

        /// <summary>
        /// Holds if this type is <code>System.Span<T></code>.
        /// </summary>
        public static bool IsUnboundSpan(this ITypeSymbol type) =>
            type.ToString() == "System.Span<T>";

        /// <summary>
        /// Holds if this type is of the form <code>System.Span<byte></code>.
        /// </summary>
        public static bool IsBoundSpan(this ITypeSymbol type) =>
            type.SpecialType == SpecialType.None && type.OriginalDefinition.IsUnboundSpan();

        /// <summary>
        /// Holds if this type is <code>System.ReadOnlySpan<T></code>.
        /// </summary>
        public static bool IsUnboundReadOnlySpan(this ITypeSymbol type) =>
            type.ToString() == "System.ReadOnlySpan<T>";

        /// <summary>
        /// Holds if this type is of the form <code>System.ReadOnlySpan<byte></code>.
        /// </summary>
        public static bool IsBoundReadOnlySpan(this ITypeSymbol type) =>
            type.SpecialType == SpecialType.None && type.OriginalDefinition.IsUnboundReadOnlySpan();

        /// <summary>
        /// Gets the parameters of a method or property.
        /// </summary>
        /// <returns>The list of parameters, or an empty list.</returns>
        public static IEnumerable<IParameterSymbol> GetParameters(this ISymbol parameterizable)
        {
            if (parameterizable is IMethodSymbol meth)
                return meth.Parameters;

            if (parameterizable is IPropertySymbol prop)
                return prop.Parameters;

            return Enumerable.Empty<IParameterSymbol>();
        }

        /// <summary>
        /// Holds if this symbol is defined in a source code file.
        /// </summary>
        public static bool FromSource(this ISymbol symbol) => symbol.Locations.Any(l => l.IsInSource);

        /// <summary>
        /// Holds if this symbol is a source declaration.
        /// </summary>
        public static bool IsSourceDeclaration(this ISymbol symbol) => SymbolEqualityComparer.Default.Equals(symbol, symbol.OriginalDefinition);

        /// <summary>
        /// Holds if this method is a source declaration.
        /// </summary>
        public static bool IsSourceDeclaration(this IMethodSymbol method) =>
            IsSourceDeclaration((ISymbol)method) && SymbolEqualityComparer.Default.Equals(method, method.ConstructedFrom) && method.ReducedFrom == null;

        /// <summary>
        /// Holds if this parameter is a source declaration.
        /// </summary>
        public static bool IsSourceDeclaration(this IParameterSymbol parameter)
        {
            if (parameter.ContainingSymbol is IMethodSymbol method)
                return method.IsSourceDeclaration();
            if (parameter.ContainingSymbol is IPropertySymbol property && property.IsIndexer)
                return property.IsSourceDeclaration();
            return true;
        }

        /// <summary>
        /// Gets the base type of `symbol`. Unlike `symbol.BaseType`, this excludes effective base
        /// types of type parameters as well as `object` base types.
        /// </summary>
        public static INamedTypeSymbol GetNonObjectBaseType(this ITypeSymbol symbol, Context cx) =>
            symbol is ITypeParameterSymbol || SymbolEqualityComparer.Default.Equals(symbol.BaseType, cx.Compilation.ObjectType) ? null : symbol.BaseType;

        public static IEntity CreateEntity(this Context cx, ISymbol symbol)
        {
            if (symbol == null)
                return null;

            using (cx.StackGuard)
            {
                try
                {
                    return symbol.Accept(new Populators.Symbols(cx));
                }
                catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
                {
                    cx.ModelError(symbol, $"Exception processing symbol '{symbol.Kind}' of type '{ex}': {symbol}");
                    return null;
                }
            }
        }

        public static TypeInfo GetTypeInfo(this Context cx, Microsoft.CodeAnalysis.CSharp.CSharpSyntaxNode node) =>
            cx.GetModel(node).GetTypeInfo(node);

        public static SymbolInfo GetSymbolInfo(this Context cx, Microsoft.CodeAnalysis.CSharp.CSharpSyntaxNode node) =>
            cx.GetModel(node).GetSymbolInfo(node);

        /// <summary>
        /// Determines the type of a node, or default
        /// if the type could not be determined.
        /// </summary>
        /// <param name="cx">Extractor context.</param>
        /// <param name="node">The node to determine.</param>
        /// <returns>The type symbol of the node, or default.</returns>
        public static AnnotatedTypeSymbol GetType(this Context cx, Microsoft.CodeAnalysis.CSharp.CSharpSyntaxNode node)
        {
            var info = GetTypeInfo(cx, node);
            return new AnnotatedTypeSymbol(info.Type.DisambiguateType(), info.Nullability.Annotation);
        }

        /// <summary>
        /// Gets the annotated type arguments of an INamedTypeSymbol.
        /// This has not yet been exposed on the public API.
        /// </summary>
        public static IEnumerable<AnnotatedTypeSymbol> GetAnnotatedTypeArguments(this INamedTypeSymbol symbol) =>
            symbol.TypeArguments.Zip(symbol.TypeArgumentNullableAnnotations, (t, a) => new AnnotatedTypeSymbol(t, a));
    }
}
