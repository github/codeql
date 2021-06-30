using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class Event : CachedSymbol<IEventSymbol>
    {
        private Event(Context cx, IEventSymbol init)
            : base(cx, init) { }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(ContainingType!);
            trapFile.Write('.');
            Method.AddExplicitInterfaceQualifierToId(Context, trapFile, Symbol.ExplicitInterfaceImplementations);
            trapFile.Write(Symbol.Name);
            trapFile.Write(";event");
        }

        public override void Populate(TextWriter trapFile)
        {
            PopulateNullability(trapFile, Symbol.GetAnnotatedType());

            var type = Type.Create(Context, Symbol.Type);
            trapFile.events(this, Symbol.GetName(), ContainingType!, type.TypeRef, Create(Context, Symbol.OriginalDefinition));

            var adder = Symbol.AddMethod;
            var remover = Symbol.RemoveMethod;

            if (!(adder is null))
                Method.Create(Context, adder);

            if (!(remover is null))
                Method.Create(Context, remover);

            PopulateModifiers(trapFile);
            BindComments();

            var declSyntaxReferences = IsSourceDeclaration
                ? Symbol.DeclaringSyntaxReferences.Select(d => d.GetSyntax()).ToArray()
                : Enumerable.Empty<SyntaxNode>();

            foreach (var explicitInterface in Symbol.ExplicitInterfaceImplementations.Select(impl => Type.Create(Context, impl.ContainingType)))
            {
                trapFile.explicitly_implements(this, explicitInterface.TypeRef);

                foreach (var syntax in declSyntaxReferences.OfType<EventDeclarationSyntax>())
                    TypeMention.Create(Context, syntax.ExplicitInterfaceSpecifier!.Name, this, explicitInterface);
            }

            foreach (var l in Locations)
                trapFile.event_location(this, l);

            foreach (var syntaxType in declSyntaxReferences
                .OfType<VariableDeclaratorSyntax>()
                .Select(d => d.Parent)
                .OfType<VariableDeclarationSyntax>()
                .Select(syntax => syntax.Type))
            {
                TypeMention.Create(Context, syntaxType, this, type);
            }
        }

        public static Event Create(Context cx, IEventSymbol symbol) => EventFactory.Instance.CreateEntityFromSymbol(cx, symbol);

        private class EventFactory : CachedEntityFactory<IEventSymbol, Event>
        {
            public static EventFactory Instance { get; } = new EventFactory();

            public override Event Create(Context cx, IEventSymbol init) => new Event(cx, init);
        }
    }
}
