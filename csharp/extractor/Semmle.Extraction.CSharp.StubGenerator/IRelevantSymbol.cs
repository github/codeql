using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.StubGenerator;

internal interface IRelevantSymbol
{
    bool IsRelevantNamedType(INamedTypeSymbol symbol);
    bool IsRelevantNamespace(INamespaceSymbol symbol);
}
