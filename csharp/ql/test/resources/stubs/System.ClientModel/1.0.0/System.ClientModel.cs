// This file contains auto-generated code.
// Generated from `System.ClientModel, Version=1.0.0.0, Culture=neutral, PublicKeyToken=92742159e12e44c8`.
namespace System
{
    namespace ClientModel
    {
        namespace Primitives
        {
            public interface IJsonModel<T> : System.ClientModel.Primitives.IPersistableModel<T>
            {
                T Create(ref System.Text.Json.Utf8JsonReader reader, System.ClientModel.Primitives.ModelReaderWriterOptions options);
                void Write(System.Text.Json.Utf8JsonWriter writer, System.ClientModel.Primitives.ModelReaderWriterOptions options);
            }
            public interface IPersistableModel<T>
            {
                T Create(System.BinaryData data, System.ClientModel.Primitives.ModelReaderWriterOptions options);
                string GetFormatFromOptions(System.ClientModel.Primitives.ModelReaderWriterOptions options);
                System.BinaryData Write(System.ClientModel.Primitives.ModelReaderWriterOptions options);
            }
            public static class ModelReaderWriter
            {
                public static T Read<T>(System.BinaryData data, System.ClientModel.Primitives.ModelReaderWriterOptions options = default(System.ClientModel.Primitives.ModelReaderWriterOptions)) where T : System.ClientModel.Primitives.IPersistableModel<T> => throw null;
                public static object Read(System.BinaryData data, System.Type returnType, System.ClientModel.Primitives.ModelReaderWriterOptions options = default(System.ClientModel.Primitives.ModelReaderWriterOptions)) => throw null;
                public static System.BinaryData Write<T>(T model, System.ClientModel.Primitives.ModelReaderWriterOptions options = default(System.ClientModel.Primitives.ModelReaderWriterOptions)) where T : System.ClientModel.Primitives.IPersistableModel<T> => throw null;
                public static System.BinaryData Write(object model, System.ClientModel.Primitives.ModelReaderWriterOptions options = default(System.ClientModel.Primitives.ModelReaderWriterOptions)) => throw null;
            }
            public class ModelReaderWriterOptions
            {
                public ModelReaderWriterOptions(string format) => throw null;
                public string Format { get => throw null; }
                public static System.ClientModel.Primitives.ModelReaderWriterOptions Json { get => throw null; }
                public static System.ClientModel.Primitives.ModelReaderWriterOptions Xml { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)4)]
            public sealed class PersistableModelProxyAttribute : System.Attribute
            {
                public PersistableModelProxyAttribute(System.Type proxyType) => throw null;
                public System.Type ProxyType { get => throw null; }
            }
        }
    }
}
