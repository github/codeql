using Microsoft.CodeAnalysis;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class Accessor : Method
    {
        protected Accessor(Context cx, IMethodSymbol init)
            : base(cx, init) { }

        /// <summary>
        /// Gets the property symbol associated accessor `symbol`, or `null`
        /// if there is no associated symbol.
        /// </summary>
        public static IPropertySymbol? GetPropertySymbol(IMethodSymbol symbol)
        {
            // Usually, the property/indexer can be fetched from the associated symbol
            if (symbol.AssociatedSymbol is IPropertySymbol prop)
                return prop;

            // But for properties/indexers that implement explicit interfaces, Roslyn
            // does not properly populate `AssociatedSymbol`
            var props = symbol.ContainingType.GetMembers().OfType<IPropertySymbol>();
            props = props.Where(p => SymbolEqualityComparer.Default.Equals(symbol, p.GetMethod) || SymbolEqualityComparer.Default.Equals(symbol, p.SetMethod));
            return props.SingleOrDefault();
        }

        /// <summary>
        /// Gets the property symbol associated with this accessor.
        /// </summary>
        private IPropertySymbol? PropertySymbol => GetPropertySymbol(Symbol);

        public new Accessor OriginalDefinition => Create(Context, Symbol.OriginalDefinition);

        public override void Populate(TextWriter trapFile)
        {
            PopulateMethod(trapFile);
            PopulateModifiers(trapFile);
            ContainingType!.PopulateGenerics();

            var prop = PropertySymbol;
            if (prop is null)
            {
                Context.ModelError(Symbol, "Unhandled accessor associated symbol");
                return;
            }

            var parent = Property.Create(Context, prop);
            int kind;
            Accessor unboundAccessor;
            if (SymbolEqualityComparer.Default.Equals(Symbol, prop.GetMethod))
            {
                kind = 1;
                unboundAccessor = Create(Context, prop.OriginalDefinition.GetMethod!);
            }
            else if (SymbolEqualityComparer.Default.Equals(Symbol, prop.SetMethod))
            {
                kind = 2;
                unboundAccessor = Create(Context, prop.OriginalDefinition.SetMethod!);
            }
            else
            {
                Context.ModelError(Symbol, "Unhandled accessor kind");
                return;
            }

            trapFile.accessors(this, kind, Symbol.Name, parent, unboundAccessor);

            foreach (var l in Locations)
                trapFile.accessor_location(this, l);

            Overrides(trapFile);

            if (Symbol.FromSource() && Block is null)
            {
                trapFile.compiler_generated(this);
            }

            if (Symbol.IsInitOnly)
            {
                trapFile.init_only_accessors(this);
            }
        }

        public static new Accessor Create(Context cx, IMethodSymbol symbol) =>
            AccessorFactory.Instance.CreateEntityFromSymbol(cx, symbol);

        private class AccessorFactory : CachedEntityFactory<IMethodSymbol, Accessor>
        {
            public static AccessorFactory Instance { get; } = new AccessorFactory();

            public override Accessor Create(Context cx, IMethodSymbol init) => new Accessor(cx, init);
        }
    }
}
