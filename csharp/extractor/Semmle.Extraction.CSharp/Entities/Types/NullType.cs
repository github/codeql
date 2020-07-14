using System.IO;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    class NullType : Type
    {
        NullType(Context cx)
            : base(cx, null) { }

        public override void Populate(TextWriter trapFile)
        {
            trapFile.types(this, Kinds.TypeKind.NULL, "null");
        }

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.Write("<null>;type");
        }

        public override bool NeedsPopulation => true;

        public override int GetHashCode() => 987354;

        public override bool Equals(object obj)
        {
            return obj != null && obj.GetType() == typeof(NullType);
        }

        public static AnnotatedType Create(Context cx) => new AnnotatedType(NullTypeFactory.Instance.CreateNullableEntity(cx, null), NullableAnnotation.None);

        class NullTypeFactory : ICachedEntityFactory<ITypeSymbol, NullType>
        {
            public static readonly NullTypeFactory Instance = new NullTypeFactory();

            public NullType Create(Context cx, ITypeSymbol init) => new NullType(cx);
        }
    }
}
