// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace FileProviders
        {
            // Generated from `Microsoft.Extensions.FileProviders.EmbeddedFileProvider` in `Microsoft.Extensions.FileProviders.Embedded, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class EmbeddedFileProvider : Microsoft.Extensions.FileProviders.IFileProvider
            {
                public EmbeddedFileProvider(System.Reflection.Assembly assembly, string baseNamespace) => throw null;
                public EmbeddedFileProvider(System.Reflection.Assembly assembly) => throw null;
                public Microsoft.Extensions.FileProviders.IDirectoryContents GetDirectoryContents(string subpath) => throw null;
                public Microsoft.Extensions.FileProviders.IFileInfo GetFileInfo(string subpath) => throw null;
                public Microsoft.Extensions.Primitives.IChangeToken Watch(string pattern) => throw null;
            }

            // Generated from `Microsoft.Extensions.FileProviders.ManifestEmbeddedFileProvider` in `Microsoft.Extensions.FileProviders.Embedded, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ManifestEmbeddedFileProvider : Microsoft.Extensions.FileProviders.IFileProvider
            {
                public System.Reflection.Assembly Assembly { get => throw null; }
                public Microsoft.Extensions.FileProviders.IDirectoryContents GetDirectoryContents(string subpath) => throw null;
                public Microsoft.Extensions.FileProviders.IFileInfo GetFileInfo(string subpath) => throw null;
                public ManifestEmbeddedFileProvider(System.Reflection.Assembly assembly, string root, string manifestName, System.DateTimeOffset lastModified) => throw null;
                public ManifestEmbeddedFileProvider(System.Reflection.Assembly assembly, string root, System.DateTimeOffset lastModified) => throw null;
                public ManifestEmbeddedFileProvider(System.Reflection.Assembly assembly, string root) => throw null;
                public ManifestEmbeddedFileProvider(System.Reflection.Assembly assembly) => throw null;
                public Microsoft.Extensions.Primitives.IChangeToken Watch(string filter) => throw null;
            }

            namespace Embedded
            {
                // Generated from `Microsoft.Extensions.FileProviders.Embedded.EmbeddedResourceFileInfo` in `Microsoft.Extensions.FileProviders.Embedded, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class EmbeddedResourceFileInfo : Microsoft.Extensions.FileProviders.IFileInfo
                {
                    public System.IO.Stream CreateReadStream() => throw null;
                    public EmbeddedResourceFileInfo(System.Reflection.Assembly assembly, string resourcePath, string name, System.DateTimeOffset lastModified) => throw null;
                    public bool Exists { get => throw null; }
                    public bool IsDirectory { get => throw null; }
                    public System.DateTimeOffset LastModified { get => throw null; }
                    public System.Int64 Length { get => throw null; }
                    public string Name { get => throw null; }
                    public string PhysicalPath { get => throw null; }
                }

            }
        }
    }
}
