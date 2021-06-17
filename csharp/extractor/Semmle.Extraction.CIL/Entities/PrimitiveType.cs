using System;
using System.Reflection.Metadata;
using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    internal sealed class PrimitiveType : Type
    {
        private readonly PrimitiveTypeCode typeCode;
        public PrimitiveType(Context cx, PrimitiveTypeCode tc) : base(cx)
        {
            typeCode = tc;
        }

        public override bool Equals(object? obj)
        {
            return obj is PrimitiveType pt && typeCode == pt.typeCode;
        }

        public override int GetHashCode() => typeCode.GetHashCode();

        public override void WriteId(EscapingTextWriter trapFile, bool inContext)
        {
            Type.WritePrimitiveTypeId(trapFile, Name);
        }

        public override string Name => typeCode.Id();

        public override Namespace ContainingNamespace => Context.SystemNamespace;

        public override Type? ContainingType => null;

        public override int ThisTypeParameterCount => 0;

        public override CilTypeKind Kind => CilTypeKind.ValueOrRefType;

        public override void WriteAssemblyPrefix(TextWriter trapFile) { }

        public override IEnumerable<Type> TypeParameters => throw new NotImplementedException();

        public override Type Construct(IEnumerable<Type> typeArguments) => throw new NotImplementedException();
    }
}
