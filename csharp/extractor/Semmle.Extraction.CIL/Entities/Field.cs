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
    interface IMember : IExtractedEntity
    {
    }

    /// <summary>
    /// An entity representing a field.
    /// </summary>
    interface IField : IMember
    {
    }

    /// <summary>
    /// An entity representing a field.
    /// </summary>
    abstract class Field : GenericContext, IField
    {
        protected Field(Context cx) : base(cx)
        {
        }

        public bool NeedsPopulation { get { return true; } }

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
            trapFile.Write(IdSuffix);
            trapFile.Write('\"');
        }

        public string IdSuffix => ";cil-field";

        public abstract string Name { get; }

        public abstract Type DeclaringType { get; }

        public Location ReportingLocation => throw new NotImplementedException();

        abstract public Type Type { get; }

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

    sealed class DefinitionField : Field
    {
        readonly Handle handle;
        readonly FieldDefinition fd;
        readonly GenericContext gc;

        public DefinitionField(GenericContext gc, FieldDefinitionHandle handle) : base(gc.cx)
        {
            this.handle = handle;
            this.gc = gc;
            fd = cx.mdReader.GetFieldDefinition(handle);
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
                yield return Tuples.metadata_handle(this, cx.assembly, MetadataTokens.GetToken(handle));

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

                foreach (var c in Attribute.Populate(cx, this, fd.GetCustomAttributes()))
                    yield return c;
            }
        }

        public override string Name => cx.GetString(fd.Name);

        public override Type DeclaringType => (Type)cx.Create(fd.GetDeclaringType());

        public override Type Type => fd.DecodeSignature(cx.TypeSignatureDecoder, DeclaringType);

        public override IEnumerable<Type> TypeParameters => throw new NotImplementedException();

        public override IEnumerable<Type> MethodParameters => throw new NotImplementedException();
    }

    sealed class MemberReferenceField : Field
    {
        readonly MemberReferenceHandle Handle;
        readonly MemberReference mr;
        readonly GenericContext gc;
        readonly Type declType;

        public MemberReferenceField(GenericContext gc, MemberReferenceHandle handle) : base(gc.cx)
        {
            Handle = handle;
            this.gc = gc;
            mr = cx.mdReader.GetMemberReference(handle);
            declType = (Type)cx.CreateGeneric(gc, mr.Parent);
        }

        public override bool Equals(object? obj)
        {
            return obj is MemberReferenceField field && Handle.Equals(field.Handle);
        }

        public override int GetHashCode()
        {
            return Handle.GetHashCode();
        }

        public override string Name => cx.GetString(mr.Name);

        public override Type DeclaringType => declType;

        public override Type Type => mr.DecodeFieldSignature(cx.TypeSignatureDecoder, this);

        public override IEnumerable<Type> TypeParameters => gc.TypeParameters.Concat(declType.TypeParameters);

        public override IEnumerable<Type> MethodParameters => gc.MethodParameters.Concat(declType.MethodParameters);
    }
}
