﻿using System;
using System.Collections.Generic;
using System.Reflection.Metadata;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// A CIL attribute.
    /// </summary>
    interface IAttribute : IExtractedEntity
    {
    }

    /// <summary>
    /// Entity representing a CIL attribute.
    /// </summary>
    sealed class Attribute : UnlabelledEntity, IAttribute
    {
        readonly CustomAttributeHandle handle;
        readonly CustomAttribute attrib;
        readonly IEntity @object;

        public Attribute(Context cx, IEntity @object, CustomAttributeHandle handle) : base(cx)
        {
            attrib = cx.mdReader.GetCustomAttribute(handle);
            this.handle = handle;
            this.@object = @object;
        }

        public override bool Equals(object obj)
        {
            return obj is Attribute attribute && handle.Equals(attribute.handle);
        }

        public override int GetHashCode() => handle.GetHashCode();

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                var constructor = (Method)cx.Create(attrib.Constructor);
                yield return constructor;

                yield return Tuples.cil_attribute(this, @object, constructor);

                CustomAttributeValue<Type> decoded;

                try
                {
                    decoded = attrib.DecodeValue(new CustomAttributeDecoder(cx));
                }
                catch (NotImplementedException)
                {
                    // Attribute decoding is only partial at this stage.
                    yield break;
                }

                for (int index = 0; index < decoded.FixedArguments.Length; ++index)
                {
                    object value = decoded.FixedArguments[index].Value;
                    yield return Tuples.cil_attribute_positional_argument(this, index, value == null ? "null" : value.ToString());
                }

                foreach (var p in decoded.NamedArguments)
                {
                    object value = p.Value;
                    yield return Tuples.cil_attribute_named_argument(this, p.Name, value == null ? "null" : value.ToString());
                }
            }
        }

        public static IEnumerable<IExtractionProduct> Populate(Context cx, IEntity @object, CustomAttributeHandleCollection attributes)
        {
            foreach (var attrib in attributes)
            {
                yield return new Attribute(cx, @object, attrib);
            }
        }
    }

    /// <summary>
    /// Helper class to decode the attribute structure.
    /// Note that there are some unhandled cases that should be fixed in due course.
    /// </summary>
    class CustomAttributeDecoder : ICustomAttributeTypeProvider<Type>
    {
        readonly Context cx;
        public CustomAttributeDecoder(Context cx) { this.cx = cx; }

        public Type GetPrimitiveType(PrimitiveTypeCode typeCode) => cx.Create(typeCode);

        public Type GetSystemType() => throw new NotImplementedException();

        public Type GetSZArrayType(Type elementType) =>
            cx.Populate(new ArrayType(cx, elementType));

        public Type GetTypeFromDefinition(MetadataReader reader, TypeDefinitionHandle handle, byte rawTypeKind) =>
            (Type)cx.Create(handle);

        public Type GetTypeFromReference(MetadataReader reader, TypeReferenceHandle handle, byte rawTypeKind) =>
            (Type)cx.Create(handle);

        public Type GetTypeFromSerializedName(string name) => throw new NotImplementedException();

        public PrimitiveTypeCode GetUnderlyingEnumType(Type type) => throw new NotImplementedException();

        public bool IsSystemType(Type type) => type is PrimitiveType; // ??
    }
}
