using Microsoft.CodeAnalysis;
using Semmle.Extraction.CSharp.Entities;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

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
        public ITypeSymbol Symbol;
        public NullableAnnotation Nullability;

        public AnnotatedTypeSymbol(ITypeSymbol symbol, NullableAnnotation nullability)
        {
            Symbol = symbol;
            Nullability = nullability;
        }
    }

    /// <summary>
    /// Marks where a type identifier is being generated, which could change
    /// the way that the identifier is generated.
    /// </summary>
    public enum TypeIdentifierContext
    {
        TypeName,
        TypeRef,
        AnonymousType,
        MethodName,
        MethodParam
    }

    static class SymbolExtensions
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

            var errorType = type as IErrorTypeSymbol;

            return errorType != null && errorType.CandidateSymbols.Any() ?
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
            var typeModifers =
                symbol.DeclaringSyntaxReferences.
                Select(r => r.GetSyntax()).
                OfType<Microsoft.CodeAnalysis.CSharp.Syntax.TypeDeclarationSyntax>().
                SelectMany(cd => cd.Modifiers);
            return methodModifiers.Concat(typeModifers).Select(m => m.Text);
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
                            named = named.TupleUnderlyingType;
                        if (named.ContainingType != null && named.ContainingType.ContainsTypeParameters(cx, declaringGeneric))
                            return true;
                        return named.TypeArguments.Any(arg => arg.ContainsTypeParameters(cx, declaringGeneric));
                    case TypeKind.Pointer:
                        var ptr = (IPointerTypeSymbol)type;
                        return ptr.PointedAtType.ContainsTypeParameters(cx, declaringGeneric);
                    case TypeKind.TypeParameter:
                        var tp = (ITypeParameterSymbol)type;
                        var declaringGen = tp.TypeParameterKind == TypeParameterKind.Method ? tp.DeclaringMethod : (ISymbol)tp.DeclaringType;
                        return Equals(declaringGen, declaringGeneric);
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
        public static void BuildTypeId(this ITypeSymbol type, Context cx, TextWriter trapFile, Action<Context, TextWriter, ITypeSymbol, ISymbol> subTermAction, TypeIdentifierContext tic, ISymbol genericContext)
        {
            switch(type.SpecialType)
            {
                case SpecialType.System_Object:
                case SpecialType.System_Void:
                case SpecialType.System_Boolean:
                case SpecialType.System_Char:
                case SpecialType.System_SByte:
                case SpecialType.System_Byte:
                case SpecialType.System_Int16:
                case SpecialType.System_UInt16:
                case SpecialType.System_Int32:
                case SpecialType.System_UInt32:
                case SpecialType.System_Int64:
                case SpecialType.System_UInt64:
                case SpecialType.System_Decimal:
                case SpecialType.System_Single:
                case SpecialType.System_Double:
                case SpecialType.System_String:
                case SpecialType.System_IntPtr:
                case SpecialType.System_UIntPtr:

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
                        subTermAction(cx, trapFile, array.ElementType, genericContext);
                        array.BuildArraySuffix(trapFile);
                        return;
                    case TypeKind.Class:
                    case TypeKind.Interface:
                    case TypeKind.Struct:
                    case TypeKind.Enum:
                    case TypeKind.Delegate:
                    case TypeKind.Error:
                        var named = (INamedTypeSymbol)type;
                        named.BuildNamedTypeId(cx, trapFile, subTermAction, tic, genericContext);
                        return;
                    case TypeKind.Pointer:
                        var ptr = (IPointerTypeSymbol)type;
                        subTermAction(cx, trapFile, ptr.PointedAtType, genericContext);
                        trapFile.Write("*");
                        return;
                    case TypeKind.TypeParameter:
                        var tp = (ITypeParameterSymbol)type;
                        switch(tp.TypeParameterKind)
                        {
                            case TypeParameterKind.Method:
                                if (!Equals(genericContext, tp.DeclaringMethod))
                                    trapFile.WriteSubId(Method.Create(cx, tp.DeclaringMethod));
                                trapFile.Write("!!");
                                break;
                            case TypeParameterKind.Type:
                                if (!Equals(genericContext,tp.DeclaringType))
                                    subTermAction(cx, trapFile, tp.DeclaringType, genericContext);
                                trapFile.Write("!");
                                break;
                        }
                        trapFile.Write(tp.Ordinal);
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

        public static void BuildNamedTypeId(this INamedTypeSymbol named, Context cx, TextWriter trapFile, Action<Context, TextWriter, ITypeSymbol, ISymbol> subTermAction, TypeIdentifierContext tic, ISymbol genericContext)
        {
            bool prefixAssembly = false;
            if (named.IsAnonymous()) prefixAssembly = true;
            else if(tic == TypeIdentifierContext.TypeName && cx.Extractor.TrapIdentifiers != TrapIdenfierMode.Imprecise) prefixAssembly = true;
            if (named.ContainingAssembly is null) prefixAssembly = false;

            if (prefixAssembly)
                BuildAssembly(named.ContainingAssembly, trapFile);

            if (named.IsTupleType)
            {
                trapFile.Write('(');
                trapFile.BuildList(",", named.TupleElements,
                    (f, tb0) =>
                    {
                        trapFile.Write(f.Name);
                        trapFile.Write(":");
                        subTermAction(cx, tb0, f.Type, genericContext);
                    }
                    );
                trapFile.Write(")");
                return;
            }

            if (named.ContainingType != null)
            {
                subTermAction(cx, trapFile, named.ContainingType, genericContext);
                trapFile.Write('.');
            }
            else if (named.ContainingNamespace != null && !named.IsConstructedGeneric())
            {
                named.ContainingNamespace.BuildNamespace(cx, trapFile);
            }

            if (named.IsAnonymousType)
                named.BuildAnonymousName(cx, trapFile, subTermAction, true, genericContext);
            else if (named.TypeParameters.IsEmpty)
                trapFile.Write(named.Name);
            else if (named.IsUnboundGeneric())
            {
                trapFile.Write(named.Name);
                trapFile.Write("`");
                trapFile.Write(named.TypeParameters.Length);
            }
            else
            {
                subTermAction(cx, trapFile, named.ConstructedFrom, genericContext);
                trapFile.Write('<');
                // Encode the nullability of the type arguments in the label.
                // Type arguments with different nullability can result in 
                // a constructed type with different nullability of its members and methods,
                // so we need to create a distinct database entity for it.
                trapFile.BuildList(",", named.GetAnnotatedTypeArguments(),
                    (ta, tb0) => subTermAction(cx, tb0, ta.Symbol, genericContext)
                    );
                trapFile.Write('>');
            }
        }

        static void BuildNamespace(this INamespaceSymbol ns, Context cx, TextWriter trapFile)
        {
            trapFile.WriteSubId(Namespace.Create(cx, ns));
            trapFile.Write('.');
        }

        static void BuildAnonymousName(this ITypeSymbol type, Context cx, TextWriter trapFile, Action<Context, TextWriter, ITypeSymbol, ISymbol> subTermAction, bool includeParamName, ISymbol genericContext)
        {
            var buildParam = includeParamName
                ? (prop, tb0) =>
                {
                    tb0.Write(prop.Name);
                    tb0.Write(' ');
                    subTermAction(cx, tb0, prop.Type, genericContext);
                }
            : (Action<IPropertySymbol, TextWriter>)((prop, tb0) => subTermAction(cx, tb0, prop.Type, genericContext));
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
                namedType.BuildAnonymousName(cx, trapFile, (cx0, tb0, sub, _) => sub.BuildDisplayName(cx0, tb0), false, namedType);
            }

            trapFile.Write(namedType.Name);
            if (namedType.IsGenericType && namedType.TypeArguments.Any())
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

        public static bool IsReallyBound(this INamedTypeSymbol type) => !IsUnboundGeneric(type);

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
            if (parameterizable is IMethodSymbol)
                return ((IMethodSymbol)parameterizable).Parameters;

            if (parameterizable is IPropertySymbol)
                return ((IPropertySymbol)parameterizable).Parameters;

            return Enumerable.Empty<IParameterSymbol>();
        }

        /// <summary>
        /// Holds if this symbol is defined in a source code file.
        /// </summary>
        public static bool FromSource(this ISymbol symbol) => symbol.Locations.Any(l => l.IsInSource);

        /// <summary>
        /// Holds if this symbol is a source declaration.
        /// </summary>
        public static bool IsSourceDeclaration(this ISymbol symbol) => Equals(symbol, symbol.OriginalDefinition);

        /// <summary>
        /// Holds if this method is a source declaration.
        /// </summary>
        public static bool IsSourceDeclaration(this IMethodSymbol method) =>
            IsSourceDeclaration((ISymbol)method) && Equals(method, method.ConstructedFrom) && method.ReducedFrom == null;

        /// <summary>
        /// Holds if this parameter is a source declaration.
        /// </summary>
        public static bool IsSourceDeclaration(this IParameterSymbol parameter)
        {
            var method = parameter.ContainingSymbol as IMethodSymbol;
            if (method != null)
                return method.IsSourceDeclaration();
            var property = parameter.ContainingSymbol as IPropertySymbol;
            if (property != null && property.IsIndexer)
                return property.IsSourceDeclaration();
            return true;
        }

        public static IEntity CreateEntity(this Context cx, ISymbol symbol)
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
        /// Gets the symbol for a particular syntax node.
        /// Throws an exception if the symbol is not found.
        /// </summary>
        ///
        /// <remarks>
        /// This gives a nicer message than a "null pointer exception",
        /// and should be used where we require a symbol to be resolved.
        /// </remarks>
        ///
        /// <param name="cx">The extraction context.</param>
        /// <param name="node">The syntax node.</param>
        /// <returns>The resolved symbol.</returns>
        public static ISymbol GetSymbol(this Context cx, Microsoft.CodeAnalysis.CSharp.CSharpSyntaxNode node)
        {
            var info = GetSymbolInfo(cx, node);
            if (info.Symbol == null)
            {
                throw new InternalError(node, "Could not resolve symbol");
            }

            return info.Symbol;
        }

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

        private static bool IsSpecialized(this IMethodSymbol method) =>
            method.IsGenericMethod &&
            !ReferenceEquals(method, method.OriginalDefinition) &&
            method.TypeParameters.Zip(method.TypeArguments, (a, b) => !ReferenceEquals(a, b)).Any(b => b);

        private static bool IsSpecialized(this INamedTypeSymbol type) =>
            type.IsGenericType &&
            !ReferenceEquals(type, type.OriginalDefinition) &&
            type.TypeParameters.Zip(type.TypeArguments, (a, b) => !ReferenceEquals(a, b)).Any(b => b);

        /// <summary>
        /// Holds if the type is unbound: either it is unconstructed, or
        /// it has been constructed with its own type parameters.
        /// </summary>
        public static bool IsUnboundGeneric(this INamedTypeSymbol type) =>
            type.IsGenericType && !type.IsSpecialized();

        /// <summary>
        /// Holds if the type is a constructed generic.
        /// </summary>
        public static bool IsConstructedGeneric(this INamedTypeSymbol type) =>
            type.IsGenericType && type.IsSpecialized();

        /// <summary>
        /// Holds if the method is unbound: either it is unconstructed, or
        /// it has been constructed with its own type parameters.
        /// </summary>
        public static bool IsUnboundGeneric(this IMethodSymbol method) =>
            method.IsGenericMethod && !method.IsSpecialized();

        /// <summary>
        /// Holds if this is a constructed type where all the type arguments
        /// equal the original type parameters. This type is not particularly useful
        /// and often gets confused with the unbound generic type.
        /// </summary>
        public static bool IsEvilTwin(this INamedTypeSymbol type) =>
            !Equals(type, type.ConstructedFrom) && type.IsUnboundGeneric();

        /// <summary>
        /// Holds if this type looks like an "anonymous" type. Names of anonymous types
        /// sometimes collide so they need to be handled separately.
        /// </summary>
        public static bool IsAnonymous(this INamedTypeSymbol type) =>
            type.IsAnonymousType || type.Name.StartsWith("<");

        /// <summary>
        /// Computes a hash of the dependencies of an assembly.
        /// The contents of the trap file is dependent upon which dependencies
        /// were resolved. Therefore, we need to compute this in order to determine
        /// whether we need to re-extract an assembly.
        /// Note: not currently used but might be useful.
        /// </summary>
        /// <param name="asm">The assembly to compute</param>
        /// <returns>A hash string.</returns>
        public static string HashDependencies(this IAssemblySymbol asm)
        {
            using (var shaAlg = new SHA256Managed())
            {
                var imports = asm.Modules.
                    SelectMany(m => m.ReferencedAssemblySymbols).
                    Select(r => r.Locations.IsEmpty ? "" : r.Identity.ToString()).
                    Aggregate("", (a, b) => a + b);
                var sha = shaAlg.ComputeHash(Encoding.ASCII.GetBytes(imports));

                var hex = new StringBuilder(sha.Length * 2);
                foreach (var b in sha)
                    hex.AppendFormat("{0:x2}", b);
                hex.Append('-');
                hex.Append(asm.Modules.SelectMany(m => m.ReferencedAssemblySymbols).Count(r => r.Locations.IsEmpty));
                return hex.ToString();
            }
        }
    }
}
