using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    class ArrayType : Type<IArrayTypeSymbol>
    {
        ArrayType(Context cx, IArrayTypeSymbol init)
            : base(cx, init)
        {
            element = Create(cx, symbol.GetAnnotatedElementType());
        }

        readonly AnnotatedType element;

        public int Rank => symbol.Rank;

        public override AnnotatedType ElementType => element;

        public override int Dimension => 1 + element.Type.Dimension;

        // All array types are extracted because they won't
        // be extracted in their defining assembly.
        public override bool NeedsPopulation => true;

        public override void Populate()
        {
            Context.Emit(Tuples.array_element_type(this, Dimension, Rank, element.Type.TypeRef));
            ExtractType();
            ExtractNullability(symbol.ElementNullableAnnotation);
        }

        public override IId Id
        {
            get
            {
                return new Key(tb =>
                {
                    tb.Append(element.Type);
                    tb.Append((int)symbol.ElementNullableAnnotation);
                    symbol.BuildArraySuffix(tb);
                    tb.Append(";type");
                });
            }
        }

        public static ArrayType Create(Context cx, IArrayTypeSymbol symbol) => ArrayTypeFactory.Instance.CreateEntity(cx, symbol);

        class ArrayTypeFactory : ICachedEntityFactory<IArrayTypeSymbol, ArrayType>
        {
            public static readonly ArrayTypeFactory Instance = new ArrayTypeFactory();

            public ArrayType Create(Context cx, IArrayTypeSymbol init) => new ArrayType(cx, init);
        }
    }
}
