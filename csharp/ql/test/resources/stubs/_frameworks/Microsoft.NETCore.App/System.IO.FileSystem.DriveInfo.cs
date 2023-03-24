// This file contains auto-generated code.
// Generated from `System.IO.FileSystem.DriveInfo, Version=7.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.

namespace System
{
    namespace IO
    {
        public class DriveInfo : System.Runtime.Serialization.ISerializable
        {
            public System.Int64 AvailableFreeSpace { get => throw null; }
            public string DriveFormat { get => throw null; }
            public DriveInfo(string driveName) => throw null;
            public System.IO.DriveType DriveType { get => throw null; }
            public static System.IO.DriveInfo[] GetDrives() => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public bool IsReady { get => throw null; }
            public string Name { get => throw null; }
            public System.IO.DirectoryInfo RootDirectory { get => throw null; }
            public override string ToString() => throw null;
            public System.Int64 TotalFreeSpace { get => throw null; }
            public System.Int64 TotalSize { get => throw null; }
            public string VolumeLabel { get => throw null; set => throw null; }
        }

        public class DriveNotFoundException : System.IO.IOException
        {
            public DriveNotFoundException() => throw null;
            protected DriveNotFoundException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public DriveNotFoundException(string message) => throw null;
            public DriveNotFoundException(string message, System.Exception innerException) => throw null;
        }

        public enum DriveType : int
        {
            CDRom = 5,
            Fixed = 3,
            Network = 4,
            NoRootDirectory = 1,
            Ram = 6,
            Removable = 2,
            Unknown = 0,
        }

    }
}
