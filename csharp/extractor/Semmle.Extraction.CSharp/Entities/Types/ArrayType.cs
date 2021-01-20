using System;
using System.IO;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class ArrayType : Type<IArrayTypeSymbol>
    {
        private ArrayType(Context cx, IArrayTypeSymbol init)
            : base(cx, init)
        {
            elementLazy = new Lazy<Type>(() => Create(cx, symbol.ElementType));
        }

        private readonly Lazy<Type> elementLazy;

        public int Rank => symbol.Rank;

        public Type ElementType => elementLazy.Value;

        public override int Dimension => 1 + ElementType.Dimension;

        // All array types are extracted because they won't
        // be extracted in their defining assembly.
        public override bool NeedsPopulation => true;

        public override void Populate(TextWriter trapFile)
        {
            trapFile.array_element_type(this, Dimension, Rank, ElementType.TypeRef);
            PopulateType(trapFile);
        }

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.WriteSubId(ElementType);
            symbol.BuildArraySuffix(trapFile);
            trapFile.Write(";type");
        }

        public static ArrayType Create(Context cx, IArrayTypeSymbol symbol) =>
            ArrayTypeFactory.Instance.CreateEntityFromSymbol(cx, symbol);

        private class ArrayTypeFactory : ICachedEntityFactory<IArrayTypeSymbol, ArrayType>
        {
            public static ArrayTypeFactory Instance { get; } = new ArrayTypeFactory();

            public ArrayType Create(Context cx, IArrayTypeSymbol init) => new ArrayType(cx, init);
        }
    }
}
