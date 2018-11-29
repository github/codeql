using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.CodeAnalysis;
using System.Reflection.Metadata;
using System.Reflection;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// An entity represting a member.
    /// Used to type tuples correctly.
    /// </summary>
    interface IMember : ILabelledEntity
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

        public IId Id => ShortId + IdSuffix;

        public Id IdSuffix => fieldSuffix;

        static readonly StringId fieldSuffix = new StringId(";cil-field");

        public Id ShortId
        {
            get; set;
        }

        public abstract Id Name { get; }

        public abstract Type DeclaringType { get; }

        public Location ReportingLocation => throw new NotImplementedException();

        abstract public Type Type { get; }

        public virtual IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return Tuples.cil_field(this, DeclaringType, Name.Value, Type);
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
            ShortId = DeclaringType.ShortId + cx.Dot + Name;
        }

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return Tuples.metadata_handle(this, cx.assembly, handle.GetHashCode());

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

        public override Id Name => cx.GetId(fd.Name);

        public override Type DeclaringType => (Type)cx.Create(fd.GetDeclaringType());

        public override Type Type => fd.DecodeSignature(cx.TypeSignatureDecoder, DeclaringType);

        public override IEnumerable<Type> TypeParameters => throw new NotImplementedException();

        public override IEnumerable<Type> MethodParameters => throw new NotImplementedException();
    }

    sealed class MemberReferenceField : Field
    {
        readonly MemberReference mr;
        readonly GenericContext gc;
        readonly Type declType;

        public MemberReferenceField(GenericContext gc, MemberReferenceHandle handle) : base(gc.cx)
        {
            this.gc = gc;
            mr = cx.mdReader.GetMemberReference(handle);
            declType = (Type)cx.CreateGeneric(gc, mr.Parent);
            ShortId = declType.ShortId + cx.Dot + Name;
        }

        public override Id Name => cx.GetId(mr.Name);

        public override Type DeclaringType => declType;

        public override Type Type => mr.DecodeFieldSignature(cx.TypeSignatureDecoder, this);

        public override IEnumerable<Type> TypeParameters => gc.TypeParameters.Concat(declType.TypeParameters);

        public override IEnumerable<Type> MethodParameters => gc.MethodParameters.Concat(declType.MethodParameters);
    }
}
