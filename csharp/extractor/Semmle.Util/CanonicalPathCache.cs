using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using Semmle.Util.Logging;
using Mono.Unix;

namespace Semmle.Util
{
    /// <summary>
    /// Interface for obtaining canonical paths.
    /// </summary>
    public interface IPathCache
    {
        string GetCanonicalPath(string path);
    }

    /// <summary>
    /// Algorithm for determining a canonical path.
    /// For example some strategies may preserve symlinks
    /// or only work on certain platforms.
    /// </summary>
    public abstract class PathStrategy
    {
        /// <summary>
        /// Obtain a canonical path.
        /// </summary>
        /// <param name="path">The path to canonicalise.</param>
        /// <param name="cache">A cache for making subqueries.</param>
        /// <returns>The canonical path.</returns>
        public abstract string GetCanonicalPath(string path, IPathCache cache);

        /// <summary>
        /// Constructs a canonical path for a file
        /// which doesn't yet exist.
        /// </summary>
        /// <param name="path">Path to canonicalise.</param>
        /// <param name="cache">The PathCache.</param>
        /// <returns>A canonical path.</returns>
        protected static string ConstructCanonicalPath(string path, IPathCache cache)
        {
            var parent = Directory.GetParent(path);

            return parent is not null ?
                Path.Combine(cache.GetCanonicalPath(parent.FullName), Path.GetFileName(path)) :
                path.ToUpperInvariant();
        }
    }

    /// <summary>
    /// Determine canonical paths using the Win32 function
    /// GetFinalPathNameByHandle(). Follows symlinks.
    /// </summary>
    internal class GetFinalPathNameByHandleStrategy : PathStrategy
    {
        /// <summary>
        /// Call GetFinalPathNameByHandle() to get a canonical filename.
        /// Follows symlinks.
        /// </summary>
        ///
        /// <remarks>
        /// GetFinalPathNameByHandle() only works on open file handles,
        /// so if the path doesn't yet exist, construct the path
        /// by appending the filename to the canonical parent directory.
        /// </remarks>
        ///
        /// <param name="path">The path to canonicalise.</param>
        /// <param name="cache">Subquery cache.</param>
        /// <returns>The canonical path.</returns>
        public override string GetCanonicalPath(string path, IPathCache cache)
        {
            using var hFile = Win32.CreateFile(  // lgtm[cs/call-to-unmanaged-code]
                path,
                0,
                Win32.FILE_SHARE_READ | Win32.FILE_SHARE_WRITE,
                IntPtr.Zero,
                Win32.OPEN_EXISTING,
                Win32.FILE_FLAG_BACKUP_SEMANTICS,
                IntPtr.Zero);

            if (hFile.IsInvalid)
            {
                // File/directory does not exist.
                return ConstructCanonicalPath(path, cache);
            }

            var outPath = new StringBuilder(Win32.MAX_PATH);
            var length = Win32.GetFinalPathNameByHandle(hFile, outPath, outPath.Capacity, 0);  // lgtm[cs/call-to-unmanaged-code]

            if (length >= outPath.Capacity)
            {
                // Path length exceeded MAX_PATH.
                // Possible if target has a long path.
                outPath = new StringBuilder(length + 1);
                length = Win32.GetFinalPathNameByHandle(hFile, outPath, outPath.Capacity, 0);  // lgtm[cs/call-to-unmanaged-code]
            }

            const int preamble = 4; // outPath always starts \\?\

            if (length <= preamble)
            {
                // Failed. GetFinalPathNameByHandle() failed somehow.
                return ConstructCanonicalPath(path, cache);
            }

            var result = outPath.ToString(preamble, length - preamble);  // Trim off leading \\?\

            return result.StartsWith("UNC")
                ? @"\" + result.Substring(3)
                : result;
        }
    }

    /// <summary>
    /// Determine file case by querying directory contents.
    /// Preserves symlinks.
    /// </summary>
    internal class QueryDirectoryStrategy : PathStrategy
    {
        public override string GetCanonicalPath(string path, IPathCache cache)
        {
            var parent = Directory.GetParent(path);

            if (parent is null)
            {
                // We are at a root of the filesystem.
                // Convert drive letters, UNC paths etc. to uppercase.
                // On UNIX, this should be "/" or "".
                return path.ToUpperInvariant();

            }

            var name = Path.GetFileName(path);
            var parentPath = cache.GetCanonicalPath(parent.FullName);
            try
            {
                var entries = Directory.GetFileSystemEntries(parentPath, name);
                return entries.Length == 1
                    ? entries[0]
                    : Path.Combine(parentPath, name);
            }
            catch  // lgtm[cs/catch-of-all-exceptions]
            {
                // IO error or security error querying directory.
                return Path.Combine(parentPath, name);
            }
        }
    }

    /// <summary>
    /// Uses Mono.Unix.UnixPath to resolve symlinks.
    /// Not available on Windows.
    /// </summary>
    internal class PosixSymlinkStrategy : PathStrategy
    {
        public PosixSymlinkStrategy()
        {
            GetRealPath(".");   // Test that it works
        }

        private static string GetRealPath(string path)
        {
            path = UnixPath.GetFullPath(path);
            return UnixPath.GetCompleteRealPath(path);
        }

