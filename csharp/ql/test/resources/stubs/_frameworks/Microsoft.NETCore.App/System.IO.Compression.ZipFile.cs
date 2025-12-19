// This file contains auto-generated code.
// Generated from `System.IO.Compression.ZipFile, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089`.
namespace System
{
    namespace IO
    {
        namespace Compression
        {
            public static class ZipFile
            {
                public static void CreateFromDirectory(string sourceDirectoryName, System.IO.Stream destination) => throw null;
                public static void CreateFromDirectory(string sourceDirectoryName, System.IO.Stream destination, System.IO.Compression.CompressionLevel compressionLevel, bool includeBaseDirectory) => throw null;
                public static void CreateFromDirectory(string sourceDirectoryName, System.IO.Stream destination, System.IO.Compression.CompressionLevel compressionLevel, bool includeBaseDirectory, System.Text.Encoding entryNameEncoding) => throw null;
                public static void CreateFromDirectory(string sourceDirectoryName, string destinationArchiveFileName) => throw null;
                public static void CreateFromDirectory(string sourceDirectoryName, string destinationArchiveFileName, System.IO.Compression.CompressionLevel compressionLevel, bool includeBaseDirectory) => throw null;
                public static void CreateFromDirectory(string sourceDirectoryName, string destinationArchiveFileName, System.IO.Compression.CompressionLevel compressionLevel, bool includeBaseDirectory, System.Text.Encoding entryNameEncoding) => throw null;
                public static System.Threading.Tasks.Task CreateFromDirectoryAsync(string sourceDirectoryName, System.IO.Stream destination, System.IO.Compression.CompressionLevel compressionLevel, bool includeBaseDirectory, System.Text.Encoding entryNameEncoding, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task CreateFromDirectoryAsync(string sourceDirectoryName, System.IO.Stream destination, System.IO.Compression.CompressionLevel compressionLevel, bool includeBaseDirectory, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task CreateFromDirectoryAsync(string sourceDirectoryName, System.IO.Stream destination, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task CreateFromDirectoryAsync(string sourceDirectoryName, string destinationArchiveFileName, System.IO.Compression.CompressionLevel compressionLevel, bool includeBaseDirectory, System.Text.Encoding entryNameEncoding, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task CreateFromDirectoryAsync(string sourceDirectoryName, string destinationArchiveFileName, System.IO.Compression.CompressionLevel compressionLevel, bool includeBaseDirectory, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task CreateFromDirectoryAsync(string sourceDirectoryName, string destinationArchiveFileName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static void ExtractToDirectory(System.IO.Stream source, string destinationDirectoryName) => throw null;
                public static void ExtractToDirectory(System.IO.Stream source, string destinationDirectoryName, bool overwriteFiles) => throw null;
                public static void ExtractToDirectory(System.IO.Stream source, string destinationDirectoryName, System.Text.Encoding entryNameEncoding) => throw null;
                public static void ExtractToDirectory(System.IO.Stream source, string destinationDirectoryName, System.Text.Encoding entryNameEncoding, bool overwriteFiles) => throw null;
                public static void ExtractToDirectory(string sourceArchiveFileName, string destinationDirectoryName) => throw null;
                public static void ExtractToDirectory(string sourceArchiveFileName, string destinationDirectoryName, bool overwriteFiles) => throw null;
                public static void ExtractToDirectory(string sourceArchiveFileName, string destinationDirectoryName, System.Text.Encoding entryNameEncoding) => throw null;
                public static void ExtractToDirectory(string sourceArchiveFileName, string destinationDirectoryName, System.Text.Encoding entryNameEncoding, bool overwriteFiles) => throw null;
                public static System.Threading.Tasks.Task ExtractToDirectoryAsync(System.IO.Stream source, string destinationDirectoryName, bool overwriteFiles, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task ExtractToDirectoryAsync(System.IO.Stream source, string destinationDirectoryName, System.Text.Encoding entryNameEncoding, bool overwriteFiles, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task ExtractToDirectoryAsync(System.IO.Stream source, string destinationDirectoryName, System.Text.Encoding entryNameEncoding, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task ExtractToDirectoryAsync(System.IO.Stream source, string destinationDirectoryName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task ExtractToDirectoryAsync(string sourceArchiveFileName, string destinationDirectoryName, bool overwriteFiles, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task ExtractToDirectoryAsync(string sourceArchiveFileName, string destinationDirectoryName, System.Text.Encoding entryNameEncoding, bool overwriteFiles, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task ExtractToDirectoryAsync(string sourceArchiveFileName, string destinationDirectoryName, System.Text.Encoding entryNameEncoding, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task ExtractToDirectoryAsync(string sourceArchiveFileName, string destinationDirectoryName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.IO.Compression.ZipArchive Open(string archiveFileName, System.IO.Compression.ZipArchiveMode mode) => throw null;
                public static System.IO.Compression.ZipArchive Open(string archiveFileName, System.IO.Compression.ZipArchiveMode mode, System.Text.Encoding entryNameEncoding) => throw null;
                public static System.Threading.Tasks.Task<System.IO.Compression.ZipArchive> OpenAsync(string archiveFileName, System.IO.Compression.ZipArchiveMode mode, System.Text.Encoding entryNameEncoding, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<System.IO.Compression.ZipArchive> OpenAsync(string archiveFileName, System.IO.Compression.ZipArchiveMode mode, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.IO.Compression.ZipArchive OpenRead(string archiveFileName) => throw null;
                public static System.Threading.Tasks.Task<System.IO.Compression.ZipArchive> OpenReadAsync(string archiveFileName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }
            public static partial class ZipFileExtensions
            {
                public static System.IO.Compression.ZipArchiveEntry CreateEntryFromFile(this System.IO.Compression.ZipArchive destination, string sourceFileName, string entryName) => throw null;
                public static System.IO.Compression.ZipArchiveEntry CreateEntryFromFile(this System.IO.Compression.ZipArchive destination, string sourceFileName, string entryName, System.IO.Compression.CompressionLevel compressionLevel) => throw null;
                public static System.Threading.Tasks.Task<System.IO.Compression.ZipArchiveEntry> CreateEntryFromFileAsync(this System.IO.Compression.ZipArchive destination, string sourceFileName, string entryName, System.IO.Compression.CompressionLevel compressionLevel, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<System.IO.Compression.ZipArchiveEntry> CreateEntryFromFileAsync(this System.IO.Compression.ZipArchive destination, string sourceFileName, string entryName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static void ExtractToDirectory(this System.IO.Compression.ZipArchive source, string destinationDirectoryName) => throw null;
                public static void ExtractToDirectory(this System.IO.Compression.ZipArchive source, string destinationDirectoryName, bool overwriteFiles) => throw null;
                public static System.Threading.Tasks.Task ExtractToDirectoryAsync(this System.IO.Compression.ZipArchive source, string destinationDirectoryName, bool overwriteFiles, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task ExtractToDirectoryAsync(this System.IO.Compression.ZipArchive source, string destinationDirectoryName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static void ExtractToFile(this System.IO.Compression.ZipArchiveEntry source, string destinationFileName) => throw null;
                public static void ExtractToFile(this System.IO.Compression.ZipArchiveEntry source, string destinationFileName, bool overwrite) => throw null;
                public static System.Threading.Tasks.Task ExtractToFileAsync(this System.IO.Compression.ZipArchiveEntry source, string destinationFileName, bool overwrite, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task ExtractToFileAsync(this System.IO.Compression.ZipArchiveEntry source, string destinationFileName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }
        }
    }
}
