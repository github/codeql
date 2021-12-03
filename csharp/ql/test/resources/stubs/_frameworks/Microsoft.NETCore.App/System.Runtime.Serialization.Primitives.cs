// This file contains auto-generated code.

namespace System
{
    namespace Runtime
    {
        namespace Serialization
        {
            // Generated from `System.Runtime.Serialization.CollectionDataContractAttribute` in `System.Runtime.Serialization.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CollectionDataContractAttribute : System.Attribute
            {
                public CollectionDataContractAttribute() => throw null;
                public bool IsItemNameSetExplicitly { get => throw null; }
                public bool IsKeyNameSetExplicitly { get => throw null; }
                public bool IsNameSetExplicitly { get => throw null; }
                public bool IsNamespaceSetExplicitly { get => throw null; }
                public bool IsReference { get => throw null; set => throw null; }
                public bool IsReferenceSetExplicitly { get => throw null; }
                public bool IsValueNameSetExplicitly { get => throw null; }
                public string ItemName { get => throw null; set => throw null; }
                public string KeyName { get => throw null; set => throw null; }
                public string Name { get => throw null; set => throw null; }
                public string Namespace { get => throw null; set => throw null; }
                public string ValueName { get => throw null; set => throw null; }
            }

            // Generated from `System.Runtime.Serialization.ContractNamespaceAttribute` in `System.Runtime.Serialization.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ContractNamespaceAttribute : System.Attribute
            {
                public string ClrNamespace { get => throw null; set => throw null; }
                public string ContractNamespace { get => throw null; }
                public ContractNamespaceAttribute(string contractNamespace) => throw null;
            }

            // Generated from `System.Runtime.Serialization.DataContractAttribute` in `System.Runtime.Serialization.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DataContractAttribute : System.Attribute
            {
                public DataContractAttribute() => throw null;
                public bool IsNameSetExplicitly { get => throw null; }
                public bool IsNamespaceSetExplicitly { get => throw null; }
                public bool IsReference { get => throw null; set => throw null; }
                public bool IsReferenceSetExplicitly { get => throw null; }
                public string Name { get => throw null; set => throw null; }
                public string Namespace { get => throw null; set => throw null; }
            }

            // Generated from `System.Runtime.Serialization.DataMemberAttribute` in `System.Runtime.Serialization.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DataMemberAttribute : System.Attribute
            {
                public DataMemberAttribute() => throw null;
                public bool EmitDefaultValue { get => throw null; set => throw null; }
                public bool IsNameSetExplicitly { get => throw null; }
                public bool IsRequired { get => throw null; set => throw null; }
                public string Name { get => throw null; set => throw null; }
                public int Order { get => throw null; set => throw null; }
            }

            // Generated from `System.Runtime.Serialization.EnumMemberAttribute` in `System.Runtime.Serialization.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class EnumMemberAttribute : System.Attribute
            {
                public EnumMemberAttribute() => throw null;
                public bool IsValueSetExplicitly { get => throw null; }
                public string Value { get => throw null; set => throw null; }
            }

            // Generated from `System.Runtime.Serialization.ISerializationSurrogateProvider` in `System.Runtime.Serialization.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ISerializationSurrogateProvider
            {
                object GetDeserializedObject(object obj, System.Type targetType);
                object GetObjectToSerialize(object obj, System.Type targetType);
                System.Type GetSurrogateType(System.Type type);
            }

            // Generated from `System.Runtime.Serialization.IgnoreDataMemberAttribute` in `System.Runtime.Serialization.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class IgnoreDataMemberAttribute : System.Attribute
            {
                public IgnoreDataMemberAttribute() => throw null;
            }

            // Generated from `System.Runtime.Serialization.InvalidDataContractException` in `System.Runtime.Serialization.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class InvalidDataContractException : System.Exception
            {
                public InvalidDataContractException() => throw null;
                protected InvalidDataContractException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public InvalidDataContractException(string message) => throw null;
                public InvalidDataContractException(string message, System.Exception innerException) => throw null;
            }

            // Generated from `System.Runtime.Serialization.KnownTypeAttribute` in `System.Runtime.Serialization.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class KnownTypeAttribute : System.Attribute
            {
                public KnownTypeAttribute(System.Type type) => throw null;
                public KnownTypeAttribute(string methodName) => throw null;
                public string MethodName { get => throw null; }
                public System.Type Type { get => throw null; }
            }

        }
    }
}
