using System.IO;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class Destructor : Method
    {
        private Destructor(Context cx, IMethodSymbol init)
            : base(cx, init) { }

        public override void Populate(TextWriter trapFile)
        {
            PopulateMethod(trapFile);
            PopulateModifiers(trapFile);
            ContainingType!.PopulateGenerics();

            trapFile.destructors(this, $"~{Symbol.ContainingType.Name}", ContainingType, OriginalDefinition(Context, this, Symbol));
            trapFile.destructor_location(this, Location);
        }

        private static new Destructor OriginalDefinition(Context cx, Destructor original, IMethodSymbol symbol)
        {
            return symbol.OriginalDefinition is null || SymbolEqualityComparer.Default.Equals(symbol.OriginalDefinition, symbol) ? original : Create(cx, symbol.OriginalDefinition);
        }

        public static new Destructor Create(Context cx, IMethodSymbol symbol) =>
            DestructorFactory.Instance.CreateEntityFromSymbol(cx, symbol);

        private class DestructorFactory : CachedEntityFactory<IMethodSymbol, Destructor>
        {
            public static DestructorFactory Instance { get; } = new DestructorFactory();

            public override Destructor Create(Context cx, IMethodSymbol init) => new Destructor(cx, init);
        }
    }
}
