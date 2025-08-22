using System.Linq;
using Microsoft.CodeAnalysis;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.StubGenerator;

internal class RelevantSymbol : IRelevantSymbol
{
    private readonly IAssemblySymbol assembly;
    private readonly MemoizedFunc<INamedTypeSymbol, bool> isRelevantNamedType;
    private readonly MemoizedFunc<INamespaceSymbol, bool> isRelevantNamespace;

    public RelevantSymbol(IAssemblySymbol assembly)
    {
        this.assembly = assembly;

        isRelevantNamedType = new(symbol =>
            StubVisitor.IsRelevantBaseType(symbol) &&
            SymbolEqualityComparer.Default.Equals(symbol.ContainingAssembly, assembly));

        isRelevantNamespace = new(symbol =>
            symbol.GetTypeMembers().Any(IsRelevantNamedType) ||
            symbol.GetNamespaceMembers().Any(IsRelevantNamespace));
    }

    public bool IsRelevantNamedType(INamedTypeSymbol symbol) => isRelevantNamedType.Invoke(symbol);

    public bool IsRelevantNamespace(INamespaceSymbol symbol) => isRelevantNamespace.Invoke(symbol);
}

