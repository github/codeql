using System;
using System.Reflection.Metadata;
using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    public sealed class PrimitiveType : Type
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

        public override int GetHashCode()
        {
            return 1337 * (int)typeCode;
        }

        public override void WriteId(TextWriter trapFile, bool inContext)
        {
            trapFile.Write("builtin:");
            trapFile.Write(Name);
        }

        public override string Name => typeCode.Id();

        public override Namespace Namespace => Cx.SystemNamespace;

        public override Type? ContainingType => null;

        public override int ThisTypeParameters => 0;

        public override CilTypeKind Kind => CilTypeKind.ValueOrRefType;

        public override void WriteAssemblyPrefix(TextWriter trapFile) { }

        public override IEnumerable<Type> TypeParameters => throw new NotImplementedException();

        public override IEnumerable<Type> MethodParameters => throw new NotImplementedException();

        public override Type Construct(IEnumerable<Type> typeArguments) => throw new NotImplementedException();
    }
}
