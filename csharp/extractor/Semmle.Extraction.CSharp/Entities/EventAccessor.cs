using Microsoft.CodeAnalysis;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    class EventAccessor : Accessor
    {
        EventAccessor(Context cx, IMethodSymbol init)
            : base(cx, init) { }

        /// <summary>
        /// Gets the event symbol associated with this accessor.
        /// </summary>
        IEventSymbol EventSymbol => Symbol.AssociatedSymbol as IEventSymbol;

        public override void Populate(TextWriter trapFile)
        {
            PopulateMethod(trapFile);
            ContainingType.PopulateGenerics();

            var @event = EventSymbol;
            if (@event == null)
            {
                Context.ModelError(Symbol, "Unhandled event accessor associated symbol");
                return;
            }

            var parent = Event.Create(Context, @event);
            int kind;
            EventAccessor unboundAccessor;
            if (SymbolEqualityComparer.Default.Equals(Symbol, @event.AddMethod))
            {
                kind = 1;
                unboundAccessor = Create(Context, @event.OriginalDefinition.AddMethod);
            }
            else if (SymbolEqualityComparer.Default.Equals(Symbol, @event.RemoveMethod))
            {
                kind = 2;
                unboundAccessor = Create(Context, @event.OriginalDefinition.RemoveMethod);
            }
            else
            {
                Context.ModelError(Symbol, "Undhandled event accessor kind");
                return;
            }

            trapFile.event_accessors(this, kind, Symbol.Name, parent, unboundAccessor);

            foreach (var l in Locations)
                trapFile.event_accessor_location(this, l);

            Overrides(trapFile);
        }

        public new static EventAccessor Create(Context cx, IMethodSymbol symbol) =>
            EventAccessorFactory.Instance.CreateEntityFromSymbol(cx, symbol);

        class EventAccessorFactory : ICachedEntityFactory<IMethodSymbol, EventAccessor>
        {
            public static readonly EventAccessorFactory Instance = new EventAccessorFactory();

            public EventAccessor Create(Context cx, IMethodSymbol init) => new EventAccessor(cx, init);
        }
    }
}
