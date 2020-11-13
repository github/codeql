using System;
using System.Collections.Generic;
using System.Reflection.Metadata;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// A CIL attribute.
    /// </summary>
    internal interface IAttribute : IExtractedEntity
    {
    }

    /// <summary>
    /// Entity representing a CIL attribute.
    /// </summary>
    internal sealed class Attribute : UnlabelledEntity, IAttribute
    {
        private readonly CustomAttributeHandle handle;
        private readonly CustomAttribute attrib;
        private readonly IEntity @object;

        public Attribute(Context cx, IEntity @object, CustomAttributeHandle handle) : base(cx)
        {
            attrib = cx.MdReader.GetCustomAttribute(handle);
            this.handle = handle;
            this.@object = @object;
        }

        public override bool Equals(object? obj)
        {
            return obj is Attribute attribute && handle.Equals(attribute.handle);
        }

        public override int GetHashCode() => handle.GetHashCode();

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                var constructor = (Method)Cx.Create(attrib.Constructor);
                yield return constructor;

                yield return Tuples.cil_attribute(this, @object, constructor);

                CustomAttributeValue<Type> decoded;

                try
                {
                    decoded = attrib.DecodeValue(new CustomAttributeDecoder(Cx));
                }
                catch (NotImplementedException)
                {
                    // Attribute decoding is only partial at this stage.
                    yield break;
                }

                for (var index = 0; index < decoded.FixedArguments.Length; ++index)
                {
                    var value = decoded.FixedArguments[index].Value;
                    var stringValue = value?.ToString();
                    yield return Tuples.cil_attribute_positional_argument(this, index, stringValue ?? "null");
                }

                foreach (var p in decoded.NamedArguments)
                {
                    var value = p.Value;
                    var stringValue = value?.ToString();
                    yield return Tuples.cil_attribute_named_argument(this, p.Name, stringValue ?? "null");
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
    internal class CustomAttributeDecoder : ICustomAttributeTypeProvider<Type>
    {
        private readonly Context cx;
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
