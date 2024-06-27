// This file contains auto-generated code.
// Generated from `System.IO.FileSystem.DriveInfo, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace IO
    {
        public sealed class DriveInfo : System.Runtime.Serialization.ISerializable
        {
            public long AvailableFreeSpace { get => throw null; }
            public DriveInfo(string driveName) => throw null;
            public string DriveFormat { get => throw null; }
            public System.IO.DriveType DriveType { get => throw null; }
            public static System.IO.DriveInfo[] GetDrives() => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public bool IsReady { get => throw null; }
            public string Name { get => throw null; }
            public System.IO.DirectoryInfo RootDirectory { get => throw null; }
            public override string ToString() => throw null;
            public long TotalFreeSpace { get => throw null; }
            public long TotalSize { get => throw null; }
            public string VolumeLabel { get => throw null; set { } }
        }
        public class DriveNotFoundException : System.IO.IOException
        {
            public DriveNotFoundException() => throw null;
            protected DriveNotFoundException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public DriveNotFoundException(string message) => throw null;
            public DriveNotFoundException(string message, System.Exception innerException) => throw null;
        }
        public enum DriveType
        {
            Unknown = 0,
            NoRootDirectory = 1,
            Removable = 2,
            Fixed = 3,
            Network = 4,
            CDRom = 5,
            Ram = 6,
        }
    }
}
