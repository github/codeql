using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    class Indexer : Property, IExpressionParentEntity
    {
        protected Indexer(Context cx, IPropertySymbol init)
            : base(cx, init) { }

        Indexer OriginalDefinition => IsSourceDeclaration ? this : Create(Context, symbol.OriginalDefinition);

        public override void Populate()
        {
            ExtractNullability(symbol.NullableAnnotation);

            var type = Type.Create(Context, symbol.Type);
            Context.Emit(Tuples.indexers(this, symbol.GetName(useMetadataName: true), ContainingType, type.TypeRef, OriginalDefinition));
            foreach (var l in Locations)
                Context.Emit(Tuples.indexer_location(this, l));

            var getter = symbol.GetMethod;
            var setter = symbol.SetMethod;

            if (getter is null && setter is null)
                Context.ModelError(symbol, "No indexer accessor defined");

            if (!(getter is null))
                Method.Create(Context, getter);

            if (!(setter is null))
                Method.Create(Context, setter);

            for (var i = 0; i < symbol.Parameters.Length; ++i)
            {
                var original = Parameter.Create(Context, symbol.OriginalDefinition.Parameters[i], OriginalDefinition);
                Parameter.Create(Context, symbol.Parameters[i], this, original);
            }

            if (IsSourceDeclaration)
            {
                var expressionBody = ExpressionBody;
                if (expressionBody != null)
                {
                    // The expression may need to reference parameters in the getter.
                    // So we need to arrange that the expression is populated after the getter.
                    Context.PopulateLater(() => Expression.CreateFromNode(new ExpressionNodeInfo(Context, expressionBody, this, 0) { Type = Type.Create(Context, symbol.GetAnnotatedType()) }));
                }
            }

            ExtractModifiers();
            BindComments();

            var declSyntaxReferences = IsSourceDeclaration
                ? symbol.DeclaringSyntaxReferences.
                Select(d => d.GetSyntax()).OfType<IndexerDeclarationSyntax>().ToArray()
                : Enumerable.Empty<IndexerDeclarationSyntax>();

            foreach (var explicitInterface in symbol.ExplicitInterfaceImplementations.Select(impl => Type.Create(Context, impl.ContainingType)))
            {
                Context.Emit(Tuples.explicitly_implements(this, explicitInterface.TypeRef));

                foreach (var syntax in declSyntaxReferences)
                    TypeMention.Create(Context, syntax.ExplicitInterfaceSpecifier.Name, this, explicitInterface);
            }


            foreach (var syntax in declSyntaxReferences)
                TypeMention.Create(Context, syntax.Type, this, type);
        }


        public static new Indexer Create(Context cx, IPropertySymbol prop) => IndexerFactory.Instance.CreateEntity(cx, prop);

        public override IId Id
        {
            get
            {
                return new Key(tb =>
                {
                    tb.Append(ContainingType);
                    tb.Append(".");
                    tb.Append(symbol.MetadataName);
                    tb.Append("(");
                    tb.BuildList(",", symbol.Parameters, (p, tb0) => tb0.Append(Type.Create(Context, p.Type)));
                    tb.Append(");indexer");
                });
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
                    OfType<IndexerDeclarationSyntax>().
                    Select(s => s.GetLocation()).
                    Concat(symbol.Locations).
                    First();
            }
        }

        bool IExpressionParentEntity.IsTopLevelParent => true;

        class IndexerFactory : ICachedEntityFactory<IPropertySymbol, Indexer>
        {
            public static readonly IndexerFactory Instance = new IndexerFactory();

            public Indexer Create(Context cx, IPropertySymbol init) => new Indexer(cx, init);
        }
    }
}
