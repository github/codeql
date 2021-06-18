using System.IO;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class PointerType : Type<IPointerTypeSymbol>
    {
        private PointerType(Context cx, IPointerTypeSymbol init)
            : base(cx, init)
        {
            PointedAtType = Create(cx, Symbol.PointedAtType);
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(PointedAtType);
            trapFile.Write("*;type");
        }

        // All pointer types are extracted because they won't
        // be extracted in their defining assembly.
        public override bool NeedsPopulation => true;

        public override void Populate(TextWriter trapFile)
        {
            trapFile.pointer_referent_type(this, PointedAtType.TypeRef);
            PopulateType(trapFile);
        }

        public Type PointedAtType { get; private set; }

        public static PointerType Create(Context cx, IPointerTypeSymbol symbol) => PointerTypeFactory.Instance.CreateEntityFromSymbol(cx, symbol);

        private class PointerTypeFactory : CachedEntityFactory<IPointerTypeSymbol, PointerType>
        {
            public static PointerTypeFactory Instance { get; } = new PointerTypeFactory();

            public override PointerType Create(Context cx, IPointerTypeSymbol init) => new PointerType(cx, init);
        }
    }
}
