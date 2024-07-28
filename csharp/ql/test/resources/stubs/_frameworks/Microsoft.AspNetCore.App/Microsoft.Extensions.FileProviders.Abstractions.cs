// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.FileProviders.Abstractions, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace FileProviders
        {
            public interface IDirectoryContents : System.Collections.Generic.IEnumerable<Microsoft.Extensions.FileProviders.IFileInfo>, System.Collections.IEnumerable
            {
                bool Exists { get; }
            }
            public interface IFileInfo
            {
                System.IO.Stream CreateReadStream();
                bool Exists { get; }
                bool IsDirectory { get; }
                System.DateTimeOffset LastModified { get; }
                long Length { get; }
                string Name { get; }
                string PhysicalPath { get; }
            }
            public interface IFileProvider
            {
                Microsoft.Extensions.FileProviders.IDirectoryContents GetDirectoryContents(string subpath);
                Microsoft.Extensions.FileProviders.IFileInfo GetFileInfo(string subpath);
                Microsoft.Extensions.Primitives.IChangeToken Watch(string filter);
            }
            public class NotFoundDirectoryContents : Microsoft.Extensions.FileProviders.IDirectoryContents, System.Collections.Generic.IEnumerable<Microsoft.Extensions.FileProviders.IFileInfo>, System.Collections.IEnumerable
            {
                public NotFoundDirectoryContents() => throw null;
                public bool Exists { get => throw null; }
                public System.Collections.Generic.IEnumerator<Microsoft.Extensions.FileProviders.IFileInfo> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public static Microsoft.Extensions.FileProviders.NotFoundDirectoryContents Singleton { get => throw null; }
            }
            public class NotFoundFileInfo : Microsoft.Extensions.FileProviders.IFileInfo
            {
                public System.IO.Stream CreateReadStream() => throw null;
                public NotFoundFileInfo(string name) => throw null;
                public bool Exists { get => throw null; }
                public bool IsDirectory { get => throw null; }
                public System.DateTimeOffset LastModified { get => throw null; }
                public long Length { get => throw null; }
                public string Name { get => throw null; }
                public string PhysicalPath { get => throw null; }
            }
            public class NullChangeToken : Microsoft.Extensions.Primitives.IChangeToken
            {
                public bool ActiveChangeCallbacks { get => throw null; }
                public bool HasChanged { get => throw null; }
                public System.IDisposable RegisterChangeCallback(System.Action<object> callback, object state) => throw null;
                public static Microsoft.Extensions.FileProviders.NullChangeToken Singleton { get => throw null; }
            }
            public class NullFileProvider : Microsoft.Extensions.FileProviders.IFileProvider
            {
                public NullFileProvider() => throw null;
                public Microsoft.Extensions.FileProviders.IDirectoryContents GetDirectoryContents(string subpath) => throw null;
                public Microsoft.Extensions.FileProviders.IFileInfo GetFileInfo(string subpath) => throw null;
                public Microsoft.Extensions.Primitives.IChangeToken Watch(string filter) => throw null;
            }
        }
    }
}
