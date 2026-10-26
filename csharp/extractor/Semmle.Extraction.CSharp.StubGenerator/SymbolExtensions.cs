using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.StubGenerator;

public static class SymbolExtensions
{
    public static string GetQualifiedName(this ISymbol symbol) =>
        symbol.ToDisplayString(SymbolDisplayFormat.FullyQualifiedFormat.WithGlobalNamespaceStyle(SymbolDisplayGlobalNamespaceStyle.Omitted));
}
