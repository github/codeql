using System.Collections.Generic;
using System.Linq;
using System.Reflection.Metadata;

namespace Semmle.Extraction.CIL.Entities
{
    internal sealed class MemberReferenceField : Field
    {
        private readonly MemberReferenceHandle handle;
        private readonly MemberReference mr;
        private readonly GenericContext gc;
        private readonly Type declType;

        public MemberReferenceField(GenericContext gc, MemberReferenceHandle handle) : base(gc.Cx)
        {
            this.handle = handle;
            this.gc = gc;
            mr = Cx.MdReader.GetMemberReference(handle);
            declType = (Type)Cx.CreateGeneric(gc, mr.Parent);
        }

        public override bool Equals(object? obj)
        {
            return obj is MemberReferenceField field && handle.Equals(field.handle);
        }

        public override int GetHashCode()
        {
            return handle.GetHashCode();
        }

        public override string Name => Cx.GetString(mr.Name);

        public override Type DeclaringType => declType;

        public override Type Type => mr.DecodeFieldSignature(Cx.TypeSignatureDecoder, this);

        public override IEnumerable<Type> TypeParameters => gc.TypeParameters.Concat(declType.TypeParameters);

        public override IEnumerable<Type> MethodParameters => gc.MethodParameters.Concat(declType.MethodParameters);
    }
}
