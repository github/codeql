using Microsoft.CodeAnalysis;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class EventAccessor : Method
    {
        private readonly IEventSymbol @event;

        private EventAccessor(Context cx, IMethodSymbol init, IEventSymbol @event)
            : base(cx, init)
        {
            this.@event = @event;
        }

        /// <summary>
        /// Gets the event symbol associated with accessor `symbol`, or `null`
        /// if there is no associated symbol.
        /// </summary>
        public static IEventSymbol? GetEventSymbol(IMethodSymbol symbol) =>
            symbol.AssociatedSymbol as IEventSymbol;

        public override void Populate(TextWriter trapFile)
        {
            PopulateMethod(trapFile);
            ContainingType!.PopulateGenerics();

            var parent = Event.Create(Context, @event);
            int kind;
            EventAccessor unboundAccessor;
            if (SymbolEqualityComparer.Default.Equals(Symbol, @event.AddMethod))
            {
                kind = 1;
                var orig = @event.OriginalDefinition;
                unboundAccessor = Create(Context, orig.AddMethod!, orig);
            }
            else if (SymbolEqualityComparer.Default.Equals(Symbol, @event.RemoveMethod))
            {
                kind = 2;
                var orig = @event.OriginalDefinition;
                unboundAccessor = Create(Context, orig.RemoveMethod!, orig);
            }
            else
            {
                Context.ModelError(Symbol, $"Undhandled event accessor kind {Symbol.ToDisplayString()}");
                return;
            }

            trapFile.event_accessors(this, kind, Symbol.Name, parent, unboundAccessor);

            foreach (var l in Locations)
                trapFile.event_accessor_location(this, l);

            Overrides(trapFile);

            if (Symbol.FromSource() && Block is null)
            {
                trapFile.compiler_generated(this);
            }
        }

        public static EventAccessor Create(Context cx, IMethodSymbol symbol, IEventSymbol @event) =>
            EventAccessorFactory.Instance.CreateEntity(cx, symbol, (symbol, @event));

        private class EventAccessorFactory : CachedEntityFactory<(IMethodSymbol, IEventSymbol), EventAccessor>
        {
            public static EventAccessorFactory Instance { get; } = new EventAccessorFactory();

            public override EventAccessor Create(Context cx, (IMethodSymbol, IEventSymbol) init) => new EventAccessor(cx, init.Item1, init.Item2);
        }
    }
}
