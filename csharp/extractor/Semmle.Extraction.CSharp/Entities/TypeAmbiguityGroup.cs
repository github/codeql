using System.IO;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class TypeAmbiguityGroup : CachedEntity<IErrorTypeSymbol>
    {
        private readonly int groupId;

        private TypeAmbiguityGroup(Context cx, IErrorTypeSymbol init)
            : base(cx, init)
        {
            groupId = SymbolEqualityComparer.Default.GetHashCode(Symbol);
        }

        public override void Populate(TextWriter trapFile)
        {
            trapFile.type_ambiguity_groups(this, (int)Symbol.CandidateReason);

            foreach (var candidate in Symbol.CandidateSymbols)
            {
                if (candidate is not ITypeSymbol candidateType)
                {
                    continue;
                }

                // todo: can the candidate type be another ambiguous IErrorTypeSymbol?
                var candidateEntity = Type.Create(Context, candidateType);
                trapFile.type_ambiguity_group_candidates(this, candidateEntity);
            }
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.Write(groupId);
            trapFile.Write(";type_ambiguity_group");
        }

        public override Location? ReportingLocation => null;

        public static TypeAmbiguityGroup Create(Context cx, IErrorTypeSymbol symbol) => AmbiguityTypeGroupFactory.Instance.CreateEntity(cx, symbol, symbol);

        private class AmbiguityTypeGroupFactory : CachedEntityFactory<IErrorTypeSymbol, TypeAmbiguityGroup>
        {
            public static AmbiguityTypeGroupFactory Instance { get; } = new AmbiguityTypeGroupFactory();

            public override TypeAmbiguityGroup Create(Context cx, IErrorTypeSymbol init) => new TypeAmbiguityGroup(cx, init);
        }
    }
}
