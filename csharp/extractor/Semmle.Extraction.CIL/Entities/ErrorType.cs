using System;
using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    internal sealed class ErrorType : Type
    {
        public ErrorType(Context cx) : base(cx)
        {
        }

        public override void WriteId(TextWriter trapFile, bool inContext) => trapFile.Write("<ErrorType>");

        public override CilTypeKind Kind => CilTypeKind.ValueOrRefType;

        public override string Name => "!error";

        public override Namespace ContainingNamespace => Cx.GlobalNamespace;

        public override Type? ContainingType => null;

        public override int ThisTypeParameterCount => 0;

        public override void WriteAssemblyPrefix(TextWriter trapFile) => throw new NotImplementedException();

        public override IEnumerable<Type> TypeParameters => throw new NotImplementedException();

        public override Type Construct(IEnumerable<Type> typeArguments) => throw new NotImplementedException();
    }
}
