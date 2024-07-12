using System;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using Semmle.Util.Logging;

namespace Semmle.Util
{
    public static class FileUtils
    {
        public const string NugetExeUrl = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe";

        public static readonly char[] NewLineCharacters = ['\r', '\n'];

        public static string ConvertToWindows(string path)
        {
            return path.Replace('/', '\\');
        }

        public static string ConvertToUnix(string path)
        {
            return path.Replace('\\', '/');
        }

        public static string ConvertToNative(string path)
        {
            return Path.DirectorySeparatorChar == '/' ?
                path.Replace('\\', '/') :
                path.Replace('/', '\\');
        }

        /// <summary>
        /// Moves the source file to the destination, overwriting the destination file if
        /// it exists already.
        /// </summary>
        /// <param name="src">Source file.</param>
        /// <param name="dest">Target file.</param>
        public static void MoveOrReplace(string src, string dest)
        {
            File.Move(src, dest, overwrite: true);
        }

        /// <summary>
        /// Attempt to delete the given file (ignoring I/O exceptions).
        /// </summary>
        /// <param name="file">The file to delete.</param>
        public static void TryDelete(string file)
        {
            try
            {
                File.Delete(file);
            }
            catch (IOException)
            {
                // Ignore
            }
        }

        /// <summary>
        /// Finds the path for the program <paramref name="prog"/> based on the
        /// <code>PATH</code> environment variable, and in the case of Windows the
        /// <code>PATHEXT</code> environment variable.
        ///
        /// Returns <code>null</code> of no path can be found.
        /// </summary>
        public static string? FindProgramOnPath(string prog)
        {
            var paths = Environment.GetEnvironmentVariable("PATH")?.Split(Path.PathSeparator);
            string[] exes;
            if (Win32.IsWindows())
            {
                var extensions = Environment.GetEnvironmentVariable("PATHEXT")?.Split(';')?.ToArray();
                exes = extensions is null || extensions.Any(prog.EndsWith)
                    ? new[] { prog }
                    : extensions.Select(ext => prog + ext).ToArray();
            }
            else
            {
                exes = new[] { prog };
            }
            var candidates = paths?.Where(path => exes.Any(exe0 => File.Exists(Path.Combine(path, exe0))));
            return candidates?.FirstOrDefault();
        }

        /// <summary>
        /// Computes the hash of <paramref name="filePath"/>.
        /// </summary>
        public static string ComputeFileHash(string filePath)
        {
            using var fileStream = new FileStream(filePath, FileMode.Open, FileAccess.Read, FileShare.Read);
            using var shaAlg = SHA256.Create();
            var sha = shaAlg.ComputeHash(fileStream);
            var hex = new StringBuilder(sha.Length * 2);
            foreach (var b in sha)
                hex.AppendFormat("{0:x2}", b);
            return hex.ToString();
        }

        private static async Task DownloadFileAsync(string address, string filename)
        {
            using var httpClient = new HttpClient();
            using var contentStream = await httpClient.GetStreamAsync(address);
            using var stream = new FileStream(filename, FileMode.Create, FileAccess.Write, FileShare.None, 4096, true);
            await contentStream.CopyToAsync(stream);
        }

        /// <summary>
        /// Downloads the file at <paramref name="address"/> to <paramref name="fileName"/>.
        /// </summary>
        public static void DownloadFile(string address, string fileName) =>
           DownloadFileAsync(address, fileName).GetAwaiter().GetResult();

        public static string ConvertPathToSafeRelativePath(string path)
        {
            // Remove all leading path separators / or \
            // For example, UNC paths have two leading \\
            path = path.TrimStart(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar);

            if (path.Length > 1 && path[1] == ':')
                path = $"{path[0]}_{path[2..]}";

            return path;
        }

        public static string NestPaths(ILogger logger, string? outerpath, string innerpath)
        {
            var nested = innerpath;
            if (!string.IsNullOrEmpty(outerpath))
            {
                innerpath = ConvertPathToSafeRelativePath(innerpath);

                nested = Path.Combine(outerpath, innerpath);
            }
            try
            {
                var directoryName = Path.GetDirectoryName(nested);
                if (directoryName is null)
                {
                    logger.LogWarning($"Failed to get directory name from path '{nested}'.");
                    throw new InvalidOperationException();
                }
                Directory.CreateDirectory(directoryName);
            }
            catch (PathTooLongException)
            {
                logger.LogWarning($"Failed to create parent directory of '{nested}': Path too long.");
                throw;
            }
            return nested;
        }

        private static readonly Lazy<string> tempFolderPath = new Lazy<string>(() =>
        {
            var tempPath = Path.GetTempPath();
            var name = Guid.NewGuid().ToString("N").ToUpper();
            var tempFolder = Path.Combine(tempPath, "GitHub", name);
            Directory.CreateDirectory(tempFolder);
            return tempFolder;
        });

        public static string GetTemporaryWorkingDirectory(Func<string, string?> getEnvironmentVariable, string lang, out bool shouldCleanUp)
        {
            var tempFolder = getEnvironmentVariable($"CODEQL_EXTRACTOR_{lang}_SCRATCH_DIR");
            if (!string.IsNullOrEmpty(tempFolder))
            {
                shouldCleanUp = false;
                return tempFolder;
            }

            shouldCleanUp = true;
            return tempFolderPath.Value;
        }

        public static string GetTemporaryWorkingDirectory(out bool shouldCleanUp) =>
            GetTemporaryWorkingDirectory(Environment.GetEnvironmentVariable, "CSHARP", out shouldCleanUp);

        public static FileInfo CreateTemporaryFile(string extension, out bool shouldCleanUpContainingFolder)
        {
            var tempFolder = GetTemporaryWorkingDirectory(out shouldCleanUpContainingFolder);
            Directory.CreateDirectory(tempFolder);
            string outputPath;
            do
            {
                outputPath = Path.Combine(tempFolder, Path.GetRandomFileName() + extension);
            }
            while (File.Exists(outputPath));

            File.Create(outputPath);

            return new FileInfo(outputPath);
        }

        public static string SafeGetDirectoryName(string path, ILogger logger)
        {
            try
            {
                var dir = Path.GetDirectoryName(path);
                if (dir is null)
                {
                    return "";
                }

                if (!dir.EndsWith(Path.DirectorySeparatorChar))
                {
                    dir += Path.DirectorySeparatorChar;
                }

                return dir;
            }
            catch (Exception ex)
            {
                logger.LogDebug($"Failed to get directory name for {path}: {ex.Message}");
                return "";
            }
        }

        public static string? SafeGetFileName(string path, ILogger logger)
        {
            try
            {
                return Path.GetFileName(path);
            }
            catch (Exception ex)
            {
                logger.LogDebug($"Failed to get file name for {path}: {ex.Message}");
                return null;
            }
        }
    }
}
