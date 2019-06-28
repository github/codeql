using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    class Event : CachedSymbol<IEventSymbol>
    {
        Event(Context cx, IEventSymbol init)
            : base(cx, init) { }

        public override IId Id
        {
            get
            {
                return new Key(tb =>
                {
                    tb.Append(ContainingType);
                    tb.Append(".");
                    Method.AddExplicitInterfaceQualifierToId(Context, tb, symbol.ExplicitInterfaceImplementations);
                    tb.Append(symbol.Name);
                    tb.Append(";event");
                });
            }
        }

        public override void Populate()
        {
            ExtractNullability(symbol.NullableAnnotation);

            var type = Type.Create(Context, symbol.Type);
            Context.Emit(Tuples.events(this, symbol.GetName(), ContainingType, type.TypeRef, Create(Context, symbol.OriginalDefinition)));

            var adder = symbol.AddMethod;
            var remover = symbol.RemoveMethod;

            if (!(adder is null))
                Method.Create(Context, adder);

            if (!(remover is null))
                Method.Create(Context, remover);

            ExtractModifiers();
            BindComments();

            var declSyntaxReferences = IsSourceDeclaration
                ? symbol.DeclaringSyntaxReferences.Select(d => d.GetSyntax()).ToArray()
                : Enumerable.Empty<SyntaxNode>();

            foreach (var explicitInterface in symbol.ExplicitInterfaceImplementations.Select(impl => Type.Create(Context, impl.ContainingType)))
            {
                Context.Emit(Tuples.explicitly_implements(this, explicitInterface.TypeRef));

                foreach (var syntax in declSyntaxReferences.OfType<EventDeclarationSyntax>())
                    TypeMention.Create(Context, syntax.ExplicitInterfaceSpecifier.Name, this, explicitInterface);
            }

            foreach (var l in Locations)
                Context.Emit(Tuples.event_location(this, l));

            foreach (var syntaxType in declSyntaxReferences.OfType<VariableDeclaratorSyntax>().
                Select(d => d.Parent).
                OfType<VariableDeclarationSyntax>().
                Select(syntax => syntax.Type))
                TypeMention.Create(Context, syntaxType, this, type);
        }

        public static Event Create(Context cx, IEventSymbol symbol) => EventFactory.Instance.CreateEntity(cx, symbol);

        class EventFactory : ICachedEntityFactory<IEventSymbol, Event>
        {
            public static readonly EventFactory Instance = new EventFactory();

            public Event Create(Context cx, IEventSymbol init) => new Event(cx, init);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;
    }
}
