using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    class NullType : Type
    {
        NullType(Context cx)
            : base(cx, null) { }

        public override void Populate()
        {
            Context.Emit(Tuples.types(this, Kinds.TypeKind.NULL, "null"));
        }

        public override IId Id => new Key("<null>;type");

        public override bool NeedsPopulation => true;

        public override int GetHashCode() => 987354;

        public override bool Equals(object obj)
        {
            return obj != null && obj.GetType() == typeof(NullType);
        }

        public static NullType Create(Context cx) => NullTypeFactory.Instance.CreateEntity(cx, null);

        class NullTypeFactory : ICachedEntityFactory<ITypeSymbol, NullType>
        {
            public static readonly NullTypeFactory Instance = new NullTypeFactory();

            public NullType Create(Context cx, ITypeSymbol init) => new NullType(cx);
        }
    }
}
