using System;
using System.Collections.Generic;
using System.Reflection.Metadata;
using System.Reflection;
using System.Reflection.Metadata.Ecma335;

namespace Semmle.Extraction.CIL.Entities
{
    internal sealed class DefinitionField : Field
    {
        private readonly Handle handle;
        private readonly FieldDefinition fd;

        public DefinitionField(Context cx, FieldDefinitionHandle handle) : base(cx)
        {
            this.handle = handle;
            fd = Context.MdReader.GetFieldDefinition(handle);
        }

        public override bool Equals(object? obj)
        {
            return obj is DefinitionField field && handle.Equals(field.handle);
        }

        public override int GetHashCode() => handle.GetHashCode();

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return Tuples.metadata_handle(this, Context.Assembly, MetadataTokens.GetToken(handle));

                foreach (var c in base.Contents)
                    yield return c;

                if (fd.Attributes.HasFlag(FieldAttributes.Private))
                    yield return Tuples.cil_private(this);

                if (fd.Attributes.HasFlag(FieldAttributes.Public))
                    yield return Tuples.cil_public(this);

                if (fd.Attributes.HasFlag(FieldAttributes.Family))
                    yield return Tuples.cil_protected(this);

                if (fd.Attributes.HasFlag(FieldAttributes.Static))
                    yield return Tuples.cil_static(this);

                if (fd.Attributes.HasFlag(FieldAttributes.Assembly))
                    yield return Tuples.cil_internal(this);

                foreach (var c in Attribute.Populate(Context, this, fd.GetCustomAttributes()))
                    yield return c;
            }
        }

        public override string Name => Context.GetString(fd.Name);

        public override Type DeclaringType => (Type)Context.Create(fd.GetDeclaringType());

        public override Type Type => fd.DecodeSignature(Context.TypeSignatureDecoder, DeclaringType);

        public override IEnumerable<Type> TypeParameters => throw new NotImplementedException();

        public override IEnumerable<Type> MethodParameters => throw new NotImplementedException();
    }
}
