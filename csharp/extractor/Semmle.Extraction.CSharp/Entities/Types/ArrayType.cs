using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    class ArrayType : Type<IArrayTypeSymbol>
    {
        ArrayType(Context cx, IArrayTypeSymbol init)
            : base(cx, init)
        {
            element = Create(cx, symbol.ElementType);
        }

        readonly Type element;

        public int Rank => symbol.Rank;

        public override Type ElementType => element;

        public override int Dimension => 1 + element.Dimension;

        // All array types are extracted because they won't
        // be extracted in their defining assembly.
        public override bool NeedsPopulation => true;

        public override void Populate()
        {
            Context.Emit(Tuples.array_element_type(this, Dimension, Rank, element.TypeRef));
            ExtractType();
        }

        public override IId Id
        {
            get
            {
                return new Key(tb =>
                {
                    tb.Append(element);
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
