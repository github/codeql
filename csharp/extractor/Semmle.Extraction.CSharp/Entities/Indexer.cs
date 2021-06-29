using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class Indexer : Property, IExpressionParentEntity
    {
        protected Indexer(Context cx, IPropertySymbol init)
            : base(cx, init) { }

        private Indexer OriginalDefinition => IsSourceDeclaration ? this : Create(Context, Symbol.OriginalDefinition);

        public override void Populate(TextWriter trapFile)
        {
            PopulateNullability(trapFile, Symbol.GetAnnotatedType());

            var type = Type.Create(Context, Symbol.Type);
            trapFile.indexers(this, Symbol.GetName(useMetadataName: true), ContainingType!, type.TypeRef, OriginalDefinition);
            foreach (var l in Locations)
                trapFile.indexer_location(this, l);

            var getter = Symbol.GetMethod;
            var setter = Symbol.SetMethod;

            if (getter is null && setter is null)
                Context.ModelError(Symbol, "No indexer accessor defined");

            if (!(getter is null))
                Method.Create(Context, getter);

            if (!(setter is null))
                Method.Create(Context, setter);

            for (var i = 0; i < Symbol.Parameters.Length; ++i)
            {
                var original = Parameter.Create(Context, Symbol.OriginalDefinition.Parameters[i], OriginalDefinition);
                Parameter.Create(Context, Symbol.Parameters[i], this, original);
            }

            if (IsSourceDeclaration)
            {
                var expressionBody = ExpressionBody;
                if (expressionBody is not null)
                {
                    // The expression may need to reference parameters in the getter.
                    // So we need to arrange that the expression is populated after the getter.
                    Context.PopulateLater(() => Expression.CreateFromNode(new ExpressionNodeInfo(Context, expressionBody, this, 0).SetType(Symbol.GetAnnotatedType())));
                }
            }

            PopulateModifiers(trapFile);
            BindComments();

            var declSyntaxReferences = IsSourceDeclaration
                ? Symbol.DeclaringSyntaxReferences.
                Select(d => d.GetSyntax()).OfType<IndexerDeclarationSyntax>().ToArray()
                : Enumerable.Empty<IndexerDeclarationSyntax>();

            foreach (var explicitInterface in Symbol.ExplicitInterfaceImplementations.Select(impl => Type.Create(Context, impl.ContainingType)))
            {
                trapFile.explicitly_implements(this, explicitInterface.TypeRef);

                foreach (var syntax in declSyntaxReferences)
                    TypeMention.Create(Context, syntax.ExplicitInterfaceSpecifier!.Name, this, explicitInterface);
            }


            foreach (var syntax in declSyntaxReferences)
                TypeMention.Create(Context, syntax.Type, this, type);
        }

        public static new Indexer Create(Context cx, IPropertySymbol prop) => IndexerFactory.Instance.CreateEntityFromSymbol(cx, prop);

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(ContainingType!);
            trapFile.Write('.');
            trapFile.Write(Symbol.MetadataName);
            trapFile.Write('(');
            trapFile.BuildList(",", Symbol.Parameters, p => trapFile.WriteSubId(Type.Create(Context, p.Type)));
            trapFile.Write(");indexer");
        }

        public override Microsoft.CodeAnalysis.Location FullLocation
        {
            get
            {
                return Symbol.DeclaringSyntaxReferences
                    .Select(r => r.GetSyntax())
                    .OfType<IndexerDeclarationSyntax>()
                    .Select(s => s.GetLocation())
                    .Concat(Symbol.Locations)
                    .First();
            }
        }

        bool IExpressionParentEntity.IsTopLevelParent => true;

        private class IndexerFactory : CachedEntityFactory<IPropertySymbol, Indexer>
        {
            public static IndexerFactory Instance { get; } = new IndexerFactory();

            public override Indexer Create(Context cx, IPropertySymbol init) => new Indexer(cx, init);
        }
    }
}
