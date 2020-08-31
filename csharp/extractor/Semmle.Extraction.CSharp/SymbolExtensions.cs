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
    /// Although a similar class has been implemented in Roslyn,
    /// https://github.com/dotnet/roslyn/blob/090e52e27c38ad8f1ea4d033114c2a107604ddaa/src/Compilers/CSharp/Portable/Symbols/TypeWithAnnotations.cs
    /// it is an internal struct that has not yet been exposed on the public interface.
    /// </summary>
    public struct AnnotatedTypeSymbol
    {
        public ITypeSymbol? Symbol;
        public NullableAnnotation Nullability;

        public AnnotatedTypeSymbol(ITypeSymbol? symbol, NullableAnnotation nullability)
        {
            Symbol = symbol;
            Nullability = nullability;
        }
    }

    static class SymbolExtensions
    {
        /// <summary>
        /// Tries to recover from an ErrorType.
        /// </summary>
        ///
        /// <param name="type">The type to disambiguate.</param>
        /// <returns></returns>
        public static ITypeSymbol? DisambiguateType(this ITypeSymbol? type)
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

            return type is IErrorTypeSymbol errorType && errorType.CandidateSymbols.Any() ?
                errorType.CandidateSymbols.First() as ITypeSymbol :
                type;
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
            var methodModifiers =
                symbol.DeclaringSyntaxReferences.
                Select(r => r.GetSyntax()).
                OfType<Microsoft.CodeAnalysis.CSharp.Syntax.BaseMethodDeclarationSyntax>().
                SelectMany(md => md.Modifiers);
            var typeModifiers =
                symbol.DeclaringSyntaxReferences.
                Select(r => r.GetSyntax()).
                OfType<Microsoft.CodeAnalysis.CSharp.Syntax.TypeDeclarationSyntax>().
                SelectMany(cd => cd.Modifiers);
            return methodModifiers.Concat(typeModifiers).Select(m => m.Text);
        }

        /// <summary>
        /// Holds if this type symbol contains a type parameter from the
        /// declaring generic <paramref name="declaringGeneric"/>.
        /// </summary>
        public static bool ContainsTypeParameters(this ITypeSymbol type, Context cx, ISymbol declaringGeneric)
        {
            using (cx.StackGuard)
            {
                switch (type.TypeKind)
                {
                    case TypeKind.Array:
                        var array = (IArrayTypeSymbol)type;
                        return array.ElementType.ContainsTypeParameters(cx, declaringGeneric);
                    case TypeKind.Class:
                    case TypeKind.Interface:
                    case TypeKind.Struct:
                    case TypeKind.Enum:
                    case TypeKind.Delegate:
                    case TypeKind.Error:
                        var named = (INamedTypeSymbol)type;
                        if (named.IsTupleType)
                            named = named.TupleUnderlyingType!;
                        if (named.ContainingType != null && named.ContainingType.ContainsTypeParameters(cx, declaringGeneric))
                            return true;
                        return named.TypeArguments.Any(arg => arg.ContainsTypeParameters(cx, declaringGeneric));
                    case TypeKind.Pointer:
                        var ptr = (IPointerTypeSymbol)type;
                        return ptr.PointedAtType.ContainsTypeParameters(cx, declaringGeneric);
                    case TypeKind.TypeParameter:
                        var tp = (ITypeParameterSymbol)type;
                        var declaringGen = tp.TypeParameterKind == TypeParameterKind.Method ? tp.DeclaringMethod : (ISymbol?)tp.DeclaringType;
                        return SymbolEqualityComparer.Default.Equals(declaringGen, declaringGeneric);
                    default:
                        return false;
                }
            }
        }

        /// <summary>
        /// Constructs a unique string for this type symbol.
        ///
        /// The supplied action <paramref name="subTermAction"/> is applied to the
        /// syntactic sub terms of this type (if any).
        /// </summary>
        /// <param name="cx">The extraction context.</param>
        /// <param name="trapFile">The trap builder used to store the result.</param>
        /// <param name="subTermAction">The action to apply to syntactic sub terms of this type.</param>
        public static void BuildTypeId(this ITypeSymbol type, Context cx, TextWriter trapFile, Action<Context, TextWriter, ITypeSymbol> subTermAction)
        {
            if (type.SpecialType != SpecialType.None)
            {
                /*
                 * Use the keyword ("int" etc) for the built-in types.
                 * This makes the IDs shorter and means that all built-in types map to
                 * the same entities (even when using multiple versions of mscorlib).
                 */
                trapFile.Write(type.ToDisplayString());
                return;
            }

            using (cx.StackGuard)
            {
                switch (type.TypeKind)
                {
                    case TypeKind.Array:
                        var array = (IArrayTypeSymbol)type;
                        subTermAction(cx, trapFile, array.ElementType);
                        array.BuildArraySuffix(trapFile);
                        return;
                    case TypeKind.Class:
                    case TypeKind.Interface:
                    case TypeKind.Struct:
                    case TypeKind.Enum:
                    case TypeKind.Delegate:
                    case TypeKind.Error:
                        var named = (INamedTypeSymbol)type;
                        named.BuildNamedTypeId(cx, trapFile, subTermAction);
                        return;
                    case TypeKind.Pointer:
                        var ptr = (IPointerTypeSymbol)type;
                        subTermAction(cx, trapFile, ptr.PointedAtType);
                        trapFile.Write('*');
                        return;
                    case TypeKind.TypeParameter:
                        var tp = (ITypeParameterSymbol)type;
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


        /// <summary>
        /// Constructs an array suffix string for this array type symbol.
        /// </summary>
        /// <param name="trapFile">The trap builder used to store the result.</param>
        public static void BuildArraySuffix(this IArrayTypeSymbol array, TextWriter trapFile)
        {
            trapFile.Write('[');
            for (int i = 0; i < array.Rank - 1; i++)
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

        static void BuildNamedTypeId(this INamedTypeSymbol named, Context cx, TextWriter trapFile, Action<Context, TextWriter, ITypeSymbol> subTermAction)
        {
            bool prefixAssembly = true;
            if (named.ContainingAssembly is null) prefixAssembly = false;

            if (named.IsTupleType)
            {
                trapFile.Write('(');
                trapFile.BuildList(",", named.TupleElements,
                    (f, tb0) =>
                    {
                        trapFile.Write(f.Name);
                        trapFile.Write(":");
                        subTermAction(cx, tb0, f.Type);
                    }
                    );
                trapFile.Write(")");
                return;
            }

            if (named.ContainingType != null)
            {
                subTermAction(cx, trapFile, named.ContainingType);
                trapFile.Write('.');
            }
            else if (named.ContainingNamespace != null)
            {
                if (prefixAssembly && named.ContainingAssembly is object)
                    BuildAssembly(named.ContainingAssembly, trapFile);
                named.ContainingNamespace.BuildNamespace(cx, trapFile);
            }

            if (named.IsAnonymousType)
                named.BuildAnonymousName(cx, trapFile, subTermAction, true);
            else if (named.TypeParameters.IsEmpty)
                trapFile.Write(named.Name);
            else if (IsReallyUnbound(named))
            {
                trapFile.Write(named.Name);
                trapFile.Write("`");
                trapFile.Write(named.TypeParameters.Length);
            }
            else
            {
                subTermAction(cx, trapFile, named.ConstructedFrom);
                trapFile.Write('<');
                // Encode the nullability of the type arguments in the label.
                // Type arguments with different nullability can result in
                // a constructed type with different nullability of its members and methods,
                // so we need to create a distinct database entity for it.
                trapFile.BuildList(",", named.GetAnnotatedTypeArguments(),
                    (ta, tb0) => subTermAction(cx, tb0, ta.Symbol)
                    );
                trapFile.Write('>');
            }
        }

        static void BuildNamespace(this INamespaceSymbol ns, Context cx, TextWriter trapFile)
        {
            trapFile.WriteSubId(Namespace.Create(cx, ns));
            trapFile.Write('.');
        }

        static void BuildAnonymousName(this ITypeSymbol type, Context cx, TextWriter trapFile, Action<Context, TextWriter, ITypeSymbol> subTermAction, bool includeParamName)
        {
            var buildParam = includeParamName
                ? (prop, tb0) =>
                {
                    tb0.Write(prop.Name);
                    tb0.Write(' ');
                    subTermAction(cx, tb0, prop.Type);
                }
            : (Action<IPropertySymbol, TextWriter>)((prop, tb0) => subTermAction(cx, tb0, prop.Type));
            int memberCount = type.GetMembers().OfType<IPropertySymbol>().Count();
            int hackTypeNumber = memberCount == 1 ? 1 : 0;
            trapFile.Write("<>__AnonType");
            trapFile.Write(hackTypeNumber);
            trapFile.Write('<');
            trapFile.BuildList(",", type.GetMembers().OfType<IPropertySymbol>(), buildParam);
            trapFile.Write('>');
        }

        /// <summary>
        /// Constructs a display name string for this type symbol.
        /// </summary>
        /// <param name="trapFile">The trap builder used to store the result.</param>
        public static void BuildDisplayName(this ITypeSymbol type, Context cx, TextWriter trapFile)
        {
            using (cx.StackGuard)
            {
                switch (type.TypeKind)
                {
                    case TypeKind.Array:
                        var array = (IArrayTypeSymbol)type;
                        var elementType = array.ElementType;
                        if (elementType.MetadataName.IndexOf("`") >= 0)
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
                        named.BuildNamedTypeDisplayName(cx, trapFile);
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

        public static void BuildNamedTypeDisplayName(this INamedTypeSymbol namedType, Context cx, TextWriter trapFile)
        {
            if (namedType.IsTupleType)
            {
                trapFile.Write('(');
                trapFile.BuildList(",", namedType.TupleElements.Select(f => f.Type),
                    (t, tb0) => t.BuildDisplayName(cx, tb0)
                    );

                trapFile.Write(")");
                return;
            }

            if (namedType.IsAnonymousType)
            {
                namedType.BuildAnonymousName(cx, trapFile, (cx0, tb0, sub) => sub.BuildDisplayName(cx0, tb0), false);
            }

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
        /// Gets the parameters of a method or property.
        /// </summary>
        /// <returns>The list of parameters, or an empty list.</returns>
        public static IEnumerable<IParameterSymbol> GetParameters(this ISymbol parameterizable)
        {
            if (parameterizable is IMethodSymbol method)
                return method.Parameters;

            if (parameterizable is IPropertySymbol property)
                return property.Parameters;

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

        public static IEntity? CreateEntity(this Context cx, ISymbol? symbol)
        {
            if (symbol == null) return null;

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
