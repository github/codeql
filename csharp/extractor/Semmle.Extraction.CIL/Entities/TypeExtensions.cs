using System.Reflection.Metadata;

namespace Semmle.Extraction.CIL.Entities
{
    public static class TypeExtensions
    {
        public static bool IsEnum(this EntityHandle type, MetadataReader metadataReader) => type.HasMatchingName("System.Enum", metadataReader);

        public static bool HasMatchingName(this EntityHandle type, string nonGenericName, MetadataReader metadataReader)
        {
            return type.Kind switch
            {
                HandleKind.TypeReference => ((TypeReferenceHandle)type).GetQualifiedName(metadataReader) == nonGenericName,
                HandleKind.TypeDefinition => ((TypeDefinitionHandle)type).GetQualifiedName(metadataReader) == nonGenericName,
                _ => false,
            };
        }

        private static string GetQualifiedName(this TypeDefinitionHandle typeHandle, MetadataReader metadataReader)
        {
            var type = metadataReader.GetTypeDefinition(typeHandle);
            var declaringTypeHandle = type.GetDeclaringType();
            var name = metadataReader.GetString(type.Name);

            if (!declaringTypeHandle.IsNil)
            {
                return declaringTypeHandle.GetQualifiedName(metadataReader) + "." + name;
            }

            if (type.Namespace.IsNil)
            {
                return name;
            }

            return metadataReader.GetString(type.Namespace) + "." + name;
        }

        private static string GetQualifiedName(this TypeReferenceHandle typeHandle, MetadataReader metadataReader)
        {
            var type = metadataReader.GetTypeReference(typeHandle);
            var declaringTypeHandle = type.ResolutionScope.Kind == HandleKind.TypeReference
                ? (TypeReferenceHandle)type.ResolutionScope
                : default;
            var name = metadataReader.GetString(type.Name);

            if (!declaringTypeHandle.IsNil)
            {
                return declaringTypeHandle.GetQualifiedName(metadataReader) + "." + name;
            }

            if (type.Namespace.IsNil)
            {
                return name;
            }

            return metadataReader.GetString(type.Namespace) + "." + name;
        }
    }
}
