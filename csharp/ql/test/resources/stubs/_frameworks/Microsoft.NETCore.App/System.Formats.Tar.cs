// This file contains auto-generated code.
// Generated from `System.Formats.Tar, Version=7.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.

namespace System
{
    namespace Formats
    {
        namespace Tar
        {
            public class GnuTarEntry : System.Formats.Tar.PosixTarEntry
            {
                public System.DateTimeOffset AccessTime { get => throw null; set => throw null; }
                public System.DateTimeOffset ChangeTime { get => throw null; set => throw null; }
                public GnuTarEntry(System.Formats.Tar.TarEntry other) => throw null;
                public GnuTarEntry(System.Formats.Tar.TarEntryType entryType, string entryName) => throw null;
            }

            public class PaxGlobalExtendedAttributesTarEntry : System.Formats.Tar.PosixTarEntry
            {
                public System.Collections.Generic.IReadOnlyDictionary<string, string> GlobalExtendedAttributes { get => throw null; }
                public PaxGlobalExtendedAttributesTarEntry(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> globalExtendedAttributes) => throw null;
            }

            public class PaxTarEntry : System.Formats.Tar.PosixTarEntry
            {
                public System.Collections.Generic.IReadOnlyDictionary<string, string> ExtendedAttributes { get => throw null; }
                public PaxTarEntry(System.Formats.Tar.TarEntry other) => throw null;
                public PaxTarEntry(System.Formats.Tar.TarEntryType entryType, string entryName) => throw null;
                public PaxTarEntry(System.Formats.Tar.TarEntryType entryType, string entryName, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> extendedAttributes) => throw null;
            }

            public abstract class PosixTarEntry : System.Formats.Tar.TarEntry
            {
                public int DeviceMajor { get => throw null; set => throw null; }
                public int DeviceMinor { get => throw null; set => throw null; }
                public string GroupName { get => throw null; set => throw null; }
                internal PosixTarEntry() => throw null;
                public string UserName { get => throw null; set => throw null; }
            }

            public abstract class TarEntry
            {
                public int Checksum { get => throw null; }
                public System.IO.Stream DataStream { get => throw null; set => throw null; }
                public System.Formats.Tar.TarEntryType EntryType { get => throw null; }
                public void ExtractToFile(string destinationFileName, bool overwrite) => throw null;
                public System.Threading.Tasks.Task ExtractToFileAsync(string destinationFileName, bool overwrite, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Formats.Tar.TarEntryFormat Format { get => throw null; }
                public int Gid { get => throw null; set => throw null; }
                public System.Int64 Length { get => throw null; }
                public string LinkName { get => throw null; set => throw null; }
                public System.IO.UnixFileMode Mode { get => throw null; set => throw null; }
                public System.DateTimeOffset ModificationTime { get => throw null; set => throw null; }
                public string Name { get => throw null; set => throw null; }
                internal TarEntry() => throw null;
                public override string ToString() => throw null;
                public int Uid { get => throw null; set => throw null; }
            }

            public enum TarEntryFormat : int
            {
                Gnu = 4,
                Pax = 3,
                Unknown = 0,
                Ustar = 2,
                V7 = 1,
            }

            public enum TarEntryType : byte
            {
                BlockDevice = 52,
                CharacterDevice = 51,
                ContiguousFile = 55,
                Directory = 53,
                DirectoryList = 68,
                ExtendedAttributes = 120,
                Fifo = 54,
                GlobalExtendedAttributes = 103,
                HardLink = 49,
                LongLink = 75,
                LongPath = 76,
                MultiVolume = 77,
                RegularFile = 48,
                RenamedOrSymlinked = 78,
                SparseFile = 83,
                SymbolicLink = 50,
                TapeVolume = 86,
                V7RegularFile = 0,
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

            public class TarReader : System.IAsyncDisposable, System.IDisposable
            {
                public void Dispose() => throw null;
                public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public System.Formats.Tar.TarEntry GetNextEntry(bool copyData = default(bool)) => throw null;
                public System.Threading.Tasks.ValueTask<System.Formats.Tar.TarEntry> GetNextEntryAsync(bool copyData = default(bool), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public TarReader(System.IO.Stream archiveStream, bool leaveOpen = default(bool)) => throw null;
            }

            public class TarWriter : System.IAsyncDisposable, System.IDisposable
            {
                public void Dispose() => throw null;
                public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                public System.Formats.Tar.TarEntryFormat Format { get => throw null; }
                public TarWriter(System.IO.Stream archiveStream) => throw null;
                public TarWriter(System.IO.Stream archiveStream, System.Formats.Tar.TarEntryFormat format = default(System.Formats.Tar.TarEntryFormat), bool leaveOpen = default(bool)) => throw null;
                public TarWriter(System.IO.Stream archiveStream, bool leaveOpen = default(bool)) => throw null;
                public void WriteEntry(System.Formats.Tar.TarEntry entry) => throw null;
                public void WriteEntry(string fileName, string entryName) => throw null;
                public System.Threading.Tasks.Task WriteEntryAsync(System.Formats.Tar.TarEntry entry, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.Task WriteEntryAsync(string fileName, string entryName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }

            public class UstarTarEntry : System.Formats.Tar.PosixTarEntry
            {
                public UstarTarEntry(System.Formats.Tar.TarEntry other) => throw null;
                public UstarTarEntry(System.Formats.Tar.TarEntryType entryType, string entryName) => throw null;
            }

            public class V7TarEntry : System.Formats.Tar.TarEntry
            {
                public V7TarEntry(System.Formats.Tar.TarEntry other) => throw null;
                public V7TarEntry(System.Formats.Tar.TarEntryType entryType, string entryName) => throw null;
            }

        }
    }
}
