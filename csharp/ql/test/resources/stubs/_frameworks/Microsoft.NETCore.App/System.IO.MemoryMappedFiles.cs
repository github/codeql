// This file contains auto-generated code.

namespace Microsoft
{
    namespace Win32
    {
        namespace SafeHandles
        {
            // Generated from `Microsoft.Win32.SafeHandles.SafeMemoryMappedFileHandle` in `System.IO.MemoryMappedFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SafeMemoryMappedFileHandle : Microsoft.Win32.SafeHandles.SafeHandleZeroOrMinusOneIsInvalid
            {
                public override bool IsInvalid { get => throw null; }
                protected override bool ReleaseHandle() => throw null;
                internal SafeMemoryMappedFileHandle() : base(default(bool)) => throw null;
            }

            // Generated from `Microsoft.Win32.SafeHandles.SafeMemoryMappedViewHandle` in `System.IO.MemoryMappedFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SafeMemoryMappedViewHandle : System.Runtime.InteropServices.SafeBuffer
            {
                protected override bool ReleaseHandle() => throw null;
                internal SafeMemoryMappedViewHandle() : base(default(bool)) => throw null;
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
            // Generated from `System.IO.MemoryMappedFiles.MemoryMappedFile` in `System.IO.MemoryMappedFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.IO.MemoryMappedFiles.MemoryMappedFileAccess` in `System.IO.MemoryMappedFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum MemoryMappedFileAccess
            {
                CopyOnWrite,
                Read,
                ReadExecute,
                ReadWrite,
                ReadWriteExecute,
                Write,
            }

            // Generated from `System.IO.MemoryMappedFiles.MemoryMappedFileOptions` in `System.IO.MemoryMappedFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum MemoryMappedFileOptions
            {
                DelayAllocatePages,
                None,
            }

            // Generated from `System.IO.MemoryMappedFiles.MemoryMappedFileRights` in `System.IO.MemoryMappedFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum MemoryMappedFileRights
            {
                AccessSystemSecurity,
                ChangePermissions,
                CopyOnWrite,
                Delete,
                Execute,
                FullControl,
                Read,
                ReadExecute,
                ReadPermissions,
                ReadWrite,
                ReadWriteExecute,
                TakeOwnership,
                Write,
            }

            // Generated from `System.IO.MemoryMappedFiles.MemoryMappedViewAccessor` in `System.IO.MemoryMappedFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class MemoryMappedViewAccessor : System.IO.UnmanagedMemoryAccessor
            {
                protected override void Dispose(bool disposing) => throw null;
                public void Flush() => throw null;
                public System.Int64 PointerOffset { get => throw null; }
                public Microsoft.Win32.SafeHandles.SafeMemoryMappedViewHandle SafeMemoryMappedViewHandle { get => throw null; }
            }

            // Generated from `System.IO.MemoryMappedFiles.MemoryMappedViewStream` in `System.IO.MemoryMappedFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
