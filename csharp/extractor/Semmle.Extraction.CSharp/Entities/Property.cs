using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    class Property : CachedSymbol<IPropertySymbol>, IExpressionParentEntity
    {
        protected Property(Context cx, IPropertySymbol init)
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
                    tb.Append(";property");
                });
            }
        }

        protected Accessor Getter { get; set; }
        protected Accessor Setter { get; set; }

        public override void Populate()
        {
            ExtractMetadataHandle();
            ExtractAttributes();
            ExtractModifiers();
            BindComments();

            var type = Type.Create(Context, symbol.Type);
            Context.Emit(Tuples.properties(this, symbol.GetName(), ContainingType, type.TypeRef, Create(Context, symbol.OriginalDefinition)));

            var getter = symbol.GetMethod;
            if (getter != null)
                Getter = Accessor.Create(Context, getter);

            var setter = symbol.SetMethod;
            if (setter != null)
                Setter = Accessor.Create(Context, setter);

            var declSyntaxReferences = IsSourceDeclaration ?
                symbol.DeclaringSyntaxReferences.
                Select(d => d.GetSyntax()).OfType<PropertyDeclarationSyntax>().ToArray()
                : Enumerable.Empty<PropertyDeclarationSyntax>();

            foreach (var explicitInterface in symbol.ExplicitInterfaceImplementations.Select(impl => Type.Create(Context, impl.ContainingType)))
            {
                Context.Emit(Tuples.explicitly_implements(this, explicitInterface.TypeRef));

                foreach (var syntax in declSyntaxReferences)
                    TypeMention.Create(Context, syntax.ExplicitInterfaceSpecifier.Name, this, explicitInterface);
            }

            foreach (var l in Locations)
                Context.Emit(Tuples.property_location(this, l));

            if (IsSourceDeclaration && symbol.FromSource())
            {
                var expressionBody = ExpressionBody;
                if (expressionBody != null)
                {
                    Context.PopulateLater(() => Expression.Create(Context, expressionBody, this, 0));
                }

                foreach (var initializer in declSyntaxReferences.
                    Select(n => n.Initializer).
                    Where(i => i != null).
                    Select(i => i.Value))
                {
                    Context.PopulateLater(() => Expression.Create(Context, initializer, this, 1));
                }

                foreach (var syntax in declSyntaxReferences)
                    TypeMention.Create(Context, syntax.Type, this, type);
            }
        }

        public override Microsoft.CodeAnalysis.Location FullLocation
        {
            get
            {
                return
                    symbol.
                    DeclaringSyntaxReferences.
                    Select(r => r.GetSyntax()).
                    OfType<PropertyDeclarationSyntax>().
                    Select(s => s.GetLocation()).
                    Concat(symbol.Locations).
                    First();
            }
        }

        bool IExpressionParentEntity.IsTopLevelParent => true;

        public static Property Create(Context cx, IPropertySymbol prop)
        {
            return prop.IsIndexer ? Indexer.Create(cx, prop) : PropertyFactory.Instance.CreateEntity(cx, prop);
        }

        public void VisitDeclaration(Context cx, PropertyDeclarationSyntax p)
        {
        }

        class PropertyFactory : ICachedEntityFactory<IPropertySymbol, Property>
        {
            public static readonly PropertyFactory Instance = new PropertyFactory();

            public Property Create(Context cx, IPropertySymbol init) => new Property(cx, init);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.PushesLabel;
    }
}
