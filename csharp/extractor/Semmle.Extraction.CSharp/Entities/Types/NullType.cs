using System.IO;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class NullType : Type
    {
        private NullType(Context cx)
            : base(cx, null) { }

        public override void Populate(TextWriter trapFile)
        {
            trapFile.types(this, Kinds.TypeKind.NULL, "null");
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.Write("<null>;type");
        }

        public override bool NeedsPopulation => true;

        public override int GetHashCode() => 987354;

        public override bool Equals(object? obj)
        {
            return obj is not null && obj.GetType() == typeof(NullType);
        }

        public static Type Create(Context cx) => NullTypeFactory.Instance.CreateEntity(cx, typeof(NullType), null);

        private class NullTypeFactory : CachedEntityFactory<ITypeSymbol?, NullType>
        {
            public static NullTypeFactory Instance { get; } = new NullTypeFactory();

            public override NullType Create(Context cx, ITypeSymbol? init) => new NullType(cx);
        }
    }
}
