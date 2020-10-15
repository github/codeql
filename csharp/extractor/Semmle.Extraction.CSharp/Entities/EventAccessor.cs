using Microsoft.CodeAnalysis;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class EventAccessor : Accessor
    {
        private EventAccessor(Context cx, IMethodSymbol init)
            : base(cx, init) { }

        /// <summary>
        /// Gets the event symbol associated with this accessor.
        /// </summary>
        private IEventSymbol EventSymbol => symbol.AssociatedSymbol as IEventSymbol;

        public override void Populate(TextWriter trapFile)
        {
            PopulateMethod(trapFile);
            ContainingType.PopulateGenerics();

            var @event = EventSymbol;
            if (@event == null)
            {
                Context.ModelError(symbol, "Unhandled event accessor associated symbol");
                return;
            }

            var parent = Event.Create(Context, @event);
            int kind;
            EventAccessor unboundAccessor;
            if (SymbolEqualityComparer.Default.Equals(symbol, @event.AddMethod))
            {
                kind = 1;
                unboundAccessor = Create(Context, @event.OriginalDefinition.AddMethod);
            }
            else if (SymbolEqualityComparer.Default.Equals(symbol, @event.RemoveMethod))
            {
                kind = 2;
                unboundAccessor = Create(Context, @event.OriginalDefinition.RemoveMethod);
            }
            else
            {
                Context.ModelError(symbol, "Undhandled event accessor kind");
                return;
            }

            trapFile.event_accessors(this, kind, symbol.Name, parent, unboundAccessor);

            foreach (var l in Locations)
                trapFile.event_accessor_location(this, l);

            Overrides(trapFile);
        }

        public static new EventAccessor Create(Context cx, IMethodSymbol symbol) =>
            EventAccessorFactory.Instance.CreateEntityFromSymbol(cx, symbol);

        private class EventAccessorFactory : ICachedEntityFactory<IMethodSymbol, EventAccessor>
        {
            public static EventAccessorFactory Instance { get; } = new EventAccessorFactory();

            public EventAccessor Create(Context cx, IMethodSymbol init) => new EventAccessor(cx, init);
        }
    }
}
