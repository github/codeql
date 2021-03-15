using System.Collections.Generic;
using System.Linq;
using System.Reflection.Metadata;

namespace Semmle.Extraction.CIL.Entities
{
    internal sealed class MemberReferenceField : Field
    {
        private readonly MemberReferenceHandle handle;
        private readonly MemberReference mr;
        private readonly IGenericContext gc;
        private readonly Type declType;

        public MemberReferenceField(IGenericContext gc, MemberReferenceHandle handle) : base(gc.Context)
        {
            this.handle = handle;
            this.gc = gc;
            mr = Context.MdReader.GetMemberReference(handle);
            declType = (Type)Context.CreateGeneric(gc, mr.Parent);
        }

        public override bool Equals(object? obj)
        {
            return obj is MemberReferenceField field && handle.Equals(field.handle);
        }

        public override int GetHashCode()
        {
            return handle.GetHashCode();
        }

        public override string Name => Context.GetString(mr.Name);

        public override Type DeclaringType => declType;

        public override Type Type => mr.DecodeFieldSignature(Context.TypeSignatureDecoder, this);

        public override IEnumerable<Type> TypeParameters => gc.TypeParameters.Concat(declType.TypeParameters);

        public override IEnumerable<Type> MethodParameters => gc.MethodParameters.Concat(declType.MethodParameters);
    }
}
