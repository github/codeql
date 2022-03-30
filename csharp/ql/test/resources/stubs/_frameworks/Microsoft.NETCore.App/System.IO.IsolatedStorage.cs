// This file contains auto-generated code.

namespace System
{
    namespace IO
    {
        namespace IsolatedStorage
        {
            // Generated from `System.IO.IsolatedStorage.INormalizeForIsolatedStorage` in `System.IO.IsolatedStorage, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface INormalizeForIsolatedStorage
            {
                object Normalize();
            }

            // Generated from `System.IO.IsolatedStorage.IsolatedStorage` in `System.IO.IsolatedStorage, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class IsolatedStorage : System.MarshalByRefObject
            {
                public object ApplicationIdentity { get => throw null; }
                public object AssemblyIdentity { get => throw null; }
                public virtual System.Int64 AvailableFreeSpace { get => throw null; }
                public virtual System.UInt64 CurrentSize { get => throw null; }
                public object DomainIdentity { get => throw null; }
                public virtual bool IncreaseQuotaTo(System.Int64 newQuotaSize) => throw null;
                protected void InitStore(System.IO.IsolatedStorage.IsolatedStorageScope scope, System.Type appEvidenceType) => throw null;
                protected void InitStore(System.IO.IsolatedStorage.IsolatedStorageScope scope, System.Type domainEvidenceType, System.Type assemblyEvidenceType) => throw null;
                protected IsolatedStorage() => throw null;
                public virtual System.UInt64 MaximumSize { get => throw null; }
                public virtual System.Int64 Quota { get => throw null; }
                public abstract void Remove();
                public System.IO.IsolatedStorage.IsolatedStorageScope Scope { get => throw null; }
                protected virtual System.Char SeparatorExternal { get => throw null; }
                protected virtual System.Char SeparatorInternal { get => throw null; }
                public virtual System.Int64 UsedSize { get => throw null; }
            }

            // Generated from `System.IO.IsolatedStorage.IsolatedStorageException` in `System.IO.IsolatedStorage, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class IsolatedStorageException : System.Exception
            {
                public IsolatedStorageException() => throw null;
                protected IsolatedStorageException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public IsolatedStorageException(string message) => throw null;
                public IsolatedStorageException(string message, System.Exception inner) => throw null;
            }

            // Generated from `System.IO.IsolatedStorage.IsolatedStorageFile` in `System.IO.IsolatedStorage, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class IsolatedStorageFile : System.IO.IsolatedStorage.IsolatedStorage, System.IDisposable
            {
                public override System.Int64 AvailableFreeSpace { get => throw null; }
                public void Close() => throw null;
                public void CopyFile(string sourceFileName, string destinationFileName) => throw null;
                public void CopyFile(string sourceFileName, string destinationFileName, bool overwrite) => throw null;
                public void CreateDirectory(string dir) => throw null;
                public System.IO.IsolatedStorage.IsolatedStorageFileStream CreateFile(string path) => throw null;
                public override System.UInt64 CurrentSize { get => throw null; }
                public void DeleteDirectory(string dir) => throw null;
                public void DeleteFile(string file) => throw null;
                public bool DirectoryExists(string path) => throw null;
                public void Dispose() => throw null;
                public bool FileExists(string path) => throw null;
                public System.DateTimeOffset GetCreationTime(string path) => throw null;
                public string[] GetDirectoryNames() => throw null;
                public string[] GetDirectoryNames(string searchPattern) => throw null;
                public static System.Collections.IEnumerator GetEnumerator(System.IO.IsolatedStorage.IsolatedStorageScope scope) => throw null;
                public string[] GetFileNames() => throw null;
                public string[] GetFileNames(string searchPattern) => throw null;
                public System.DateTimeOffset GetLastAccessTime(string path) => throw null;
                public System.DateTimeOffset GetLastWriteTime(string path) => throw null;
                public static System.IO.IsolatedStorage.IsolatedStorageFile GetMachineStoreForApplication() => throw null;
                public static System.IO.IsolatedStorage.IsolatedStorageFile GetMachineStoreForAssembly() => throw null;
                public static System.IO.IsolatedStorage.IsolatedStorageFile GetMachineStoreForDomain() => throw null;
                public static System.IO.IsolatedStorage.IsolatedStorageFile GetStore(System.IO.IsolatedStorage.IsolatedStorageScope scope, System.Type applicationEvidenceType) => throw null;
                public static System.IO.IsolatedStorage.IsolatedStorageFile GetStore(System.IO.IsolatedStorage.IsolatedStorageScope scope, System.Type domainEvidenceType, System.Type assemblyEvidenceType) => throw null;
                public static System.IO.IsolatedStorage.IsolatedStorageFile GetStore(System.IO.IsolatedStorage.IsolatedStorageScope scope, object applicationIdentity) => throw null;
                public static System.IO.IsolatedStorage.IsolatedStorageFile GetStore(System.IO.IsolatedStorage.IsolatedStorageScope scope, object domainIdentity, object assemblyIdentity) => throw null;
                public static System.IO.IsolatedStorage.IsolatedStorageFile GetUserStoreForApplication() => throw null;
                public static System.IO.IsolatedStorage.IsolatedStorageFile GetUserStoreForAssembly() => throw null;
                public static System.IO.IsolatedStorage.IsolatedStorageFile GetUserStoreForDomain() => throw null;
                public static System.IO.IsolatedStorage.IsolatedStorageFile GetUserStoreForSite() => throw null;
                public override bool IncreaseQuotaTo(System.Int64 newQuotaSize) => throw null;
                public static bool IsEnabled { get => throw null; }
                public override System.UInt64 MaximumSize { get => throw null; }
                public void MoveDirectory(string sourceDirectoryName, string destinationDirectoryName) => throw null;
                public void MoveFile(string sourceFileName, string destinationFileName) => throw null;
                public System.IO.IsolatedStorage.IsolatedStorageFileStream OpenFile(string path, System.IO.FileMode mode) => throw null;
                public System.IO.IsolatedStorage.IsolatedStorageFileStream OpenFile(string path, System.IO.FileMode mode, System.IO.FileAccess access) => throw null;
                public System.IO.IsolatedStorage.IsolatedStorageFileStream OpenFile(string path, System.IO.FileMode mode, System.IO.FileAccess access, System.IO.FileShare share) => throw null;
                public override System.Int64 Quota { get => throw null; }
                public override void Remove() => throw null;
                public static void Remove(System.IO.IsolatedStorage.IsolatedStorageScope scope) => throw null;
                public override System.Int64 UsedSize { get => throw null; }
            }

