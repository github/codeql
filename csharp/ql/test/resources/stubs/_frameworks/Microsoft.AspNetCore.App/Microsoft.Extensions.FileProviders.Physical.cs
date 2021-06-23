// This file contains auto-generated code.

namespace Microsoft
{
    namespace Extensions
    {
        namespace FileProviders
        {
            // Generated from `Microsoft.Extensions.FileProviders.PhysicalFileProvider` in `Microsoft.Extensions.FileProviders.Physical, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class PhysicalFileProvider : System.IDisposable, Microsoft.Extensions.FileProviders.IFileProvider
            {
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public Microsoft.Extensions.FileProviders.IDirectoryContents GetDirectoryContents(string subpath) => throw null;
                public Microsoft.Extensions.FileProviders.IFileInfo GetFileInfo(string subpath) => throw null;
                public PhysicalFileProvider(string root, Microsoft.Extensions.FileProviders.Physical.ExclusionFilters filters) => throw null;
                public PhysicalFileProvider(string root) => throw null;
                public string Root { get => throw null; }
                public bool UseActivePolling { get => throw null; set => throw null; }
                public bool UsePollingFileWatcher { get => throw null; set => throw null; }
                public Microsoft.Extensions.Primitives.IChangeToken Watch(string filter) => throw null;
                // ERR: Stub generator didn't handle member: ~PhysicalFileProvider
            }

            namespace Internal
            {
                // Generated from `Microsoft.Extensions.FileProviders.Internal.PhysicalDirectoryContents` in `Microsoft.Extensions.FileProviders.Physical, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PhysicalDirectoryContents : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<Microsoft.Extensions.FileProviders.IFileInfo>, Microsoft.Extensions.FileProviders.IDirectoryContents
                {
                    public bool Exists { get => throw null; }
                    public System.Collections.Generic.IEnumerator<Microsoft.Extensions.FileProviders.IFileInfo> GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public PhysicalDirectoryContents(string directory, Microsoft.Extensions.FileProviders.Physical.ExclusionFilters filters) => throw null;
                    public PhysicalDirectoryContents(string directory) => throw null;
                }

            }
            namespace Physical
            {
                // Generated from `Microsoft.Extensions.FileProviders.Physical.ExclusionFilters` in `Microsoft.Extensions.FileProviders.Physical, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                [System.Flags]
                public enum ExclusionFilters
                {
                    DotPrefixed,
                    Hidden,
                    None,
                    Sensitive,
                    System,
                }

                // Generated from `Microsoft.Extensions.FileProviders.Physical.PhysicalDirectoryInfo` in `Microsoft.Extensions.FileProviders.Physical, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PhysicalDirectoryInfo : Microsoft.Extensions.FileProviders.IFileInfo
                {
                    public System.IO.Stream CreateReadStream() => throw null;
                    public bool Exists { get => throw null; }
                    public bool IsDirectory { get => throw null; }
                    public System.DateTimeOffset LastModified { get => throw null; }
                    public System.Int64 Length { get => throw null; }
                    public string Name { get => throw null; }
                    public PhysicalDirectoryInfo(System.IO.DirectoryInfo info) => throw null;
                    public string PhysicalPath { get => throw null; }
                }

                // Generated from `Microsoft.Extensions.FileProviders.Physical.PhysicalFileInfo` in `Microsoft.Extensions.FileProviders.Physical, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PhysicalFileInfo : Microsoft.Extensions.FileProviders.IFileInfo
                {
                    public System.IO.Stream CreateReadStream() => throw null;
                    public bool Exists { get => throw null; }
                    public bool IsDirectory { get => throw null; }
                    public System.DateTimeOffset LastModified { get => throw null; }
                    public System.Int64 Length { get => throw null; }
                    public string Name { get => throw null; }
                    public PhysicalFileInfo(System.IO.FileInfo info) => throw null;
                    public string PhysicalPath { get => throw null; }
                }

                // Generated from `Microsoft.Extensions.FileProviders.Physical.PhysicalFilesWatcher` in `Microsoft.Extensions.FileProviders.Physical, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PhysicalFilesWatcher : System.IDisposable
                {
                    public Microsoft.Extensions.Primitives.IChangeToken CreateFileChangeToken(string filter) => throw null;
                    public void Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    public PhysicalFilesWatcher(string root, System.IO.FileSystemWatcher fileSystemWatcher, bool pollForChanges, Microsoft.Extensions.FileProviders.Physical.ExclusionFilters filters) => throw null;
                    public PhysicalFilesWatcher(string root, System.IO.FileSystemWatcher fileSystemWatcher, bool pollForChanges) => throw null;
                    // ERR: Stub generator didn't handle member: ~PhysicalFilesWatcher
                }

                // Generated from `Microsoft.Extensions.FileProviders.Physical.PollingFileChangeToken` in `Microsoft.Extensions.FileProviders.Physical, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PollingFileChangeToken : Microsoft.Extensions.Primitives.IChangeToken
                {
                    public bool ActiveChangeCallbacks { get => throw null; }
                    public bool HasChanged { get => throw null; }
                    public PollingFileChangeToken(System.IO.FileInfo fileInfo) => throw null;
                    public System.IDisposable RegisterChangeCallback(System.Action<object> callback, object state) => throw null;
                }

                // Generated from `Microsoft.Extensions.FileProviders.Physical.PollingWildCardChangeToken` in `Microsoft.Extensions.FileProviders.Physical, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PollingWildCardChangeToken : Microsoft.Extensions.Primitives.IChangeToken
                {
                    public bool ActiveChangeCallbacks { get => throw null; }
                    protected virtual System.DateTime GetLastWriteUtc(string path) => throw null;
                    public bool HasChanged { get => throw null; }
                    public PollingWildCardChangeToken(string root, string pattern) => throw null;
                    System.IDisposable Microsoft.Extensions.Primitives.IChangeToken.RegisterChangeCallback(System.Action<object> callback, object state) => throw null;
                }

            }
        }
    }
}
