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
        public static IPropertySymbol GetPropertySymbol(IMethodSymbol symbol)
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
        private IPropertySymbol PropertySymbol => GetPropertySymbol(symbol);

        public new Accessor OriginalDefinition => Create(Context, symbol.OriginalDefinition);

        public override void Populate(TextWriter trapFile)
        {
            PopulateMethod(trapFile);
            PopulateModifiers(trapFile);
            ContainingType.PopulateGenerics();

            var prop = PropertySymbol;
            if (prop == null)
            {
                Context.ModelError(symbol, "Unhandled accessor associated symbol");
                return;
            }

            var parent = Property.Create(Context, prop);
            int kind;
            Accessor unboundAccessor;
            if (SymbolEqualityComparer.Default.Equals(symbol, prop.GetMethod))
            {
                kind = 1;
                unboundAccessor = Create(Context, prop.OriginalDefinition.GetMethod);
            }
            else if (SymbolEqualityComparer.Default.Equals(symbol, prop.SetMethod))
            {
                kind = 2;
                unboundAccessor = Create(Context, prop.OriginalDefinition.SetMethod);
            }
            else
            {
                Context.ModelError(symbol, "Unhandled accessor kind");
                return;
            }

            trapFile.accessors(this, kind, symbol.Name, parent, unboundAccessor);

            foreach (var l in Locations)
                trapFile.accessor_location(this, l);

            Overrides(trapFile);

            if (symbol.FromSource() && Block == null)
            {
                trapFile.compiler_generated(this);
            }
        }

        public static new Accessor Create(Context cx, IMethodSymbol symbol) =>
            AccessorFactory.Instance.CreateEntityFromSymbol(cx, symbol);

        private class AccessorFactory : ICachedEntityFactory<IMethodSymbol, Accessor>
        {
            public static AccessorFactory Instance { get; } = new AccessorFactory();

            public Accessor Create(Context cx, IMethodSymbol init) => new Accessor(cx, init);
        }
    }
}
