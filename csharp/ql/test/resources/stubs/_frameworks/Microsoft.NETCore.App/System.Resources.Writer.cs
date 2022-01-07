// This file contains auto-generated code.

namespace System
{
    namespace Resources
    {
        // Generated from `System.Resources.IResourceWriter` in `System.Resources.Writer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IResourceWriter : System.IDisposable
        {
            void AddResource(string name, System.Byte[] value);
            void AddResource(string name, object value);
            void AddResource(string name, string value);
            void Close();
            void Generate();
        }

        // Generated from `System.Resources.ResourceWriter` in `System.Resources.Writer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ResourceWriter : System.IDisposable, System.Resources.IResourceWriter
        {
            public void AddResource(string name, System.Byte[] value) => throw null;
            public void AddResource(string name, System.IO.Stream value) => throw null;
            public void AddResource(string name, System.IO.Stream value, bool closeAfterWrite = default(bool)) => throw null;
            public void AddResource(string name, object value) => throw null;
            public void AddResource(string name, string value) => throw null;
            public void AddResourceData(string name, string typeName, System.Byte[] serializedData) => throw null;
            public void Close() => throw null;
            public void Dispose() => throw null;
            public void Generate() => throw null;
            public ResourceWriter(System.IO.Stream stream) => throw null;
            public ResourceWriter(string fileName) => throw null;
            public System.Func<System.Type, string> TypeNameConverter { get => throw null; set => throw null; }
        }

    }
}
