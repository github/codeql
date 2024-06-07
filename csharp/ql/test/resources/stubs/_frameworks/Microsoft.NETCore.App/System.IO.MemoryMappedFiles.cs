// This file contains auto-generated code.
// Generated from `System.IO.MemoryMappedFiles, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace Microsoft
{
    namespace Win32
    {
        namespace SafeHandles
        {
            public sealed class SafeMemoryMappedFileHandle : Microsoft.Win32.SafeHandles.SafeHandleZeroOrMinusOneIsInvalid
            {
                public SafeMemoryMappedFileHandle() : base(default(bool)) => throw null;
                public override bool IsInvalid { get => throw null; }
                protected override bool ReleaseHandle() => throw null;
            }
            public sealed class SafeMemoryMappedViewHandle : System.Runtime.InteropServices.SafeBuffer
            {
                public SafeMemoryMappedViewHandle() : base(default(bool)) => throw null;
                protected override bool ReleaseHandle() => throw null;
            }
        }
    }
}
namespace System
{
    namespace IO
    {
        namespace MemoryMappedFiles
        {
            public class MemoryMappedFile : System.IDisposable
            {
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateFromFile(System.IO.FileStream fileStream, string mapName, long capacity, System.IO.MemoryMappedFiles.MemoryMappedFileAccess access, System.IO.HandleInheritability inheritability, bool leaveOpen) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateFromFile(Microsoft.Win32.SafeHandles.SafeFileHandle fileHandle, string mapName, long capacity, System.IO.MemoryMappedFiles.MemoryMappedFileAccess access, System.IO.HandleInheritability inheritability, bool leaveOpen) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateFromFile(string path) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateFromFile(string path, System.IO.FileMode mode) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateFromFile(string path, System.IO.FileMode mode, string mapName) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateFromFile(string path, System.IO.FileMode mode, string mapName, long capacity) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateFromFile(string path, System.IO.FileMode mode, string mapName, long capacity, System.IO.MemoryMappedFiles.MemoryMappedFileAccess access) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateNew(string mapName, long capacity) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateNew(string mapName, long capacity, System.IO.MemoryMappedFiles.MemoryMappedFileAccess access) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateNew(string mapName, long capacity, System.IO.MemoryMappedFiles.MemoryMappedFileAccess access, System.IO.MemoryMappedFiles.MemoryMappedFileOptions options, System.IO.HandleInheritability inheritability) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateOrOpen(string mapName, long capacity) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateOrOpen(string mapName, long capacity, System.IO.MemoryMappedFiles.MemoryMappedFileAccess access) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateOrOpen(string mapName, long capacity, System.IO.MemoryMappedFiles.MemoryMappedFileAccess access, System.IO.MemoryMappedFiles.MemoryMappedFileOptions options, System.IO.HandleInheritability inheritability) => throw null;
                public System.IO.MemoryMappedFiles.MemoryMappedViewAccessor CreateViewAccessor() => throw null;
                public System.IO.MemoryMappedFiles.MemoryMappedViewAccessor CreateViewAccessor(long offset, long size) => throw null;
                public System.IO.MemoryMappedFiles.MemoryMappedViewAccessor CreateViewAccessor(long offset, long size, System.IO.MemoryMappedFiles.MemoryMappedFileAccess access) => throw null;
                public System.IO.MemoryMappedFiles.MemoryMappedViewStream CreateViewStream() => throw null;
                public System.IO.MemoryMappedFiles.MemoryMappedViewStream CreateViewStream(long offset, long size) => throw null;
                public System.IO.MemoryMappedFiles.MemoryMappedViewStream CreateViewStream(long offset, long size, System.IO.MemoryMappedFiles.MemoryMappedFileAccess access) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile OpenExisting(string mapName) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile OpenExisting(string mapName, System.IO.MemoryMappedFiles.MemoryMappedFileRights desiredAccessRights) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile OpenExisting(string mapName, System.IO.MemoryMappedFiles.MemoryMappedFileRights desiredAccessRights, System.IO.HandleInheritability inheritability) => throw null;
                public Microsoft.Win32.SafeHandles.SafeMemoryMappedFileHandle SafeMemoryMappedFileHandle { get => throw null; }
            }
            public enum MemoryMappedFileAccess
            {
                ReadWrite = 0,
                Read = 1,
                Write = 2,
                CopyOnWrite = 3,
                ReadExecute = 4,
                ReadWriteExecute = 5,
            }
            [System.Flags]
            public enum MemoryMappedFileOptions
            {
                None = 0,
                DelayAllocatePages = 67108864,
            }
            [System.Flags]
            public enum MemoryMappedFileRights
            {
                CopyOnWrite = 1,
                Write = 2,
                Read = 4,
                ReadWrite = 6,
                Execute = 8,
                ReadExecute = 12,
                ReadWriteExecute = 14,
                Delete = 65536,
                ReadPermissions = 131072,
                ChangePermissions = 262144,
                TakeOwnership = 524288,
                FullControl = 983055,
                AccessSystemSecurity = 16777216,
            }
            public sealed class MemoryMappedViewAccessor : System.IO.UnmanagedMemoryAccessor
            {
                protected override void Dispose(bool disposing) => throw null;
                public void Flush() => throw null;
                public long PointerOffset { get => throw null; }
                public Microsoft.Win32.SafeHandles.SafeMemoryMappedViewHandle SafeMemoryMappedViewHandle { get => throw null; }
            }
            public sealed class MemoryMappedViewStream : System.IO.UnmanagedMemoryStream
            {
                protected override void Dispose(bool disposing) => throw null;
                public override void Flush() => throw null;
                public long PointerOffset { get => throw null; }
                public Microsoft.Win32.SafeHandles.SafeMemoryMappedViewHandle SafeMemoryMappedViewHandle { get => throw null; }
                public override void SetLength(long value) => throw null;
            }
        }
    }
}