        public override string GetCanonicalPath(string path, IPathCache cache)
        {
            try
            {
                return GetRealPath(path);
            }
            catch  // lgtm[cs/catch-of-all-exceptions]
            {
                // File does not exist
                return ConstructCanonicalPath(path, cache);
            }
        }
    }

    /// <summary>
    /// Class which computes canonical paths.
    /// Contains a simple thread-safe cache of files and directories.
    /// </summary>
    public class CanonicalPathCache : IPathCache
    {
        /// <summary>
        /// The maximum number of items in the cache.
        /// </summary>
        private readonly int maxCapacity;

        /// <summary>
        /// How to handle symlinks.
        /// </summary>
        public enum Symlinks
        {
            Follow,
            Preserve
        }

        /// <summary>
        /// Algorithm for computing the canonical path.
        /// </summary>
        private readonly PathStrategy pathStrategy;

        /// <summary>
        /// Create cache with a given capacity.
        /// </summary>
        /// <param name="pathStrategy">The algorithm for determining the canonical path.</param>
        /// <param name="capacity">The size of the cache.</param>
        public CanonicalPathCache(int maxCapacity, PathStrategy pathStrategy)
        {
            if (maxCapacity <= 0)
                throw new ArgumentOutOfRangeException(nameof(maxCapacity), maxCapacity, "Invalid cache size specified");

            this.maxCapacity = maxCapacity;
            this.pathStrategy = pathStrategy;
        }


        /// <summary>
        /// Create a CanonicalPathCache.
        /// </summary>
        ///
        /// <remarks>
        /// Creates the appropriate PathStrategy object which encapsulates
        /// the correct algorithm. Falls back to different implementations
        /// depending on platform.
        /// </remarks>
        ///
        /// <param name="maxCapacity">Size of the cache.</param>
        /// <param name="symlinks">Policy for following symlinks.</param>
        /// <returns>A new CanonicalPathCache.</returns>
        public static CanonicalPathCache Create(ILogger logger, int maxCapacity)
        {
            var preserveSymlinks =
                Environment.GetEnvironmentVariable("CODEQL_PRESERVE_SYMLINKS") == "true" ||
                Environment.GetEnvironmentVariable("SEMMLE_PRESERVE_SYMLINKS") == "true";
            return Create(logger, maxCapacity, preserveSymlinks ? CanonicalPathCache.Symlinks.Preserve : CanonicalPathCache.Symlinks.Follow);

        }

        /// <summary>
        /// Create a CanonicalPathCache.
        /// </summary>
        ///
        /// <remarks>
        /// Creates the appropriate PathStrategy object which encapsulates
        /// the correct algorithm. Falls back to different implementations
        /// depending on platform.
        /// </remarks>
        ///
        /// <param name="maxCapacity">Size of the cache.</param>
        /// <param name="symlinks">Policy for following symlinks.</param>
        /// <returns>A new CanonicalPathCache.</returns>
        public static CanonicalPathCache Create(ILogger logger, int maxCapacity, Symlinks symlinks)
        {
            PathStrategy pathStrategy;

            switch (symlinks)
            {
                case Symlinks.Follow:
                    try
                    {
                        pathStrategy = Win32.IsWindows() ?
                            (PathStrategy)new GetFinalPathNameByHandleStrategy() :
                            (PathStrategy)new PosixSymlinkStrategy();
                    }
                    catch  // lgtm[cs/catch-of-all-exceptions]
                    {
                        // Failed to late-bind a suitable library.
                        logger.Log(Severity.Warning, "Preserving symlinks in canonical paths");
                        pathStrategy = new QueryDirectoryStrategy();
                    }
                    break;
                case Symlinks.Preserve:
                    pathStrategy = new QueryDirectoryStrategy();
                    break;
                default:
                    throw new ArgumentOutOfRangeException(nameof(symlinks), symlinks, "Invalid symlinks option");
            }

            return new CanonicalPathCache(maxCapacity, pathStrategy);
        }

        /// <summary>
        /// Map of path to canonical path.
        /// </summary>
        private readonly IDictionary<string, string> cache = new Dictionary<string, string>();

        /// <summary>
        /// Used to evict random cache items when the cache is full.
        /// </summary>
        private readonly Random random = new Random();

        /// <summary>
        /// The current number of items in the cache.
        /// </summary>
        public int CacheSize
        {
            get
            {
                lock (cache)
                    return cache.Count;
            }
        }

        /// <summary>
        /// Adds a path to the cache.
        /// Removes items from cache as needed.
        /// </summary>
        /// <param name="path">The path.</param>
        /// <param name="canonical">The canonical form of path.</param>
        private void AddToCache(string path, string canonical)
        {
            if (cache.Count >= maxCapacity)
            {
                /* A simple strategy for limiting the cache size, given that
                 * C# doesn't have a convenient dictionary+list data structure.
                 */
                cache.Remove(cache.ElementAt(random.Next(maxCapacity)));
            }
            cache[path] = canonical;
        }

        /// <summary>
        /// Retrieve the canonical path for a given path.
        /// Caches the result.
        /// </summary>
        /// <param name="path">The path.</param>
        /// <returns>The canonical path.</returns>
        public string GetCanonicalPath(string path)
        {
            lock (cache)
            {
                if (!cache.TryGetValue(path, out var canonicalPath))
                {
                    canonicalPath = pathStrategy.GetCanonicalPath(path, this);
                    AddToCache(path, canonicalPath);
                }
                return canonicalPath;
            }
        }
    }
}
