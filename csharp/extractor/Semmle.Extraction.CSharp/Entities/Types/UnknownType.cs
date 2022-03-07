using System.IO;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class UnknownType : Type
    {
        private UnknownType(Context cx)
            : base(cx, null) { }

        public override void Populate(TextWriter trapFile)
        {
            trapFile.types(this, Kinds.TypeKind.UNKNOWN, "<unknown type>");
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.Write("<unknown>;type");
        }

        public override bool NeedsPopulation => true;

        public static Type Create(Context cx) => UnknownTypeFactory.Instance.CreateEntity(cx, typeof(UnknownType), null);

        private class UnknownTypeFactory : CachedEntityFactory<ITypeSymbol?, UnknownType>
        {
            public static UnknownTypeFactory Instance { get; } = new UnknownTypeFactory();

            public sealed override bool IsShared(ITypeSymbol? _) => true;

            public override UnknownType Create(Context cx, ITypeSymbol? _) => new UnknownType(cx);
        }
    }
}
