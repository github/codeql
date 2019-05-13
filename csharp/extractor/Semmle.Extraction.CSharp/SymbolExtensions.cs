using Microsoft.CodeAnalysis;
using Semmle.Extraction.CSharp.Entities;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Semmle.Extraction.CSharp
{
    static class SymbolExtensions
    {
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
        /// <param name="tb">The trap builder used to store the result.</param>
        /// <param name="subTermAction">The action to apply to syntactic sub terms of this type.</param>
        public static void BuildTypeId(this ITypeSymbol type, Context cx, ITrapBuilder tb, Action<Context, ITrapBuilder, ITypeSymbol> subTermAction)
        {
            if (type.SpecialType != SpecialType.None)
            {
                /*
                 * Use the keyword ("int" etc) for the built-in types.
                 * This makes the IDs shorter and means that all built-in types map to
                 * the same entities (even when using multiple versions of mscorlib).
                 */
                tb.Append(type.ToDisplayString());
                return;
            }

            using (cx.StackGuard)
            {
                switch (type.TypeKind)
                {
                    case TypeKind.Array:
                        var array = (IArrayTypeSymbol)type;
                        subTermAction(cx, tb, array.ElementType);
                        array.BuildArraySuffix(tb);
                        return;
                    case TypeKind.Class:
                    case TypeKind.Interface:
                    case TypeKind.Struct:
                    case TypeKind.Enum:
                    case TypeKind.Delegate:
                    case TypeKind.Error:
                        var named = (INamedTypeSymbol)type;
                        named.BuildNamedTypeId(cx, tb, subTermAction);
                        return;
                    case TypeKind.Pointer:
                        var ptr = (IPointerTypeSymbol)type;
                        subTermAction(cx, tb, ptr.PointedAtType);
                        tb.Append("*");
                        return;
                    case TypeKind.TypeParameter:
                        var tp = (ITypeParameterSymbol)type;
                        tb.Append(tp.Name);
                        return;
                    case TypeKind.Dynamic:
                        tb.Append("dynamic");
                        return;
                    default:
                        throw new InternalError(type, $"Unhandled type kind '{type.TypeKind}'");
                }
            }
        }

        /// <summary>
        /// Constructs an array suffix string for this array type symbol.
        /// </summary>
        /// <param name="tb">The trap builder used to store the result.</param>
        public static void BuildArraySuffix(this IArrayTypeSymbol array, ITrapBuilder tb)
        {
            tb.Append("[");
            for (int i = 0; i < array.Rank - 1; i++)
                tb.Append(",");
            tb.Append("]");
        }

        static void BuildNamedTypeId(this INamedTypeSymbol named, Context cx, ITrapBuilder tb, Action<Context, ITrapBuilder, ITypeSymbol> subTermAction)
        {
            if (named.IsTupleType)
            {
                tb.Append("(");
                tb.BuildList(",", named.TupleElements,
                    (f, tb0) =>
                    {
                        tb.Append(f.Name).Append(":");
                        subTermAction(cx, tb0, f.Type);
                    }
                    );
                tb.Append(")");
                return;
            }

            if (named.ContainingType != null)
            {
                subTermAction(cx, tb, named.ContainingType);
                tb.Append(".");
            }
            else if (named.ContainingNamespace != null)
            {
                named.ContainingNamespace.BuildNamespace(cx, tb);
            }

            if (named.IsAnonymousType)
                named.BuildAnonymousName(cx, tb, subTermAction, true);
            else if (named.TypeParameters.IsEmpty)
                tb.Append(named.Name);
            else if (IsReallyUnbound(named))
                tb.Append(named.Name).Append("`").Append(named.TypeParameters.Length);
            else
            {
                subTermAction(cx, tb, named.ConstructedFrom);
                tb.Append("<");
                tb.BuildList(",", named.TypeArguments, (ta, tb0) => subTermAction(cx, tb0, ta));
                tb.Append(">");
            }
        }

        static void BuildNamespace(this INamespaceSymbol ns, Context cx, ITrapBuilder tb)
        {
            // Only include the assembly information in each type ID
            // for normal extractions. This is because standalone extractions
            // lack assembly information or may be ambiguous.
            bool prependAssemblyToTypeId = !cx.Extractor.Standalone && ns.ContainingAssembly != null;

            if (prependAssemblyToTypeId)
            {
                // Note that we exclude the revision number as this has
                // been observed to be unstable.
                var assembly = ns.ContainingAssembly.Identity;
                tb.Append(assembly.Name).Append("_").
                    Append(assembly.Version.Major).Append(".").
                    Append(assembly.Version.Minor).Append(".").
                    Append(assembly.Version.Build).Append("::");
            }

            tb.Append(Namespace.Create(cx, ns)).Append(".");
        }

        static void BuildAnonymousName(this ITypeSymbol type, Context cx, ITrapBuilder tb, Action<Context, ITrapBuilder, ITypeSymbol> subTermAction, bool includeParamName)
        {
            var buildParam = includeParamName
                ? (prop, tb0) =>
                {
                    tb0.Append(prop.Name).Append(" ");
                    subTermAction(cx, tb0, prop.Type);
                }
            : (Action<IPropertySymbol, ITrapBuilder>)((prop, tb0) => subTermAction(cx, tb0, prop.Type));
            int memberCount = type.GetMembers().OfType<IPropertySymbol>().Count();
            int hackTypeNumber = memberCount == 1 ? 1 : 0;
            tb.Append("<>__AnonType");
            tb.Append(hackTypeNumber);
            tb.Append("<");
            tb.BuildList(",", type.GetMembers().OfType<IPropertySymbol>(), buildParam);
            tb.Append(">");
        }

        /// <summary>
        /// Constructs a display name string for this type symbol.
        /// </summary>
        /// <param name="tb">The trap builder used to store the result.</param>
        public static void BuildDisplayName(this ITypeSymbol type, Context cx, ITrapBuilder tb)
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
                            tb.Append(elementType.Name);
                            return;
                        }
                        elementType.BuildDisplayName(cx, tb);
                        array.BuildArraySuffix(tb);
                        return;
                    case TypeKind.Class:
                    case TypeKind.Interface:
                    case TypeKind.Struct:
                    case TypeKind.Enum:
                    case TypeKind.Delegate:
                    case TypeKind.Error:
                        var named = (INamedTypeSymbol)type;
                        named.BuildNamedTypeDisplayName(cx, tb);
                        return;
                    case TypeKind.Pointer:
                        var ptr = (IPointerTypeSymbol)type;
                        ptr.PointedAtType.BuildDisplayName(cx, tb);
                        tb.Append("*");
                        return;
                    case TypeKind.TypeParameter:
                        tb.Append(type.Name);
                        return;
                    case TypeKind.Dynamic:
                        tb.Append("dynamic");
                        return;
                    default:
                        throw new InternalError(type, $"Unhandled type kind '{type.TypeKind}'");
                }
            }
        }

        public static void BuildNamedTypeDisplayName(this INamedTypeSymbol namedType, Context cx, ITrapBuilder tb)
        {
            if (namedType.IsTupleType)
            {
                tb.Append("(");
                tb.BuildList(",", namedType.TupleElements.Select(f => f.Type),
                    (t, tb0) => t.BuildDisplayName(cx, tb0)
                    );

                tb.Append(")");
                return;
            }

            if (namedType.IsAnonymousType)
            {
                namedType.BuildAnonymousName(cx, tb, (cx0, tb0, sub) => sub.BuildDisplayName(cx0, tb0), false);
            }

            tb.Append(namedType.Name);
            if (namedType.IsGenericType && namedType.TypeKind != TypeKind.Error && namedType.TypeArguments.Any())
            {
                tb.Append("<");
                tb.BuildList(",", namedType.TypeArguments, (p, tb0) =>
                {
                    if (IsReallyBound(namedType))
                        p.BuildDisplayName(cx, tb0);
                });
                tb.Append(">");
            }
        }

        public static bool IsReallyUnbound(this INamedTypeSymbol type) =>
            Equals(type.ConstructedFrom, type) || type.IsUnboundGenericType;

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
    }
}
