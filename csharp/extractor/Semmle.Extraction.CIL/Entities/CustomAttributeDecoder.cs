using System;
using System.Collections.Generic;
using System.Reflection.Metadata;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// Helper class to decode the attribute structure.
    /// Note that there are some unhandled cases that should be fixed in due course.
    /// </summary>
    internal class CustomAttributeDecoder : ICustomAttributeTypeProvider<Type>
    {
        private readonly Context cx;
        public CustomAttributeDecoder(Context cx) { this.cx = cx; }

        public Type GetPrimitiveType(PrimitiveTypeCode typeCode) => cx.Create(typeCode);

        public Type GetSystemType() => new NoMetadataHandleType(cx, "System.Type");

        public Type GetSZArrayType(Type elementType) =>
            cx.Populate(new ArrayType(cx, elementType));

        public Type GetTypeFromDefinition(MetadataReader reader, TypeDefinitionHandle handle, byte rawTypeKind) =>
            (Type)cx.Create(handle);

        public Type GetTypeFromReference(MetadataReader reader, TypeReferenceHandle handle, byte rawTypeKind) =>
            (Type)cx.Create(handle);

        public Type GetTypeFromSerializedName(string name) => new NoMetadataHandleType(cx, name);

        public PrimitiveTypeCode GetUnderlyingEnumType(Type type)
        {
            if (type is TypeDefinitionType tdt &&
                tdt.GetUnderlyingEnumType() is PrimitiveTypeCode underlying)
            {
                return underlying;
            }

            var name = type.GetQualifiedName();

            if (wellKnownEnums.TryGetValue(name, out var code))
            {
                cx.Extractor.Logger.Log(Util.Logging.Severity.Debug, $"Using hard coded underlying enum type for {name}");
                return code;
            }

            cx.Extractor.Logger.Log(Util.Logging.Severity.Info, $"Couldn't get underlying enum type for {name}");

            // We can't fall back to Int32, because the type returned here defines how many bytes are read from the
            // stream and how those bytes are interpreted.
            throw new NotImplementedException();
        }

        public bool IsSystemType(Type type) => type.GetQualifiedName() == "System.Type";

        private static readonly Dictionary<string, PrimitiveTypeCode> wellKnownEnums = new Dictionary<string, PrimitiveTypeCode>
        {
            { "System.AttributeTargets", PrimitiveTypeCode.Int32 },
            { "System.ComponentModel.EditorBrowsableState", PrimitiveTypeCode.Int32 },
            { "System.Diagnostics.DebuggerBrowsableState", PrimitiveTypeCode.Int32 }
        };
    }
}
