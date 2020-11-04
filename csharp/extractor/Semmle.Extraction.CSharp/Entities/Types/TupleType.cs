using Microsoft.CodeAnalysis;
using Semmle.Extraction.Entities;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    /// <summary>
    /// A tuple type, which is a C# type but not a .Net type.
    /// Tuples have the underlying type System.ValueTuple.
    /// </summary>
    internal class TupleType : Type<INamedTypeSymbol>
    {
        public static TupleType Create(Context cx, INamedTypeSymbol type) => TupleTypeFactory.Instance.CreateEntityFromSymbol(cx, type);

        private class TupleTypeFactory : ICachedEntityFactory<INamedTypeSymbol, TupleType>
        {
            public static TupleTypeFactory Instance { get; } = new TupleTypeFactory();

            public TupleType Create(Context cx, INamedTypeSymbol init) => new TupleType(cx, init);
        }

        private TupleType(Context cx, INamedTypeSymbol init) : base(cx, init)
        {
            tupleElementsLazy = new Lazy<Field[]>(() => symbol.TupleElements.Select(t => Field.Create(cx, t)).ToArray());
        }

        // All tuple types are "local types"
        public override bool NeedsPopulation => true;

        public override void WriteId(TextWriter trapFile)
        {
            symbol.BuildTypeId(Context, trapFile, symbol);
            trapFile.Write(";tuple");
        }

        public override void Populate(TextWriter trapFile)
        {
            PopulateType(trapFile);
            PopulateGenerics();

            var underlyingType = NamedType.CreateNamedTypeFromTupleType(Context, symbol.TupleUnderlyingType ?? symbol);

            trapFile.tuple_underlying_type(this, underlyingType);

            var index = 0;
            foreach (var element in TupleElements)
                trapFile.tuple_element(this, index++, element);

            // Note: symbol.Locations seems to be very inconsistent
            // about what locations are available for a tuple type.
            // Sometimes it's the source code, and sometimes it's empty.
            foreach (var l in symbol.Locations)
                trapFile.type_location(this, Context.Create(l));
        }

        private readonly Lazy<Field[]> tupleElementsLazy;
        public Field[] TupleElements => tupleElementsLazy.Value;

        public override IEnumerable<Type> TypeMentions => TupleElements.Select(e => e.Type.Type);
    }
}