            // Generated from `System.IO.IsolatedStorage.IsolatedStorageFileStream` in `System.IO.IsolatedStorage, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class IsolatedStorageFileStream : System.IO.FileStream
            {
                public override System.IAsyncResult BeginRead(System.Byte[] array, int offset, int numBytes, System.AsyncCallback userCallback, object stateObject) => throw null;
                public override System.IAsyncResult BeginWrite(System.Byte[] array, int offset, int numBytes, System.AsyncCallback userCallback, object stateObject) => throw null;
                public override bool CanRead { get => throw null; }
                public override bool CanSeek { get => throw null; }
                public override bool CanWrite { get => throw null; }
                protected override void Dispose(bool disposing) => throw null;
                public override System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public override int EndRead(System.IAsyncResult asyncResult) => throw null;
                public override void EndWrite(System.IAsyncResult asyncResult) => throw null;
                public override void Flush() => throw null;
                public override void Flush(bool flushToDisk) => throw null;
                public override System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.IntPtr Handle { get => throw null; }
                public override bool IsAsync { get => throw null; }
                public IsolatedStorageFileStream(string path, System.IO.FileMode mode) : base(default(Microsoft.Win32.SafeHandles.SafeFileHandle), default(System.IO.FileAccess)) => throw null;
                public IsolatedStorageFileStream(string path, System.IO.FileMode mode, System.IO.FileAccess access) : base(default(Microsoft.Win32.SafeHandles.SafeFileHandle), default(System.IO.FileAccess)) => throw null;
                public IsolatedStorageFileStream(string path, System.IO.FileMode mode, System.IO.FileAccess access, System.IO.FileShare share) : base(default(Microsoft.Win32.SafeHandles.SafeFileHandle), default(System.IO.FileAccess)) => throw null;
                public IsolatedStorageFileStream(string path, System.IO.FileMode mode, System.IO.FileAccess access, System.IO.FileShare share, System.IO.IsolatedStorage.IsolatedStorageFile isf) : base(default(Microsoft.Win32.SafeHandles.SafeFileHandle), default(System.IO.FileAccess)) => throw null;
                public IsolatedStorageFileStream(string path, System.IO.FileMode mode, System.IO.FileAccess access, System.IO.FileShare share, int bufferSize) : base(default(Microsoft.Win32.SafeHandles.SafeFileHandle), default(System.IO.FileAccess)) => throw null;
                public IsolatedStorageFileStream(string path, System.IO.FileMode mode, System.IO.FileAccess access, System.IO.FileShare share, int bufferSize, System.IO.IsolatedStorage.IsolatedStorageFile isf) : base(default(Microsoft.Win32.SafeHandles.SafeFileHandle), default(System.IO.FileAccess)) => throw null;
                public IsolatedStorageFileStream(string path, System.IO.FileMode mode, System.IO.FileAccess access, System.IO.IsolatedStorage.IsolatedStorageFile isf) : base(default(Microsoft.Win32.SafeHandles.SafeFileHandle), default(System.IO.FileAccess)) => throw null;
                public IsolatedStorageFileStream(string path, System.IO.FileMode mode, System.IO.IsolatedStorage.IsolatedStorageFile isf) : base(default(Microsoft.Win32.SafeHandles.SafeFileHandle), default(System.IO.FileAccess)) => throw null;
                public override System.Int64 Length { get => throw null; }
                public override void Lock(System.Int64 position, System.Int64 length) => throw null;
                public override System.Int64 Position { get => throw null; set => throw null; }
                public override int Read(System.Byte[] buffer, int offset, int count) => throw null;
                public override int Read(System.Span<System.Byte> buffer) => throw null;
                public override System.Threading.Tasks.Task<int> ReadAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override int ReadByte() => throw null;
                public override Microsoft.Win32.SafeHandles.SafeFileHandle SafeFileHandle { get => throw null; }
                public override System.Int64 Seek(System.Int64 offset, System.IO.SeekOrigin origin) => throw null;
                public override void SetLength(System.Int64 value) => throw null;
                public override void Unlock(System.Int64 position, System.Int64 length) => throw null;
                public override void Write(System.Byte[] buffer, int offset, int count) => throw null;
                public override void Write(System.ReadOnlySpan<System.Byte> buffer) => throw null;
                public override System.Threading.Tasks.Task WriteAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                public override System.Threading.Tasks.ValueTask WriteAsync(System.ReadOnlyMemory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public override void WriteByte(System.Byte value) => throw null;
            }

            // Generated from `System.IO.IsolatedStorage.IsolatedStorageScope` in `System.IO.IsolatedStorage, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum IsolatedStorageScope
            {
                Application,
                Assembly,
                Domain,
                Machine,
                None,
                Roaming,
                User,
            }

        }
    }
}
