// This file contains auto-generated code.
// Generated from `System.IO.MemoryMappedFiles, Version=7.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.

namespace Microsoft
{
    namespace Win32
    {
        namespace SafeHandles
        {
            public class SafeMemoryMappedFileHandle : Microsoft.Win32.SafeHandles.SafeHandleZeroOrMinusOneIsInvalid
            {
                public override bool IsInvalid { get => throw null; }
                protected override bool ReleaseHandle() => throw null;
                public SafeMemoryMappedFileHandle() : base(default(bool)) => throw null;
            }

            public class SafeMemoryMappedViewHandle : System.Runtime.InteropServices.SafeBuffer
            {
                protected override bool ReleaseHandle() => throw null;
                public SafeMemoryMappedViewHandle() : base(default(bool)) => throw null;
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
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateFromFile(System.IO.FileStream fileStream, string mapName, System.Int64 capacity, System.IO.MemoryMappedFiles.MemoryMappedFileAccess access, System.IO.HandleInheritability inheritability, bool leaveOpen) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateFromFile(string path) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateFromFile(string path, System.IO.FileMode mode) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateFromFile(string path, System.IO.FileMode mode, string mapName) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateFromFile(string path, System.IO.FileMode mode, string mapName, System.Int64 capacity) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateFromFile(string path, System.IO.FileMode mode, string mapName, System.Int64 capacity, System.IO.MemoryMappedFiles.MemoryMappedFileAccess access) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateNew(string mapName, System.Int64 capacity) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateNew(string mapName, System.Int64 capacity, System.IO.MemoryMappedFiles.MemoryMappedFileAccess access) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateNew(string mapName, System.Int64 capacity, System.IO.MemoryMappedFiles.MemoryMappedFileAccess access, System.IO.MemoryMappedFiles.MemoryMappedFileOptions options, System.IO.HandleInheritability inheritability) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateOrOpen(string mapName, System.Int64 capacity) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateOrOpen(string mapName, System.Int64 capacity, System.IO.MemoryMappedFiles.MemoryMappedFileAccess access) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile CreateOrOpen(string mapName, System.Int64 capacity, System.IO.MemoryMappedFiles.MemoryMappedFileAccess access, System.IO.MemoryMappedFiles.MemoryMappedFileOptions options, System.IO.HandleInheritability inheritability) => throw null;
                public System.IO.MemoryMappedFiles.MemoryMappedViewAccessor CreateViewAccessor() => throw null;
                public System.IO.MemoryMappedFiles.MemoryMappedViewAccessor CreateViewAccessor(System.Int64 offset, System.Int64 size) => throw null;
                public System.IO.MemoryMappedFiles.MemoryMappedViewAccessor CreateViewAccessor(System.Int64 offset, System.Int64 size, System.IO.MemoryMappedFiles.MemoryMappedFileAccess access) => throw null;
                public System.IO.MemoryMappedFiles.MemoryMappedViewStream CreateViewStream() => throw null;
                public System.IO.MemoryMappedFiles.MemoryMappedViewStream CreateViewStream(System.Int64 offset, System.Int64 size) => throw null;
                public System.IO.MemoryMappedFiles.MemoryMappedViewStream CreateViewStream(System.Int64 offset, System.Int64 size, System.IO.MemoryMappedFiles.MemoryMappedFileAccess access) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile OpenExisting(string mapName) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile OpenExisting(string mapName, System.IO.MemoryMappedFiles.MemoryMappedFileRights desiredAccessRights) => throw null;
                public static System.IO.MemoryMappedFiles.MemoryMappedFile OpenExisting(string mapName, System.IO.MemoryMappedFiles.MemoryMappedFileRights desiredAccessRights, System.IO.HandleInheritability inheritability) => throw null;
                public Microsoft.Win32.SafeHandles.SafeMemoryMappedFileHandle SafeMemoryMappedFileHandle { get => throw null; }
            }

            public enum MemoryMappedFileAccess : int
            {
                CopyOnWrite = 3,
                Read = 1,
                ReadExecute = 4,
                ReadWrite = 0,
                ReadWriteExecute = 5,
                Write = 2,
            }

            [System.Flags]
            public enum MemoryMappedFileOptions : int
            {
                DelayAllocatePages = 67108864,
                None = 0,
            }

            [System.Flags]
            public enum MemoryMappedFileRights : int
            {
                AccessSystemSecurity = 16777216,
                ChangePermissions = 262144,
                CopyOnWrite = 1,
                Delete = 65536,
                Execute = 8,
                FullControl = 983055,
                Read = 4,
                ReadExecute = 12,
                ReadPermissions = 131072,
                ReadWrite = 6,
                ReadWriteExecute = 14,
                TakeOwnership = 524288,
                Write = 2,
            }

            public class MemoryMappedViewAccessor : System.IO.UnmanagedMemoryAccessor
            {
                protected override void Dispose(bool disposing) => throw null;
                public void Flush() => throw null;
                public System.Int64 PointerOffset { get => throw null; }
                public Microsoft.Win32.SafeHandles.SafeMemoryMappedViewHandle SafeMemoryMappedViewHandle { get => throw null; }
            }

            public class MemoryMappedViewStream : System.IO.UnmanagedMemoryStream
            {
                protected override void Dispose(bool disposing) => throw null;
                public override void Flush() => throw null;
                public System.Int64 PointerOffset { get => throw null; }
                public Microsoft.Win32.SafeHandles.SafeMemoryMappedViewHandle SafeMemoryMappedViewHandle { get => throw null; }
                public override void SetLength(System.Int64 value) => throw null;
            }

        }
    }
}
