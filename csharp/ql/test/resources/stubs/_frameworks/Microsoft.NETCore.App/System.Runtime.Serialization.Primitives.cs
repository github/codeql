// This file contains auto-generated code.
// Generated from `System.Runtime.Serialization.Primitives, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Runtime
    {
        namespace Serialization
        {
            [System.AttributeUsage((System.AttributeTargets)12, Inherited = false, AllowMultiple = false)]
            public sealed class CollectionDataContractAttribute : System.Attribute
            {
                public CollectionDataContractAttribute() => throw null;
                public bool IsItemNameSetExplicitly { get => throw null; }
                public bool IsKeyNameSetExplicitly { get => throw null; }
                public bool IsNameSetExplicitly { get => throw null; }
                public bool IsNamespaceSetExplicitly { get => throw null; }
                public bool IsReference { get => throw null; set { } }
                public bool IsReferenceSetExplicitly { get => throw null; }
                public bool IsValueNameSetExplicitly { get => throw null; }
                public string ItemName { get => throw null; set { } }
                public string KeyName { get => throw null; set { } }
                public string Name { get => throw null; set { } }
                public string Namespace { get => throw null; set { } }
                public string ValueName { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)3, Inherited = false, AllowMultiple = true)]
            public sealed class ContractNamespaceAttribute : System.Attribute
            {
                public string ClrNamespace { get => throw null; set { } }
                public string ContractNamespace { get => throw null; }
                public ContractNamespaceAttribute(string contractNamespace) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)28, Inherited = false, AllowMultiple = false)]
            public sealed class DataContractAttribute : System.Attribute
            {
                public DataContractAttribute() => throw null;
                public bool IsNameSetExplicitly { get => throw null; }
                public bool IsNamespaceSetExplicitly { get => throw null; }
                public bool IsReference { get => throw null; set { } }
                public bool IsReferenceSetExplicitly { get => throw null; }
                public string Name { get => throw null; set { } }
                public string Namespace { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)384, Inherited = false, AllowMultiple = false)]
            public sealed class DataMemberAttribute : System.Attribute
            {
                public DataMemberAttribute() => throw null;
                public bool EmitDefaultValue { get => throw null; set { } }
                public bool IsNameSetExplicitly { get => throw null; }
                public bool IsRequired { get => throw null; set { } }
                public string Name { get => throw null; set { } }
                public int Order { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)256, Inherited = false, AllowMultiple = false)]
            public sealed class EnumMemberAttribute : System.Attribute
            {
                public EnumMemberAttribute() => throw null;
                public bool IsValueSetExplicitly { get => throw null; }
                public string Value { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)384, Inherited = false, AllowMultiple = false)]
            public sealed class IgnoreDataMemberAttribute : System.Attribute
            {
                public IgnoreDataMemberAttribute() => throw null;
            }
            public class InvalidDataContractException : System.Exception
            {
                public InvalidDataContractException() => throw null;
                protected InvalidDataContractException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public InvalidDataContractException(string message) => throw null;
                public InvalidDataContractException(string message, System.Exception innerException) => throw null;
            }
            public interface ISerializationSurrogateProvider
            {
                object GetDeserializedObject(object obj, System.Type targetType);
                object GetObjectToSerialize(object obj, System.Type targetType);
                System.Type GetSurrogateType(System.Type type);
            }
            public interface ISerializationSurrogateProvider2 : System.Runtime.Serialization.ISerializationSurrogateProvider
            {
                object GetCustomDataToExport(System.Reflection.MemberInfo memberInfo, System.Type dataContractType);
                object GetCustomDataToExport(System.Type runtimeType, System.Type dataContractType);
                void GetKnownCustomDataTypes(System.Collections.ObjectModel.Collection<System.Type> customDataTypes);
                System.Type GetReferencedTypeOnImport(string typeName, string typeNamespace, object customData);
            }
            [System.AttributeUsage((System.AttributeTargets)12, Inherited = true, AllowMultiple = true)]
            public sealed class KnownTypeAttribute : System.Attribute
            {
                public KnownTypeAttribute(string methodName) => throw null;
                public KnownTypeAttribute(System.Type type) => throw null;
                public string MethodName { get => throw null; }
                public System.Type Type { get => throw null; }
            }
        }
    }
}
