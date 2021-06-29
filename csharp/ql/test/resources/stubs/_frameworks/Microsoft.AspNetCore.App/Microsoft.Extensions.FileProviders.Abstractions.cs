// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace FileProviders
        {
            // Generated from `Microsoft.Extensions.FileProviders.IDirectoryContents` in `Microsoft.Extensions.FileProviders.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IDirectoryContents : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<Microsoft.Extensions.FileProviders.IFileInfo>
            {
                bool Exists { get; }
            }

            // Generated from `Microsoft.Extensions.FileProviders.IFileInfo` in `Microsoft.Extensions.FileProviders.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IFileInfo
            {
                System.IO.Stream CreateReadStream();
                bool Exists { get; }
                bool IsDirectory { get; }
                System.DateTimeOffset LastModified { get; }
                System.Int64 Length { get; }
                string Name { get; }
                string PhysicalPath { get; }
            }

            // Generated from `Microsoft.Extensions.FileProviders.IFileProvider` in `Microsoft.Extensions.FileProviders.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IFileProvider
            {
                Microsoft.Extensions.FileProviders.IDirectoryContents GetDirectoryContents(string subpath);
                Microsoft.Extensions.FileProviders.IFileInfo GetFileInfo(string subpath);
                Microsoft.Extensions.Primitives.IChangeToken Watch(string filter);
            }

            // Generated from `Microsoft.Extensions.FileProviders.NotFoundDirectoryContents` in `Microsoft.Extensions.FileProviders.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class NotFoundDirectoryContents : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<Microsoft.Extensions.FileProviders.IFileInfo>, Microsoft.Extensions.FileProviders.IDirectoryContents
            {
                public bool Exists { get => throw null; }
                public System.Collections.Generic.IEnumerator<Microsoft.Extensions.FileProviders.IFileInfo> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public NotFoundDirectoryContents() => throw null;
                public static Microsoft.Extensions.FileProviders.NotFoundDirectoryContents Singleton { get => throw null; }
            }

            // Generated from `Microsoft.Extensions.FileProviders.NotFoundFileInfo` in `Microsoft.Extensions.FileProviders.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class NotFoundFileInfo : Microsoft.Extensions.FileProviders.IFileInfo
            {
                public System.IO.Stream CreateReadStream() => throw null;
                public bool Exists { get => throw null; }
                public bool IsDirectory { get => throw null; }
                public System.DateTimeOffset LastModified { get => throw null; }
                public System.Int64 Length { get => throw null; }
                public string Name { get => throw null; }
                public NotFoundFileInfo(string name) => throw null;
                public string PhysicalPath { get => throw null; }
            }

            // Generated from `Microsoft.Extensions.FileProviders.NullChangeToken` in `Microsoft.Extensions.FileProviders.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class NullChangeToken : Microsoft.Extensions.Primitives.IChangeToken
            {
                public bool ActiveChangeCallbacks { get => throw null; }
                public bool HasChanged { get => throw null; }
                public System.IDisposable RegisterChangeCallback(System.Action<object> callback, object state) => throw null;
                public static Microsoft.Extensions.FileProviders.NullChangeToken Singleton { get => throw null; }
            }

            // Generated from `Microsoft.Extensions.FileProviders.NullFileProvider` in `Microsoft.Extensions.FileProviders.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class NullFileProvider : Microsoft.Extensions.FileProviders.IFileProvider
            {
                public Microsoft.Extensions.FileProviders.IDirectoryContents GetDirectoryContents(string subpath) => throw null;
                public Microsoft.Extensions.FileProviders.IFileInfo GetFileInfo(string subpath) => throw null;
                public NullFileProvider() => throw null;
                public Microsoft.Extensions.Primitives.IChangeToken Watch(string filter) => throw null;
            }

        }
    }
}
