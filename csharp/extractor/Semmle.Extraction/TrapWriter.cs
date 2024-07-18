using System;
using System.IO;
using System.IO.Compression;
using System.Text;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction
{
    public interface ITrapEmitter
    {
        void EmitTrap(TextWriter trapFile);
    }

    public sealed class TrapWriter : IDisposable
    {
        public enum CompressionMode
        {
            None,
            Gzip,
            Brotli
        }

        /// <summary>
        /// The location of the src_archive directory.
        /// </summary>
        private readonly string? archive;
        private static readonly Encoding utf8 = new UTF8Encoding(false);

        private readonly bool discardDuplicates;

        public int IdCounter { get; set; } = 1;

        private readonly Lazy<StreamWriter> writerLazy;

        public StreamWriter Writer => writerLazy.Value;

        private readonly ILogger logger;

        private readonly CompressionMode trapCompression;

        public TrapWriter(ILogger logger, PathTransformer.ITransformedPath outputfile, string? trap, string? archive, CompressionMode trapCompression, bool discardDuplicates)
        {
            this.logger = logger;
            this.trapCompression = trapCompression;

            TrapFile = TrapPath(this.logger, trap, outputfile, trapCompression);

            writerLazy = new Lazy<StreamWriter>(() =>
            {
                var tempPath = trap ?? FileUtils.GetTemporaryWorkingDirectory(out _);

                do
                {
                    /*
                     * Write the trap to a random filename in the trap folder.
                     * Since the trap path can be very long, we need to deal with the possibility of
                     * PathTooLongExceptions. So we use a short filename in the trap folder,
                     * then move it later.
                     *
                     * Although GetRandomFileName() is cryptographically secure,
                     * there's a tiny chance the file could already exists.
                     */
                    tmpFile = Path.Combine(tempPath, Path.GetRandomFileName());
                }
                while (File.Exists(tmpFile));

                var fileStream = new FileStream(tmpFile, FileMode.CreateNew, FileAccess.Write);

                Stream compressionStream;

                switch (trapCompression)
                {
                    case CompressionMode.Brotli:
                        compressionStream = new BrotliStream(fileStream, CompressionLevel.Fastest);
                        break;
                    case CompressionMode.Gzip:
                        compressionStream = new GZipStream(fileStream, CompressionLevel.Fastest);
                        break;
                    case CompressionMode.None:
                        compressionStream = fileStream;
                        break;
                    default:
                        throw new ArgumentOutOfRangeException(nameof(trapCompression), trapCompression, "Unsupported compression type");
                }


                return new StreamWriter(compressionStream, utf8, 2000000);
            });
            this.archive = archive;
            this.discardDuplicates = discardDuplicates;
        }

        /// <summary>
        /// The output filename of the trap.
        /// </summary>
        public string TrapFile { get; }
        private string tmpFile = "";     // The temporary file which is moved to trapFile once written.

        /// <summary>
        /// Adds the specified input file to the source archive. It may end up in either the normal or long path area
        /// of the source archive, depending on the length of its full path.
        /// </summary>
        /// <param name="originalPath">The path to the input file.</param>
        /// <param name="transformedPath">The transformed path to the input file.</param>
        /// <param name="inputEncoding">The encoding used by the input file.</param>
        public void Archive(string originalPath, PathTransformer.ITransformedPath transformedPath, Encoding inputEncoding)
        {
            Archive(() =>
            {
                var fullInputPath = Path.GetFullPath(originalPath);
                return File.ReadAllText(fullInputPath, inputEncoding);
            }, transformedPath);
        }

        public void ArchiveContent(string contents, PathTransformer.ITransformedPath transformedPath)
        {
            Archive(() => contents, transformedPath);
        }

        private void Archive(Func<string> getContent, PathTransformer.ITransformedPath transformedPath)
        {
            if (string.IsNullOrEmpty(archive))
            {
                return;
            }

            var dest = FileUtils.NestPaths(logger, archive, transformedPath.Value);
            try
            {
                var tmpSrcFile = Path.GetTempFileName();
                File.WriteAllText(tmpSrcFile, getContent(), utf8);

                FileUtils.MoveOrReplace(tmpSrcFile, dest);
            }
            catch (Exception ex)
            {
                // If this happened, it was probably because
                // - the same file was compiled multiple times, or
                // - the file doesn't exist (due to wrong #line directive or because it's an in-memory source generated AST).
                // In any case, this is not a fatal error.
                logger.LogWarning($"Problem archiving {dest}: {ex}");
            }
        }

        /// <summary>
        /// Try to move a file from sourceFile to destFile.
        /// If successful returns true,
        /// otherwise returns false and leaves the file in its original place.
        /// </summary>
        /// <param name="sourceFile">The source filename.</param>
        /// <param name="destFile">The destination filename.</param>
        /// <returns>true if the file was moved.</returns>
        private static bool TryMove(string sourceFile, string destFile)
        {
            try
            {
                // Prefer to avoid throwing an exception
                if (File.Exists(destFile))
                    return false;

                File.Move(sourceFile, destFile);
                return true;
            }
            catch (IOException)
            {
                return false;
            }
        }

        /// <summary>
        /// Close the trap file, and move it to the right place in the trap directory.
        /// If the file exists already, rename it to allow the new file (ending .trap.gz)
        /// to sit alongside the old file (except if <paramref name="discardDuplicates"/> is true,
        /// in which case only the existing file is kept).
        /// </summary>
        public void Dispose()
        {
            try
            {
                if (writerLazy.IsValueCreated)
                {
                    writerLazy.Value.Close();
                    if (TryMove(tmpFile, TrapFile))
                        return;

                    if (discardDuplicates)
                    {
                        FileUtils.TryDelete(tmpFile);
                        return;
                    }

                    var existingHash = FileUtils.ComputeFileHash(TrapFile);
                    var hash = FileUtils.ComputeFileHash(tmpFile);
                    if (existingHash != hash)
                    {
                        var root = TrapFile.Substring(0, TrapFile.Length - 8); // Remove trailing ".trap.gz"
                        if (TryMove(tmpFile, $"{root}-{hash}.trap{TrapExtension(trapCompression)}"))
                            return;
                    }
                    logger.LogInfo($"Identical trap file for {TrapFile} already exists");
                    FileUtils.TryDelete(tmpFile);
                }
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                logger.LogError($"Failed to move the trap file from {tmpFile} to {TrapFile} because {ex}");
            }
        }

        public void Emit(ITrapEmitter emitter)
        {
            emitter.EmitTrap(Writer);
        }

        private static string TrapExtension(CompressionMode compression)
        {
            switch (compression)
            {
                case CompressionMode.None: return "";
                case CompressionMode.Gzip: return ".gz";
                case CompressionMode.Brotli: return ".br";
                default: throw new ArgumentOutOfRangeException(nameof(compression), compression, "Unsupported compression type");
            }
        }

        public static string TrapPath(ILogger logger, string? folder, PathTransformer.ITransformedPath path, TrapWriter.CompressionMode trapCompression)
        {
            var filename = $"{path.Value}.trap{TrapExtension(trapCompression)}";
            if (string.IsNullOrEmpty(folder))
                folder = Directory.GetCurrentDirectory();

            return FileUtils.NestPaths(logger, folder, filename);
        }
    }
}
