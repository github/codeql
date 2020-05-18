using Semmle.Util;
using Semmle.Util.Logging;
using System;
using System.IO;
using System.IO.Compression;
using System.Text;

namespace Semmle.Extraction
{
    public interface ITrapEmitter
    {
        void EmitTrap(TextWriter trapFile);
    }

    public sealed class TrapWriter : IDisposable
    {
        public enum InnerPathComputation
        {
            ABSOLUTE,
            RELATIVE
        }

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
        private static readonly Encoding UTF8 = new UTF8Encoding(false);

        private readonly bool discardDuplicates;

        public int IdCounter { get; set; } = 1;

        readonly Lazy<StreamWriter> WriterLazy;

        public StreamWriter Writer => WriterLazy.Value;

        readonly ILogger Logger;

        readonly CompressionMode TrapCompression;

        public TrapWriter(ILogger logger, string outputfile, string? trap, string? archive, bool discardDuplicates, CompressionMode trapCompression)
        {
            Logger = logger;
            TrapCompression = trapCompression;

            TrapFile = TrapPath(Logger, trap, outputfile, trapCompression);

            WriterLazy = new Lazy<StreamWriter>(() =>
            {
                var tempPath = trap ?? Path.GetTempPath();

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
                        throw new ArgumentException(nameof(trapCompression));
                }


                return new StreamWriter(compressionStream, UTF8, 2000000);
            });
            this.archive = archive;
            this.discardDuplicates = discardDuplicates;
        }

        /// <summary>
        /// The output filename of the trap.
        /// </summary>
        public readonly string TrapFile;
        string tmpFile = "";     // The temporary file which is moved to trapFile once written.

        /// <summary>
        /// Adds the specified input file to the source archive. It may end up in either the normal or long path area
        /// of the source archive, depending on the length of its full path.
        /// </summary>
        /// <param name="inputPath">The path to the input file.</param>
        /// <param name="inputEncoding">The encoding used by the input file.</param>
        public void Archive(string inputPath, Encoding inputEncoding)
        {
            if (string.IsNullOrEmpty(archive)) return;

            // Calling GetFullPath makes this use the canonical capitalisation, if the file exists.
            string fullInputPath = Path.GetFullPath(inputPath);

            ArchivePath(fullInputPath, inputEncoding);
        }

        /// <summary>
        /// Archive a file given the file contents.
        /// </summary>
        /// <param name="inputPath">The path of the file.</param>
        /// <param name="contents">The contents of the file.</param>
        public void Archive(string inputPath, string contents)
        {
            if (string.IsNullOrEmpty(archive)) return;

            // Calling GetFullPath makes this use the canonical capitalisation, if the file exists.
            string fullInputPath = Path.GetFullPath(inputPath);

            ArchiveContents(fullInputPath, contents);
        }

        /// <summary>
        /// Try to move a file from sourceFile to destFile.
        /// If successful returns true,
        /// otherwise returns false and leaves the file in its original place.
        /// </summary>
        /// <param name="sourceFile">The source filename.</param>
        /// <param name="destFile">The destination filename.</param>
        /// <returns>true if the file was moved.</returns>
        static bool TryMove(string sourceFile, string destFile)
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
                if (WriterLazy.IsValueCreated)
                {
                    WriterLazy.Value.Close();
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
                        if (TryMove(tmpFile, $"{root}-{hash}.trap{TrapExtension(TrapCompression)}"))
                            return;
                    }
                    Logger.Log(Severity.Info, "Identical trap file for {0} already exists", TrapFile);
                    FileUtils.TryDelete(tmpFile);
                }
            }
            catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
            {
                Logger.Log(Severity.Error, "Failed to move the trap file from {0} to {1} because {2}", tmpFile, TrapFile, ex);
            }
        }

        public void Emit(ITrapEmitter emitter)
        {
            emitter.EmitTrap(Writer);
        }

        /// <summary>
        /// Attempts to archive the specified input file to the normal area of the source archive.
        /// The file's path must be sufficiently short so as to render the path of its copy in the
        /// source archive less than the system path limit of 260 characters.
        /// </summary>
        /// <param name="fullInputPath">The full path to the input file.</param>
        /// <param name="inputEncoding">The encoding used by the input file.</param>
        /// <exception cref="PathTooLongException">If the output path in the source archive would
        /// exceed the system path limit of 260 characters.</exception>
        private void ArchivePath(string fullInputPath, Encoding inputEncoding)
        {
            string contents = File.ReadAllText(fullInputPath, inputEncoding);
            ArchiveContents(fullInputPath, contents);
        }

        private void ArchiveContents(string fullInputPath, string contents)
        {
            string dest = NestPaths(Logger, archive, fullInputPath, InnerPathComputation.ABSOLUTE);
            string tmpSrcFile = Path.GetTempFileName();
            File.WriteAllText(tmpSrcFile, contents, UTF8);
            try
            {
                FileUtils.MoveOrReplace(tmpSrcFile, dest);
            }
            catch (IOException ex)
            {
                // If this happened, it was probably because the same file was compiled multiple times.
                // In any case, this is not a fatal error.
                Logger.Log(Severity.Warning, "Problem archiving " + dest + ": " + ex);
            }
        }

        public static string NestPaths(ILogger logger, string? outerpath, string innerpath, InnerPathComputation innerPathComputation)
        {
            string nested = innerpath;
            if (!string.IsNullOrEmpty(outerpath))
            {
                if (!Path.IsPathRooted(innerpath) && innerPathComputation == InnerPathComputation.ABSOLUTE)
                    innerpath = Path.GetFullPath(innerpath);

                // Remove all leading path separators / or \
                // For example, UNC paths have two leading \\
                innerpath = innerpath.TrimStart(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar);

                if (innerpath.Length > 1 && innerpath[1] == ':')
                    innerpath = innerpath[0] + "_" + innerpath.Substring(2);

                nested = Path.Combine(outerpath, innerpath);
            }
            try
            {
                Directory.CreateDirectory(Path.GetDirectoryName(nested));
            }
            catch (PathTooLongException)
            {
                logger.Log(Severity.Warning, "Failed to create parent directory of '" + nested + "': Path too long.");
                throw;
            }
            return nested;
        }

        static string TrapExtension(CompressionMode compression)
        {
            switch (compression)
            {
                case CompressionMode.None: return "";
                case CompressionMode.Gzip: return ".gz";
                case CompressionMode.Brotli: return ".br";
                default: throw new ArgumentException(nameof(compression));
            }
        }

        public static string TrapPath(ILogger logger, string? folder, string filename, TrapWriter.CompressionMode trapCompression)
        {
            filename = $"{Path.GetFullPath(filename)}.trap{TrapExtension(trapCompression)}";
            if (string.IsNullOrEmpty(folder))
                folder = Directory.GetCurrentDirectory();

            return NestPaths(logger, folder, filename, InnerPathComputation.ABSOLUTE); ;
        }
    }
}
