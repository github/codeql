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
            elementLazy = new Lazy<AnnotatedType>(() => Create(cx, symbol.GetAnnotatedElementType()));
        }

        private readonly Lazy<AnnotatedType> elementLazy;
        private AnnotatedType element => elementLazy.Value;

        public int Rank => symbol.Rank;

        public override AnnotatedType ElementType => element;

        public override int Dimension => 1 + element.Type.Dimension;

        // All array types are extracted because they won't
        // be extracted in their defining assembly.
        public override bool NeedsPopulation => true;

        public override void Populate(TextWriter trapFile)
        {
            trapFile.array_element_type(this, Dimension, Rank, element.Type.TypeRef);
            PopulateType(trapFile);
        }

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.WriteSubId(element.Type);
            symbol.BuildArraySuffix(trapFile);
            trapFile.Write(";type");
        }

        public static ArrayType Create(Context cx, IArrayTypeSymbol symbol)
        {
            var ret = ArrayTypeFactory.Instance.CreateEntityFromSymbol(cx, symbol);
            ret.symbol = symbol;
            return ret;
        }

        private class ArrayTypeFactory : ICachedEntityFactory<IArrayTypeSymbol, ArrayType>
        {
            public static ArrayTypeFactory Instance { get; } = new ArrayTypeFactory();

            public ArrayType Create(Context cx, IArrayTypeSymbol init) => new ArrayType(cx, init);
        }
    }
}
