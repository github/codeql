// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.FileProviders.Composite, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace FileProviders
        {
            namespace Composite
            {
                public class CompositeDirectoryContents : Microsoft.Extensions.FileProviders.IDirectoryContents, System.Collections.Generic.IEnumerable<Microsoft.Extensions.FileProviders.IFileInfo>, System.Collections.IEnumerable
                {
                    public CompositeDirectoryContents(System.Collections.Generic.IList<Microsoft.Extensions.FileProviders.IFileProvider> fileProviders, string subpath) => throw null;
                    public bool Exists { get => throw null; }
                    public System.Collections.Generic.IEnumerator<Microsoft.Extensions.FileProviders.IFileInfo> GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                }
            }
            public class CompositeFileProvider : Microsoft.Extensions.FileProviders.IFileProvider
            {
                public CompositeFileProvider(params Microsoft.Extensions.FileProviders.IFileProvider[] fileProviders) => throw null;
                public CompositeFileProvider(System.Collections.Generic.IEnumerable<Microsoft.Extensions.FileProviders.IFileProvider> fileProviders) => throw null;
                public System.Collections.Generic.IEnumerable<Microsoft.Extensions.FileProviders.IFileProvider> FileProviders { get => throw null; }
                public Microsoft.Extensions.FileProviders.IDirectoryContents GetDirectoryContents(string subpath) => throw null;
                public Microsoft.Extensions.FileProviders.IFileInfo GetFileInfo(string subpath) => throw null;
                public Microsoft.Extensions.Primitives.IChangeToken Watch(string pattern) => throw null;
            }
        }
    }
}
