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
            using var request = new HttpRequestMessage(HttpMethod.Get, address);
            using var contentStream = await (await httpClient.SendAsync(request)).Content.ReadAsStreamAsync();
            using var stream = new FileStream(filename, FileMode.Create, FileAccess.Write, FileShare.None, 4096, true);
            await contentStream.CopyToAsync(stream);
        }

        /// <summary>
        /// Downloads the file at <paramref name="address"/> to <paramref name="fileName"/>.
        /// </summary>
        public static void DownloadFile(string address, string fileName) =>
           DownloadFileAsync(address, fileName).Wait();

        public static string NestPaths(ILogger logger, string? outerpath, string innerpath)
        {
            var nested = innerpath;
            if (!string.IsNullOrEmpty(outerpath))
            {
                // Remove all leading path separators / or \
                // For example, UNC paths have two leading \\
                innerpath = innerpath.TrimStart(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar);

                if (innerpath.Length > 1 && innerpath[1] == ':')
                    innerpath = innerpath[0] + "_" + innerpath.Substring(2);

                nested = Path.Combine(outerpath, innerpath);
            }
            try
            {
                var directoryName = Path.GetDirectoryName(nested);
                if (directoryName is null)
                {
                    logger.Log(Severity.Warning, "Failed to get directory name from path '" + nested + "'.");
                    throw new InvalidOperationException();
                }
                Directory.CreateDirectory(directoryName);
            }
            catch (PathTooLongException)
            {
                logger.Log(Severity.Warning, "Failed to create parent directory of '" + nested + "': Path too long.");
                throw;
            }
            return nested;
        }

        public static string GetTemporaryWorkingDirectory(out bool shouldCleanUp)
        {
            shouldCleanUp = false;
            var tempFolder = EnvironmentVariables.GetScratchDirectory();

            if (string.IsNullOrEmpty(tempFolder))
            {
                var tempPath = Path.GetTempPath();
                var name = Guid.NewGuid().ToString("N").ToUpper();
                tempFolder = Path.Combine(tempPath, "GitHub", name);
                shouldCleanUp = true;
            }

            return tempFolder;
        }

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
    }
}
