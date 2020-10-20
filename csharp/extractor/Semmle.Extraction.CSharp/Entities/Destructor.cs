using Microsoft.CodeAnalysis;
using System.IO;

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
            ContainingType.PopulateGenerics();

            trapFile.destructors(this, string.Format("~{0}", symbol.ContainingType.Name), ContainingType, OriginalDefinition(Context, this, symbol));
            trapFile.destructor_location(this, Location);
        }

        private static new Destructor OriginalDefinition(Context cx, Destructor original, IMethodSymbol symbol)
        {
            return symbol.OriginalDefinition == null || SymbolEqualityComparer.Default.Equals(symbol.OriginalDefinition, symbol) ? original : Create(cx, symbol.OriginalDefinition);
        }

        public static new Destructor Create(Context cx, IMethodSymbol symbol) =>
            DestructorFactory.Instance.CreateEntityFromSymbol(cx, symbol);

        private class DestructorFactory : ICachedEntityFactory<IMethodSymbol, Destructor>
        {
            public static DestructorFactory Instance { get; } = new DestructorFactory();

            public Destructor Create(Context cx, IMethodSymbol init) => new Destructor(cx, init);
        }
    }
}
