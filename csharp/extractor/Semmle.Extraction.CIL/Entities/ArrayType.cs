using System;
using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// An array type.
    /// </summary>
    internal sealed class ArrayType : Type
    {
        private readonly Type elementType;
        private readonly int rank;

        public ArrayType(Context cx, Type elementType, int rank) : base(cx)
        {
            this.rank = rank;
            this.elementType = elementType;
        }

        public ArrayType(Context cx, Type elementType) : this(cx, elementType, 1)
        {
        }

        public override bool Equals(object? obj)
        {
            return obj is ArrayType array && elementType.Equals(array.elementType) && rank == array.rank;
        }

        public override int GetHashCode() => HashCode.Combine(elementType, rank);

        public override void WriteId(TextWriter trapFile, bool inContext)
        {
            elementType.WriteId(trapFile, inContext);
            trapFile.Write('[');
            for (var i = 1; i < rank; ++i)
            {
                trapFile.Write(',');
            }
            trapFile.Write(']');
        }

        public override string Name => elementType.Name + "[]";

        public override Namespace ContainingNamespace => Cx.SystemNamespace;

        public override Type? ContainingType => null;

        public override int ThisTypeParameterCount => elementType.ThisTypeParameterCount;

        public override CilTypeKind Kind => CilTypeKind.Array;

        public override Type Construct(IEnumerable<Type> typeArguments) => Cx.Populate(new ArrayType(Cx, elementType.Construct(typeArguments)));

        public override Type SourceDeclaration => Cx.Populate(new ArrayType(Cx, elementType.SourceDeclaration));

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                foreach (var c in base.Contents)
                    yield return c;

                yield return Tuples.cil_array_type(this, elementType, rank);
            }
        }

        public override void WriteAssemblyPrefix(TextWriter trapFile) => elementType.WriteAssemblyPrefix(trapFile);

        public override IEnumerable<Type> GenericArguments => elementType.GenericArguments;

        public override IEnumerable<Type> TypeParameters => elementType.TypeParameters;
    }
}
