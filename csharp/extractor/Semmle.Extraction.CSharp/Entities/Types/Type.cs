using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.Entities
{
    internal abstract class Type : CachedSymbol<ITypeSymbol>
    {
#nullable disable warnings
        protected Type(Context cx, ITypeSymbol? init)
            : base(cx, init) { }
#nullable restore warnings

        public override bool NeedsPopulation =>
            base.NeedsPopulation || Symbol.TypeKind == TypeKind.Dynamic || Symbol.TypeKind == TypeKind.TypeParameter;

        public static bool ConstructedOrParentIsConstructed(INamedTypeSymbol symbol)
        {
            return !SymbolEqualityComparer.Default.Equals(symbol, symbol.OriginalDefinition) ||
                symbol.ContainingType is not null && ConstructedOrParentIsConstructed(symbol.ContainingType);
        }

        public Kinds.TypeKind GetTypeKind(Context cx, bool constructUnderlyingTupleType)
        {
            switch (Symbol.SpecialType)
            {
                case SpecialType.System_Int32: return Kinds.TypeKind.INT;
                case SpecialType.System_UInt32: return Kinds.TypeKind.UINT;
                case SpecialType.System_Int16: return Kinds.TypeKind.SHORT;
                case SpecialType.System_UInt16: return Kinds.TypeKind.USHORT;
                case SpecialType.System_UInt64: return Kinds.TypeKind.ULONG;
                case SpecialType.System_Int64: return Kinds.TypeKind.LONG;
                case SpecialType.System_Void: return Kinds.TypeKind.VOID;
                case SpecialType.System_Double: return Kinds.TypeKind.DOUBLE;
                case SpecialType.System_Byte: return Kinds.TypeKind.BYTE;
                case SpecialType.System_SByte: return Kinds.TypeKind.SBYTE;
                case SpecialType.System_Boolean: return Kinds.TypeKind.BOOL;
                case SpecialType.System_Char: return Kinds.TypeKind.CHAR;
                case SpecialType.System_Decimal: return Kinds.TypeKind.DECIMAL;
                case SpecialType.System_Single: return Kinds.TypeKind.FLOAT;
                case SpecialType.System_IntPtr: return Kinds.TypeKind.INT_PTR;
                default:
                    if (Symbol.IsBoundNullable())
                        return Kinds.TypeKind.NULLABLE;

                    switch (Symbol.TypeKind)
                    {
                        case TypeKind.Class: return Kinds.TypeKind.CLASS;
                        case TypeKind.Struct:
                            {
                                if (((INamedTypeSymbol)Symbol).IsTupleType && !constructUnderlyingTupleType)
                                {
                                    return Kinds.TypeKind.TUPLE;
                                }
                                return Symbol.IsInlineArray()
                                    ? Kinds.TypeKind.INLINE_ARRAY
                                    : Kinds.TypeKind.STRUCT;
                            }
                        case TypeKind.Interface: return Kinds.TypeKind.INTERFACE;
                        case TypeKind.Array: return Kinds.TypeKind.ARRAY;
                        case TypeKind.Enum: return Kinds.TypeKind.ENUM;
                        case TypeKind.Delegate: return Kinds.TypeKind.DELEGATE;
                        case TypeKind.Pointer: return Kinds.TypeKind.POINTER;
                        case TypeKind.FunctionPointer: return Kinds.TypeKind.FUNCTION_POINTER;
                        case TypeKind.Error: return Kinds.TypeKind.UNKNOWN;
                        default:
                            cx.ModelError(Symbol, $"Unhandled type kind '{Symbol.TypeKind}'");
                            return Kinds.TypeKind.UNKNOWN;
                    }
            }
        }

        protected void PopulateType(TextWriter trapFile, bool constructUnderlyingTupleType = false)
        {
            PopulateAttributes();

            trapFile.Write("types(");
            trapFile.WriteColumn(this);
            trapFile.Write(',');
            trapFile.WriteColumn((int)GetTypeKind(Context, constructUnderlyingTupleType));
            trapFile.Write(",\"");
            Symbol.BuildDisplayName(Context, trapFile, constructUnderlyingTupleType);
            trapFile.WriteLine("\")");

            var baseTypes = GetBaseTypeDeclarations();

            var hasExpandingCycle = GenericsRecursionGraph.HasExpandingCycle(Symbol);
            if (hasExpandingCycle)
            {
                Context.ExtractionError("Found recursive generic inheritance hierarchy. Base class of type is not extracted", Symbol.ToDisplayString(), Context.CreateLocation(ReportingLocation), severity: Semmle.Util.Logging.Severity.Warning);
            }

            // Visit base types
            if (!hasExpandingCycle
                && Symbol.GetNonObjectBaseType(Context) is INamedTypeSymbol @base)
            {
                var bts = GetBaseTypeDeclarations(baseTypes, @base);

                Context.PopulateLater(() =>
                {
                    var baseKey = Create(Context, @base);
                    trapFile.extend(this, baseKey.TypeRef);

                    if (Symbol.TypeKind != TypeKind.Struct)
                    {
                        foreach (var bt in bts)
                        {
                            TypeMention.Create(Context, bt.Type, this, baseKey);
                        }
                    }
                });
            }

            // Visit implemented interfaces
            if (!(base.Symbol is IArrayTypeSymbol))
            {
                foreach (var i in base.Symbol.Interfaces)
                {
                    var bts = GetBaseTypeDeclarations(baseTypes, i);

                    Context.PopulateLater(() =>
                    {
                        var interfaceKey = Create(Context, i);
                        trapFile.implement(this, interfaceKey.TypeRef);

                        foreach (var bt in bts)
                        {
                            TypeMention.Create(Context, bt.Type, this, interfaceKey);
                        }
                    });
                }
            }

            var containingType = ContainingType;
            if (containingType is not null && Symbol.Kind != SymbolKind.TypeParameter)
            {
                var originalDefinition = Symbol.TypeKind == TypeKind.Error ? this : Create(Context, Symbol.OriginalDefinition);
                trapFile.nested_types(this, containingType, originalDefinition);
            }
            else if (Symbol.ContainingNamespace is not null)
            {
                trapFile.parent_namespace(this, Namespace.Create(Context, Symbol.ContainingNamespace));
            }

            if (Symbol is IArrayTypeSymbol array)
            {
                // They are in the namespace of the original object
                var elementType = array.ElementType;
                var ns = elementType.TypeKind == TypeKind.TypeParameter ? Context.Compilation.GlobalNamespace : elementType.ContainingNamespace;
                if (ns is not null)
                    trapFile.parent_namespace(this, Namespace.Create(Context, ns));
            }

            if (Symbol is IPointerTypeSymbol pointer)
            {
                var elementType = pointer.PointedAtType;
                var ns = elementType.TypeKind == TypeKind.TypeParameter ? Context.Compilation.GlobalNamespace : elementType.ContainingNamespace;

                if (ns is not null)
                    trapFile.parent_namespace(this, Namespace.Create(Context, ns));
            }

            if (Symbol.BaseType is not null && Symbol.BaseType.SpecialType == SpecialType.System_MulticastDelegate)
            {
                // This is a delegate.
                // The method "Invoke" has the return type.
                var invokeMethod = ((INamedTypeSymbol)Symbol).DelegateInvokeMethod!;
                ExtractParametersForDelegateLikeType(trapFile, invokeMethod,
                    t => trapFile.delegate_return_type(this, t));
            }

            if (Symbol is IFunctionPointerTypeSymbol functionPointer)
            {
                ExtractParametersForDelegateLikeType(trapFile, functionPointer.Signature,
                    t => trapFile.function_pointer_return_type(this, t));
            }

            Modifier.ExtractModifiers(Context, trapFile, this, Symbol);
        }

        private IEnumerable<BaseTypeSyntax> GetBaseTypeDeclarations()
        {
            if (!IsSourceDeclaration || !Symbol.FromSource())
            {
                return Enumerable.Empty<BaseTypeSyntax>();
            }

            var declSyntaxReferences = Symbol.DeclaringSyntaxReferences.Select(d => d.GetSyntax()).ToArray();

            var baseLists = declSyntaxReferences.OfType<ClassDeclarationSyntax>().Select(c => c.BaseList);
            baseLists = baseLists.Concat(declSyntaxReferences.OfType<InterfaceDeclarationSyntax>().Select(c => c.BaseList));
            baseLists = baseLists.Concat(declSyntaxReferences.OfType<StructDeclarationSyntax>().Select(c => c.BaseList));

            return baseLists
                .Where(bl => bl is not null)
                .SelectMany(bl => bl!.Types)
                .ToList();
        }

        private IEnumerable<BaseTypeSyntax> GetBaseTypeDeclarations(IEnumerable<BaseTypeSyntax> baseTypes, INamedTypeSymbol type)
        {
            return baseTypes.Where(bt => SymbolEqualityComparer.Default.Equals(Context.GetModel(bt).GetTypeInfo(bt.Type).Type, type));
        }

        private void ExtractParametersForDelegateLikeType(TextWriter trapFile, IMethodSymbol invokeMethod, Action<Type> storeReturnType)
        {
            for (var i = 0; i < invokeMethod.Parameters.Length; ++i)
            {
                var param = invokeMethod.Parameters[i];
                var originalParam = invokeMethod.OriginalDefinition.Parameters[i];
                var originalParamEntity = SymbolEqualityComparer.Default.Equals(param, originalParam)
                    ? null
                    : DelegateTypeParameter.Create(Context, originalParam, Create(Context, ((INamedTypeSymbol)Symbol).OriginalDefinition));
                DelegateTypeParameter.Create(Context, param, this, originalParamEntity);
            }

            var returnKey = Create(Context, invokeMethod.ReturnType);
            storeReturnType(returnKey.TypeRef);
            Method.ExtractRefReturn(trapFile, invokeMethod, this);
        }

        /// <summary>
        /// Called to extract members and nested types.
        /// This is called on each member of a namespace,
        /// in either source code or an assembly.
        /// </summary>
        public void ExtractRecursive()
        {
            foreach (var l in Symbol.DeclaringSyntaxReferences.Select(s => s.GetSyntax().GetLocation()))
            {
                Context.BindComments(this, l);
            }

            foreach (var member in Symbol.GetMembers().ExtractionCandidates())
            {
                switch (member.Kind)
                {
                    case SymbolKind.NamedType:
                        Create(Context, (ITypeSymbol)member).ExtractRecursive();
                        break;
                    default:
                        Context.CreateEntity(member);
                        break;
                }
            }
        }

        /// <summary>
        /// Extracts all members and nested types of this type.
        /// </summary>
        public void PopulateGenerics()
        {
            Context.PopulateLater(() =>
            {
                if (Symbol is null || !NeedsPopulation || !Context.ExtractGenerics(this))
                    return;

                var members = new List<ISymbol>();

                foreach (var member in Symbol.GetMembers().ExtractionCandidates())
                    members.Add(member);
                foreach (var member in Symbol.GetTypeMembers().ExtractionCandidates())
                    members.Add(member);

                // Mono extractor puts all BASE interface members as members of the current interface.

                if (Symbol.TypeKind == TypeKind.Interface)
                {
                    foreach (var baseInterface in Symbol.Interfaces.ExtractionCandidates())
                    {
                        foreach (var member in baseInterface.GetMembers())
                            members.Add(member);
                        foreach (var member in baseInterface.GetTypeMembers())
                            members.Add(member);
                    }
                }

                foreach (var member in members)
                {
                    Context.CreateEntity(member);
                }

                if (Symbol.BaseType is not null)
                    Create(Context, Symbol.BaseType).PopulateGenerics();

                foreach (var i in Symbol.Interfaces.ExtractionCandidates())
                {
                    Create(Context, i).PopulateGenerics();
                }
            }, preserveDuplicationKey: false);
        }

        public void ExtractRecursive(TextWriter trapFile, IEntity parent)
        {
            if (Symbol.ContainingSymbol.Kind == SymbolKind.Namespace && !Symbol.ContainingNamespace.IsGlobalNamespace)
            {
                trapFile.parent_namespace_declaration(this, (NamespaceDeclaration)parent);
            }

            ExtractRecursive();
        }

        public static Type Create(Context cx, ITypeSymbol? type)
        {
            type = type.DisambiguateType();
            return type is null
                ? NullType.Create(cx)
                : (Type)cx.CreateEntity(type);
        }

        public static Type Create(Context cx, AnnotatedTypeSymbol? type) =>
            Create(cx, type?.Symbol);

        public virtual int Dimension => 0;

        public static bool IsDelegate(ITypeSymbol? symbol) =>
            symbol is not null && symbol.TypeKind == TypeKind.Delegate;

        /// <summary>
        /// A copy of a delegate "Invoke" method or function pointer parameter.
        /// </summary>
        private class DelegateTypeParameter : Parameter
        {
            private DelegateTypeParameter(Context cx, IParameterSymbol init, IEntity parent, Parameter? original)
                : base(cx, init, parent, original) { }

            public static new DelegateTypeParameter Create(Context cx, IParameterSymbol param, IEntity parent, Parameter? original = null) =>
               // We need to use a different cache key than `param` to avoid mixing up
               // `DelegateTypeParameter`s and `Parameter`s
               DelegateTypeParameterFactory.Instance.CreateEntity(cx, (typeof(DelegateTypeParameter), new SymbolEqualityWrapper(param)), (param, parent, original));

            private class DelegateTypeParameterFactory : CachedEntityFactory<(IParameterSymbol, IEntity, Parameter?), DelegateTypeParameter>
            {
                public static DelegateTypeParameterFactory Instance { get; } = new DelegateTypeParameterFactory();

                public override DelegateTypeParameter Create(Context cx, (IParameterSymbol, IEntity, Parameter?) init) =>
                    new DelegateTypeParameter(cx, init.Item1, init.Item2, init.Item3);
            }
        }

        /// <summary>
        /// Gets a reference to this type, if the type
        /// is defined in another assembly.
        /// </summary>
        public virtual Type TypeRef => this;

        public virtual IEnumerable<Type> TypeMentions
        {
            get
            {
                yield break;
            }
        }

        public override bool Equals(object? obj)
        {
            var other = obj as Type;
            return other?.GetType() == GetType() && SymbolEqualityComparer.Default.Equals(other.Symbol, Symbol);
        }

        public override int GetHashCode() => SymbolEqualityComparer.Default.GetHashCode(Symbol);

        /// <summary>
        /// Class to detect recursive generic inheritance hierarchies.
        ///
        /// Details can be found in https://www.ecma-international.org/wp-content/uploads/ECMA-335_6th_edition_june_2012.pdf Chapter II.9.2 Generics and recursive inheritance graphs
        /// The dotnet runtime already implements this check as a runtime validation: https://github.com/dotnet/runtime/blob/e48e88d0fe9c2e494c0e6fd0c7c1fb54e7ddbdb1/src/coreclr/vm/generics.cpp#L748
        /// </summary>
        private class GenericsRecursionGraph
        {
            private static readonly ConcurrentDictionary<INamedTypeSymbol, bool> resultCache = new(SymbolEqualityComparer.Default);

            /// <summary>
            /// Checks whether the given type has a recursive generic inheritance hierarchy. The result is cached.
            /// </summary>
            public static bool HasExpandingCycle(ITypeSymbol start)
            {
                if (start.OriginalDefinition is not INamedTypeSymbol namedTypeDefinition ||
                    !namedTypeDefinition.IsGenericType)
                {
                    return false;
                }

                return resultCache.GetOrAdd(namedTypeDefinition, nt => new GenericsRecursionGraph(nt).HasExpandingCycle());
            }

            private readonly INamedTypeSymbol startSymbol;
            private readonly HashSet<INamedTypeSymbol> instantiationClosure = new(SymbolEqualityComparer.Default);
            private readonly Dictionary<ITypeParameterSymbol, List<(ITypeParameterSymbol To, bool IsExpanding)>> edges = new(SymbolEqualityComparer.Default);

            private GenericsRecursionGraph(INamedTypeSymbol startSymbol)
            {
                this.startSymbol = startSymbol;

                ComputeInstantiationClosure();
                ComputeGraphEdges();
            }

            private void ComputeGraphEdges()
            {
                foreach (var reference in instantiationClosure)
                {
                    var definition = reference.OriginalDefinition;
                    if (SymbolEqualityComparer.Default.Equals(reference, definition))
                    {
                        // It's a definition, so no edges
                        continue;
                    }

                    for (var i = 0; i < reference.TypeArguments.Length; i++)
                    {
                        var target = definition.TypeParameters[i];
                        if (reference.TypeArguments[i] is ITypeParameterSymbol source)
                        {
                            // non-expanding
                            edges.AddAnother(source, (target, false));
                        }
                        else if (reference.TypeArguments[i] is INamedTypeSymbol namedType)
                        {
                            // expanding
                            var sources = GetAllNestedTypeParameters(namedType);
                            foreach (var s in sources)
                            {
                                edges.AddAnother(s, (target, true));
                            }
                        }
                    }
                }
            }

            private static List<ITypeParameterSymbol> GetAllNestedTypeParameters(INamedTypeSymbol symbol)
            {
                var res = new List<ITypeParameterSymbol>();

                void AddTypeParameters(INamedTypeSymbol symbol)
                {
                    foreach (var typeArgument in symbol.TypeArguments)
                    {
                        if (typeArgument is ITypeParameterSymbol typeParameter)
                        {
                            res.Add(typeParameter);
                        }
                        else if (typeArgument is INamedTypeSymbol namedType)
                        {
                            AddTypeParameters(namedType);
                        }
                    }
                }

                AddTypeParameters(symbol);

                return res;
            }

            private void ComputeInstantiationClosure()
            {
                var workQueue = new Queue<INamedTypeSymbol>();
                workQueue.Enqueue(startSymbol);

                while (workQueue.Count > 0)
                {
                    var current = workQueue.Dequeue();
                    if (instantiationClosure.Contains(current) ||
                        !current.IsGenericType)
                    {
                        continue;
                    }

                    instantiationClosure.Add(current);

                    if (SymbolEqualityComparer.Default.Equals(current, current.OriginalDefinition))
                    {
                        // Definition, so enqueue all base types and interfaces
                        if (current.BaseType != null)
                        {
                            workQueue.Enqueue(current.BaseType);
                        }

                        foreach (var i in current.Interfaces)
                        {
                            workQueue.Enqueue(i);
                        }
                    }
                    else
                    {
                        // Reference, so enqueue all type arguments and their original definitions:
                        foreach (var namedTypeArgument in current.TypeArguments.OfType<INamedTypeSymbol>())
                        {
                            workQueue.Enqueue(namedTypeArgument);
                            workQueue.Enqueue(namedTypeArgument.OriginalDefinition);
                        }
                    }
                }
            }

            private bool HasExpandingCycle()
            {
                return startSymbol.TypeParameters.Any(HasExpandingCycle);
            }

            private bool HasExpandingCycle(ITypeParameterSymbol start)
            {
                var visited = new HashSet<ITypeParameterSymbol>(SymbolEqualityComparer.Default);
                var path = new List<ITypeParameterSymbol>();
                var hasExpandingCycle = HasExpandingCycle(start, visited, path, hasSeenExpandingEdge: false);
                return hasExpandingCycle;
            }

            private List<(ITypeParameterSymbol To, bool IsExpanding)> GetOutgoingEdges(ITypeParameterSymbol typeParameter)
            {
                return edges.TryGetValue(typeParameter, out var outgoingEdges)
                    ? outgoingEdges
                    : new List<(ITypeParameterSymbol, bool)>();
            }

            /// <summary>
            /// A modified cycle detection algorithm based on DFS.
            /// </summary>
            /// <param name="current">The current node that is being visited</param>
            /// <param name="visited">The nodes that have already been visited by any path.</param>
            /// <param name="currentPath">The nodes already visited on the current path.</param>
            /// <param name="hasSeenExpandingEdge">Whether an expanding edge was already seen in this path. We're looking for a cycle that has at least one expanding edge.</param>
            /// <returns></returns>
            private bool HasExpandingCycle(ITypeParameterSymbol current, HashSet<ITypeParameterSymbol> visited, List<ITypeParameterSymbol> currentPath, bool hasSeenExpandingEdge)
            {
                if (currentPath.Count > 0 && SymbolEqualityComparer.Default.Equals(current, currentPath[0]))
                {
                    return hasSeenExpandingEdge;
                }

                if (visited.Contains(current))
                {
                    return false;
                }

                visited.Add(current);
                currentPath.Add(current);

                var outgoingEdges = GetOutgoingEdges(current);

                foreach (var outgoingEdge in outgoingEdges)
                {
                    if (HasExpandingCycle(outgoingEdge.To, visited, currentPath, hasSeenExpandingEdge: hasSeenExpandingEdge || outgoingEdge.IsExpanding))
                    {
                        return true;
                    }
                }

                currentPath.RemoveAt(currentPath.Count - 1);
                return false;
            }
        }
    }

    internal abstract class Type<T> : Type where T : ITypeSymbol
    {
        protected Type(Context cx, T init)
            : base(cx, init) { }

        public new T Symbol => (T)base.Symbol;
    }
}
