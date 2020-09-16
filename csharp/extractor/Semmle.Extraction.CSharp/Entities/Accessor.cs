using Microsoft.CodeAnalysis;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    class Accessor : Method
    {
        protected Accessor(Context cx, IMethodSymbol init)
            : base(cx, init) { }

        /// <summary>
        /// Gets the property symbol associated with this accessor.
        /// </summary>
        IPropertySymbol PropertySymbol
        {
            get
            {
                // Usually, the property/indexer can be fetched from the associated symbol
                if (Symbol.AssociatedSymbol is IPropertySymbol prop)
                    return prop;

                // But for properties/indexers that implement explicit interfaces, Roslyn
                // does not properly populate `AssociatedSymbol`
                var props = Symbol.ContainingType.GetMembers().OfType<IPropertySymbol>();
                props = props.Where(p => SymbolEqualityComparer.Default.Equals(Symbol, p.GetMethod) || SymbolEqualityComparer.Default.Equals(Symbol, p.SetMethod));
                return props.SingleOrDefault();
            }
        }

        public new Accessor OriginalDefinition => Create(Context, Symbol.OriginalDefinition);

        public override void Populate(TextWriter trapFile)
        {
            PopulateMethod(trapFile);
            PopulateModifiers(trapFile);
            ContainingType.PopulateGenerics();

            var prop = PropertySymbol;
            if (prop == null)
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
                unboundAccessor = Create(Context, prop.OriginalDefinition.GetMethod);
            }
            else if (SymbolEqualityComparer.Default.Equals(Symbol, prop.SetMethod))
            {
                kind = 2;
                unboundAccessor = Create(Context, prop.OriginalDefinition.SetMethod);
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

            if (Symbol.FromSource() && Block == null)
            {
                trapFile.compiler_generated(this);
            }
        }

        public new static Accessor Create(Context cx, IMethodSymbol symbol) =>
            AccessorFactory.Instance.CreateEntityFromSymbol(cx, symbol);

        class AccessorFactory : ICachedEntityFactory<IMethodSymbol, Accessor>
        {
            public static readonly AccessorFactory Instance = new AccessorFactory();

            public Accessor Create(Context cx, IMethodSymbol init) => new Accessor(cx, init);
        }
    }
}
