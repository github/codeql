using System;
using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// Types that are passed by reference are not written directly to trap files. Instead, the annotation is stored on
    /// the entity.
    /// </summary>
    internal sealed class ByRefType : Type
    {
        public ByRefType(Context cx, Type elementType) : base(cx)
        {
            ElementType = elementType;
        }

        public override CilTypeKind Kind => throw new NotImplementedException();

        public override Namespace? ContainingNamespace => throw new NotImplementedException();

        public override Type? ContainingType => throw new NotImplementedException();

        public override int ThisTypeParameterCount => throw new NotImplementedException();

        public override IEnumerable<Type> TypeParameters => throw new NotImplementedException();

        public override Type Construct(IEnumerable<Type> typeArguments) => throw new NotImplementedException();

        public override string Name => $"{ElementType.Name}&";

        public Type ElementType { get; }

        public override void WriteAssemblyPrefix(TextWriter trapFile) => throw new NotImplementedException();

        public override void WriteId(EscapingTextWriter trapFile, bool inContext)
        {
            ElementType.WriteId(trapFile, inContext);
            trapFile.Write('&');
        }
    }
}
