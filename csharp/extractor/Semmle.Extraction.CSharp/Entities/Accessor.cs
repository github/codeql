using System.IO;
using System.Linq;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class Accessor : Method
    {
        private readonly IPropertySymbol property;
        protected Accessor(Context cx, IMethodSymbol init, IPropertySymbol property)
            : base(cx, init)
        {
            this.property = property;
        }

        /// <summary>
        /// Gets the property symbol associated with accessor `symbol`, or `null`
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

        public override void Populate(TextWriter trapFile)
        {
            PopulateMethod(trapFile);
            PopulateModifiers(trapFile);
            ContainingType!.PopulateGenerics();

            var parent = Property.Create(Context, property);
            int kind;
            Accessor unboundAccessor;
            if (SymbolEqualityComparer.Default.Equals(Symbol, property.GetMethod))
            {
                kind = 1;
                var orig = property.OriginalDefinition;
                unboundAccessor = Create(Context, orig.GetMethod!, orig);
            }
            else if (SymbolEqualityComparer.Default.Equals(Symbol, property.SetMethod))
            {
                kind = 2;
                var orig = property.OriginalDefinition;
                unboundAccessor = Create(Context, orig.SetMethod!, orig);
            }
            else
            {
                Context.ModelError(Symbol, $"Unhandled accessor method {Symbol.ToDisplayString()}");
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

        public static Accessor Create(Context cx, IMethodSymbol symbol, IPropertySymbol prop) =>
            AccessorFactory.Instance.CreateEntity(cx, symbol, (symbol, prop));

        private class AccessorFactory : CachedEntityFactory<(IMethodSymbol, IPropertySymbol), Accessor>
        {
            public static AccessorFactory Instance { get; } = new AccessorFactory();

            public override Accessor Create(Context cx, (IMethodSymbol, IPropertySymbol) init) => new(cx, init.Item1, init.Item2);
        }
    }
}
