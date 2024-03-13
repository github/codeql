// This file contains auto-generated code.
// Generated from `System.Formats.Tar, Version=8.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.
namespace System
{
    namespace Formats
    {
        namespace Tar
        {
            public sealed class GnuTarEntry : System.Formats.Tar.PosixTarEntry
            {
                public System.DateTimeOffset AccessTime { get => throw null; set { } }
                public System.DateTimeOffset ChangeTime { get => throw null; set { } }
                public GnuTarEntry(System.Formats.Tar.TarEntry other) => throw null;
                public GnuTarEntry(System.Formats.Tar.TarEntryType entryType, string entryName) => throw null;
            }
            public sealed class PaxGlobalExtendedAttributesTarEntry : System.Formats.Tar.PosixTarEntry
            {
                public PaxGlobalExtendedAttributesTarEntry(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> globalExtendedAttributes) => throw null;
                public System.Collections.Generic.IReadOnlyDictionary<string, string> GlobalExtendedAttributes { get => throw null; }
            }
            public sealed class PaxTarEntry : System.Formats.Tar.PosixTarEntry
            {
                public PaxTarEntry(System.Formats.Tar.TarEntry other) => throw null;
                public PaxTarEntry(System.Formats.Tar.TarEntryType entryType, string entryName) => throw null;
                public PaxTarEntry(System.Formats.Tar.TarEntryType entryType, string entryName, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> extendedAttributes) => throw null;
                public System.Collections.Generic.IReadOnlyDictionary<string, string> ExtendedAttributes { get => throw null; }
            }
            public abstract class PosixTarEntry : System.Formats.Tar.TarEntry
            {
                public int DeviceMajor { get => throw null; set { } }
                public int DeviceMinor { get => throw null; set { } }
                public string GroupName { get => throw null; set { } }
                public string UserName { get => throw null; set { } }
            }
            public abstract class TarEntry
            {
                public int Checksum { get => throw null; }
                public System.IO.Stream DataStream { get => throw null; set { } }
                public System.Formats.Tar.TarEntryType EntryType { get => throw null; }
                public void ExtractToFile(string destinationFileName, bool overwrite) => throw null;
                public System.Threading.Tasks.Task ExtractToFileAsync(string destinationFileName, bool overwrite, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Formats.Tar.TarEntryFormat Format { get => throw null; }
                public int Gid { get => throw null; set { } }
                public long Length { get => throw null; }
                public string LinkName { get => throw null; set { } }
                public System.IO.UnixFileMode Mode { get => throw null; set { } }
                public System.DateTimeOffset ModificationTime { get => throw null; set { } }
                public string Name { get => throw null; set { } }
                public override string ToString() => throw null;
                public int Uid { get => throw null; set { } }
            }
            public enum TarEntryFormat
            {
                Unknown = 0,
                V7 = 1,
                Ustar = 2,
                Pax = 3,
                Gnu = 4,
            }
            public enum TarEntryType : byte
            {
                V7RegularFile = 0,
                RegularFile = 48,
                HardLink = 49,
                SymbolicLink = 50,
                CharacterDevice = 51,
                BlockDevice = 52,
                Directory = 53,
                Fifo = 54,
                ContiguousFile = 55,
                DirectoryList = 68,
                LongLink = 75,
                LongPath = 76,
                MultiVolume = 77,
                RenamedOrSymlinked = 78,
                SparseFile = 83,
                TapeVolume = 86,
                GlobalExtendedAttributes = 103,
                ExtendedAttributes = 120,
            }
            public static class TarFile
            {
                public static void CreateFromDirectory(string sourceDirectoryName, System.IO.Stream destination, bool includeBaseDirectory) => throw null;
                public static void CreateFromDirectory(string sourceDirectoryName, string destinationFileName, bool includeBaseDirectory) => throw null;
                public static System.Threading.Tasks.Task CreateFromDirectoryAsync(string sourceDirectoryName, System.IO.Stream destination, bool includeBaseDirectory, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task CreateFromDirectoryAsync(string sourceDirectoryName, string destinationFileName, bool includeBaseDirectory, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static void ExtractToDirectory(System.IO.Stream source, string destinationDirectoryName, bool overwriteFiles) => throw null;
                public static void ExtractToDirectory(string sourceFileName, string destinationDirectoryName, bool overwriteFiles) => throw null;
                public static System.Threading.Tasks.Task ExtractToDirectoryAsync(System.IO.Stream source, string destinationDirectoryName, bool overwriteFiles, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task ExtractToDirectoryAsync(string sourceFileName, string destinationDirectoryName, bool overwriteFiles, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }
            public sealed class TarReader : System.IAsyncDisposable, System.IDisposable
            {
                public TarReader(System.IO.Stream archiveStream, bool leaveOpen = default(bool)) => throw null;
                public void Dispose() => throw null;
                public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public System.Formats.Tar.TarEntry GetNextEntry(bool copyData = default(bool)) => throw null;
                public System.Threading.Tasks.ValueTask<System.Formats.Tar.TarEntry> GetNextEntryAsync(bool copyData = default(bool), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }
            public sealed class TarWriter : System.IAsyncDisposable, System.IDisposable
            {
                public TarWriter(System.IO.Stream archiveStream) => throw null;
                public TarWriter(System.IO.Stream archiveStream, bool leaveOpen = default(bool)) => throw null;
                public TarWriter(System.IO.Stream archiveStream, System.Formats.Tar.TarEntryFormat format = default(System.Formats.Tar.TarEntryFormat), bool leaveOpen = default(bool)) => throw null;
                public void Dispose() => throw null;
                public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public System.Formats.Tar.TarEntryFormat Format { get => throw null; }
                public void WriteEntry(System.Formats.Tar.TarEntry entry) => throw null;
                public void WriteEntry(string fileName, string entryName) => throw null;
                public System.Threading.Tasks.Task WriteEntryAsync(System.Formats.Tar.TarEntry entry, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.Task WriteEntryAsync(string fileName, string entryName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }
            public sealed class UstarTarEntry : System.Formats.Tar.PosixTarEntry
            {
                public UstarTarEntry(System.Formats.Tar.TarEntry other) => throw null;
                public UstarTarEntry(System.Formats.Tar.TarEntryType entryType, string entryName) => throw null;
            }
            public sealed class V7TarEntry : System.Formats.Tar.TarEntry
            {
                public V7TarEntry(System.Formats.Tar.TarEntry other) => throw null;
                public V7TarEntry(System.Formats.Tar.TarEntryType entryType, string entryName) => throw null;
            }
        }
    }
}
