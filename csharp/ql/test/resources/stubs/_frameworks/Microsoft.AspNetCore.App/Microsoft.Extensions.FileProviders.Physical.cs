// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.FileProviders.Physical, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace FileProviders
        {
            namespace Internal
            {
                public class PhysicalDirectoryContents : Microsoft.Extensions.FileProviders.IDirectoryContents, System.Collections.Generic.IEnumerable<Microsoft.Extensions.FileProviders.IFileInfo>, System.Collections.IEnumerable
                {
                    public PhysicalDirectoryContents(string directory) => throw null;
                    public PhysicalDirectoryContents(string directory, Microsoft.Extensions.FileProviders.Physical.ExclusionFilters filters) => throw null;
                    public bool Exists { get => throw null; }
                    public System.Collections.Generic.IEnumerator<Microsoft.Extensions.FileProviders.IFileInfo> GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                }
            }
            namespace Physical
            {
                [System.Flags]
                public enum ExclusionFilters
                {
                    None = 0,
                    DotPrefixed = 1,
                    Hidden = 2,
                    System = 4,
                    Sensitive = 7,
                }
                public class PhysicalDirectoryInfo : Microsoft.Extensions.FileProviders.IFileInfo
                {
                    public System.IO.Stream CreateReadStream() => throw null;
                    public PhysicalDirectoryInfo(System.IO.DirectoryInfo info) => throw null;
                    public bool Exists { get => throw null; }
                    public bool IsDirectory { get => throw null; }
                    public System.DateTimeOffset LastModified { get => throw null; }
                    public long Length { get => throw null; }
                    public string Name { get => throw null; }
                    public string PhysicalPath { get => throw null; }
                }
                public class PhysicalFileInfo : Microsoft.Extensions.FileProviders.IFileInfo
                {
                    public System.IO.Stream CreateReadStream() => throw null;
                    public PhysicalFileInfo(System.IO.FileInfo info) => throw null;
                    public bool Exists { get => throw null; }
                    public bool IsDirectory { get => throw null; }
                    public System.DateTimeOffset LastModified { get => throw null; }
                    public long Length { get => throw null; }
                    public string Name { get => throw null; }
                    public string PhysicalPath { get => throw null; }
                }
                public class PhysicalFilesWatcher : System.IDisposable
                {
                    public Microsoft.Extensions.Primitives.IChangeToken CreateFileChangeToken(string filter) => throw null;
                    public PhysicalFilesWatcher(string root, System.IO.FileSystemWatcher fileSystemWatcher, bool pollForChanges) => throw null;
                    public PhysicalFilesWatcher(string root, System.IO.FileSystemWatcher fileSystemWatcher, bool pollForChanges, Microsoft.Extensions.FileProviders.Physical.ExclusionFilters filters) => throw null;
                    public void Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                }
                public class PollingFileChangeToken : Microsoft.Extensions.Primitives.IChangeToken
                {
                    public bool ActiveChangeCallbacks { get => throw null; }
                    public PollingFileChangeToken(System.IO.FileInfo fileInfo) => throw null;
                    public bool HasChanged { get => throw null; }
                    public System.IDisposable RegisterChangeCallback(System.Action<object> callback, object state) => throw null;
                }
                public class PollingWildCardChangeToken : Microsoft.Extensions.Primitives.IChangeToken
                {
                    public bool ActiveChangeCallbacks { get => throw null; }
                    public PollingWildCardChangeToken(string root, string pattern) => throw null;
                    protected virtual System.DateTime GetLastWriteUtc(string path) => throw null;
                    public bool HasChanged { get => throw null; }
                    System.IDisposable Microsoft.Extensions.Primitives.IChangeToken.RegisterChangeCallback(System.Action<object> callback, object state) => throw null;
                }
            }
            public class PhysicalFileProvider : System.IDisposable, Microsoft.Extensions.FileProviders.IFileProvider
            {
                public PhysicalFileProvider(string root) => throw null;
                public PhysicalFileProvider(string root, Microsoft.Extensions.FileProviders.Physical.ExclusionFilters filters) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public Microsoft.Extensions.FileProviders.IDirectoryContents GetDirectoryContents(string subpath) => throw null;
                public Microsoft.Extensions.FileProviders.IFileInfo GetFileInfo(string subpath) => throw null;
                public string Root { get => throw null; }
                public bool UseActivePolling { get => throw null; set { } }
                public bool UsePollingFileWatcher { get => throw null; set { } }
                public Microsoft.Extensions.Primitives.IChangeToken Watch(string filter) => throw null;
            }
        }
    }
}
