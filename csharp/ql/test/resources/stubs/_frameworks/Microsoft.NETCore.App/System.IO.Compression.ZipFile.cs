// This file contains auto-generated code.

namespace System
{
    namespace IO
    {
        namespace Compression
        {
            // Generated from `System.IO.Compression.ZipFile` in `System.IO.Compression.ZipFile, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089`
            public static class ZipFile
            {
                public static void CreateFromDirectory(string sourceDirectoryName, string destinationArchiveFileName) => throw null;
                public static void CreateFromDirectory(string sourceDirectoryName, string destinationArchiveFileName, System.IO.Compression.CompressionLevel compressionLevel, bool includeBaseDirectory) => throw null;
                public static void CreateFromDirectory(string sourceDirectoryName, string destinationArchiveFileName, System.IO.Compression.CompressionLevel compressionLevel, bool includeBaseDirectory, System.Text.Encoding entryNameEncoding) => throw null;
                public static void ExtractToDirectory(string sourceArchiveFileName, string destinationDirectoryName) => throw null;
                public static void ExtractToDirectory(string sourceArchiveFileName, string destinationDirectoryName, System.Text.Encoding entryNameEncoding) => throw null;
                public static void ExtractToDirectory(string sourceArchiveFileName, string destinationDirectoryName, System.Text.Encoding entryNameEncoding, bool overwriteFiles) => throw null;
                public static void ExtractToDirectory(string sourceArchiveFileName, string destinationDirectoryName, bool overwriteFiles) => throw null;
                public static System.IO.Compression.ZipArchive Open(string archiveFileName, System.IO.Compression.ZipArchiveMode mode) => throw null;
                public static System.IO.Compression.ZipArchive Open(string archiveFileName, System.IO.Compression.ZipArchiveMode mode, System.Text.Encoding entryNameEncoding) => throw null;
                public static System.IO.Compression.ZipArchive OpenRead(string archiveFileName) => throw null;
            }

            // Generated from `System.IO.Compression.ZipFileExtensions` in `System.IO.Compression.ZipFile, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089`
            public static class ZipFileExtensions
            {
                public static System.IO.Compression.ZipArchiveEntry CreateEntryFromFile(this System.IO.Compression.ZipArchive destination, string sourceFileName, string entryName) => throw null;
                public static System.IO.Compression.ZipArchiveEntry CreateEntryFromFile(this System.IO.Compression.ZipArchive destination, string sourceFileName, string entryName, System.IO.Compression.CompressionLevel compressionLevel) => throw null;
                public static void ExtractToDirectory(this System.IO.Compression.ZipArchive source, string destinationDirectoryName) => throw null;
                public static void ExtractToDirectory(this System.IO.Compression.ZipArchive source, string destinationDirectoryName, bool overwriteFiles) => throw null;
                public static void ExtractToFile(this System.IO.Compression.ZipArchiveEntry source, string destinationFileName) => throw null;
                public static void ExtractToFile(this System.IO.Compression.ZipArchiveEntry source, string destinationFileName, bool overwrite) => throw null;
            }

        }
    }
}
