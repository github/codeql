using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.CodeAnalysis;
using System.Reflection.Metadata;
using System.Reflection;
using System.Reflection.Metadata.Ecma335;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// An entity represting a member.
    /// Used to type tuples correctly.
    /// </summary>
    internal interface IMember : IExtractedEntity
    {
    }

    /// <summary>
    /// An entity representing a field.
    /// </summary>
    internal interface IField : IMember
    {
    }

    /// <summary>
    /// An entity representing a field.
    /// </summary>
    internal abstract class Field : GenericContext, IField
    {
        protected Field(Context cx) : base(cx)
        {
        }

        public Label Label { get; set; }

        public void WriteId(TextWriter trapFile)
        {
            trapFile.WriteSubId(DeclaringType);
            trapFile.Write('.');
            trapFile.Write(Name);
        }

        public void WriteQuotedId(TextWriter trapFile)
        {
            trapFile.Write("@\"");
            WriteId(trapFile);
            trapFile.Write(idSuffix);
            trapFile.Write('\"');
        }

        private const string idSuffix = ";cil-field";

        public abstract string Name { get; }

        public abstract Type DeclaringType { get; }

        public Location ReportingLocation => throw new NotImplementedException();

        public abstract Type Type { get; }

        public virtual IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return Tuples.cil_field(this, DeclaringType, Name, Type);
            }
        }

        public void Extract(Context cx2)
        {
            cx2.Populate(this);
        }

        TrapStackBehaviour IEntity.TrapStackBehaviour => TrapStackBehaviour.NoLabel;
    }

    internal sealed class DefinitionField : Field
    {
        private readonly Handle handle;
        private readonly FieldDefinition fd;

        public DefinitionField(Context cx, FieldDefinitionHandle handle) : base(cx)
        {
            this.handle = handle;
            fd = Cx.MdReader.GetFieldDefinition(handle);
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
                yield return Tuples.metadata_handle(this, Cx.Assembly, MetadataTokens.GetToken(handle));

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

                foreach (var c in Attribute.Populate(Cx, this, fd.GetCustomAttributes()))
                    yield return c;
            }
        }

        public override string Name => Cx.GetString(fd.Name);

        public override Type DeclaringType => (Type)Cx.Create(fd.GetDeclaringType());

        public override Type Type => fd.DecodeSignature(Cx.TypeSignatureDecoder, DeclaringType);

        public override IEnumerable<Type> TypeParameters => throw new NotImplementedException();

        public override IEnumerable<Type> MethodParameters => throw new NotImplementedException();
    }

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
