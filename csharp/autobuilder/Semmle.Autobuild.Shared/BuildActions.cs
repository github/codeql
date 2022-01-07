using Semmle.Util;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Xml;
using System.Net.Http;
using System.Diagnostics.CodeAnalysis;
using System.Threading.Tasks;

namespace Semmle.Autobuild.Shared
{
    /// <summary>
    /// Wrapper around system calls so that the build scripts can be unit-tested.
    /// </summary>
    public interface IBuildActions
    {
        /// <summary>
        /// Runs a process and captures its output.
        /// </summary>
        /// <param name="exe">The exe to run.</param>
        /// <param name="args">The other command line arguments.</param>
        /// <param name="workingDirectory">The working directory (<code>null</code> for current directory).</param>
        /// <param name="env">Additional environment variables.</param>
        /// <param name="stdOut">The lines of stdout.</param>
        /// <returns>The process exit code.</returns>
        int RunProcess(string exe, string args, string? workingDirectory, IDictionary<string, string>? env, out IList<string> stdOut);

        /// <summary>
        /// Runs a process but does not capture its output.
        /// </summary>
        /// <param name="exe">The exe to run.</param>
        /// <param name="args">The other command line arguments.</param>
        /// <param name="workingDirectory">The working directory (<code>null</code> for current directory).</param>
        /// <param name="env">Additional environment variables.</param>
        /// <returns>The process exit code.</returns>
        int RunProcess(string exe, string args, string? workingDirectory, IDictionary<string, string>? env);

        /// <summary>
        /// Tests whether a file exists, File.Exists().
        /// </summary>
        /// <param name="file">The filename.</param>
        /// <returns>True iff the file exists.</returns>
        bool FileExists(string file);

        /// <summary>
        /// Tests whether a directory exists, Directory.Exists().
        /// </summary>
        /// <param name="dir">The directory name.</param>
        /// <returns>True iff the directory exists.</returns>
        bool DirectoryExists(string dir);

        /// <summary>
        /// Deletes a file, File.Delete().
        /// </summary>
        /// <param name="file">The filename.</param>
        void FileDelete(string file);

        /// <summary>
        /// Deletes a directory, Directory.Delete().
        /// </summary>
        void DirectoryDelete(string dir, bool recursive);

        /// <summary>
        /// Creates all directories and subdirectories in the specified path unless they already exist.
        /// </summary>
        void CreateDirectory(string path);

        /// <summary>
        /// Gets an environment variable, Environment.GetEnvironmentVariable().
        /// </summary>
        /// <param name="name">The name of the variable.</param>
        /// <returns>The string value, or null if the variable is not defined.</returns>
        string? GetEnvironmentVariable(string name);

        /// <summary>
        /// Gets the current directory, Directory.GetCurrentDirectory().
        /// </summary>
        /// <returns>The current directory.</returns>
        string GetCurrentDirectory();

        /// <summary>
        /// Enumerates files in a directory, Directory.EnumerateFiles().
        /// </summary>
        /// <param name="dir">The directory to enumerate.</param>
        /// <returns>A list of filenames, or an empty list.</returns>
        IEnumerable<string> EnumerateFiles(string dir);

        /// <summary>
        /// Enumerates the directories in a directory, Directory.EnumerateDirectories().
        /// </summary>
        /// <param name="dir">The directory to enumerate.</param>
        /// <returns>List of subdirectories, or empty list.</returns>
        IEnumerable<string> EnumerateDirectories(string dir);

        /// <summary>
        /// True if we are running on Windows.
        /// </summary>
        bool IsWindows();

        /// <summary>
        /// Combine path segments, Path.Combine().
        /// </summary>
        /// <param name="parts">The parts of the path.</param>
        /// <returns>The combined path.</returns>
        string PathCombine(params string[] parts);

        /// <summary>
        /// Gets the full path for <paramref name="path"/>, Path.GetFullPath().
        /// </summary>
        string GetFullPath(string path);

        /// <summary>
        /// Returns the file name and extension of the specified path string.
        /// </summary>
        [return: NotNullIfNotNull("path")]
        string? GetFileName(string? path);

        /// <summary>
        /// Returns the directory information for the specified path string.
        /// </summary>
        string? GetDirectoryName(string? path);

        /// <summary>
        /// Writes contents to file, File.WriteAllText().
        /// </summary>
        /// <param name="filename">The filename.</param>
        /// <param name="contents">The text.</param>
        void WriteAllText(string filename, string contents);

        /// <summary>
        /// Loads the XML document from <paramref name="filename"/>.
        /// </summary>
        XmlDocument LoadXml(string filename);

        string EnvironmentExpandEnvironmentVariables(string s);

        /// <summary>
        /// Downloads the resource with the specified URI to a local file.
        /// </summary>
        void DownloadFile(string address, string fileName);
    }

    /// <summary>
    /// An implementation of IBuildActions that actually performs the requested operations.
    /// </summary>
    public class SystemBuildActions : IBuildActions
    {
        void IBuildActions.FileDelete(string file) => File.Delete(file);

        bool IBuildActions.FileExists(string file) => File.Exists(file);

        private static ProcessStartInfo GetProcessStartInfo(string exe, string arguments, string? workingDirectory, IDictionary<string, string>? environment, bool redirectStandardOutput)
        {
            var pi = new ProcessStartInfo(exe, arguments)
            {
                UseShellExecute = false,
                RedirectStandardOutput = redirectStandardOutput
            };
            if (workingDirectory is not null)
                pi.WorkingDirectory = workingDirectory;

            // Environment variables can only be used when not redirecting stdout
            if (!redirectStandardOutput)
            {
                if (environment is not null)
                    environment.ForEach(kvp => pi.Environment[kvp.Key] = kvp.Value);
            }
            return pi;
        }

        int IBuildActions.RunProcess(string cmd, string args, string? workingDirectory, IDictionary<string, string>? environment)
        {
            var pi = GetProcessStartInfo(cmd, args, workingDirectory, environment, false);
            using var p = Process.Start(pi);
            if (p is null)
            {
                return -1;
            }
            p.WaitForExit();
            return p.ExitCode;
        }

        int IBuildActions.RunProcess(string cmd, string args, string? workingDirectory, IDictionary<string, string>? environment, out IList<string> stdOut)
        {
            var pi = GetProcessStartInfo(cmd, args, workingDirectory, environment, true);
            return pi.ReadOutput(out stdOut);
        }

        void IBuildActions.DirectoryDelete(string dir, bool recursive) => Directory.Delete(dir, recursive);

        bool IBuildActions.DirectoryExists(string dir) => Directory.Exists(dir);

        void IBuildActions.CreateDirectory(string path) => Directory.CreateDirectory(path);

        string? IBuildActions.GetEnvironmentVariable(string name) => Environment.GetEnvironmentVariable(name);

        string IBuildActions.GetCurrentDirectory() => Directory.GetCurrentDirectory();

        IEnumerable<string> IBuildActions.EnumerateFiles(string dir) => Directory.EnumerateFiles(dir);

        IEnumerable<string> IBuildActions.EnumerateDirectories(string dir) => Directory.EnumerateDirectories(dir);

        bool IBuildActions.IsWindows() => Win32.IsWindows();

        string IBuildActions.PathCombine(params string[] parts) => Path.Combine(parts);

        void IBuildActions.WriteAllText(string filename, string contents) => File.WriteAllText(filename, contents);

        XmlDocument IBuildActions.LoadXml(string filename)
        {
            var ret = new XmlDocument();
            ret.Load(filename);
            return ret;
        }

        string IBuildActions.GetFullPath(string path) => Path.GetFullPath(path);

        string? IBuildActions.GetFileName(string? path) => Path.GetFileName(path);

        string? IBuildActions.GetDirectoryName(string? path) => Path.GetDirectoryName(path);

        public string EnvironmentExpandEnvironmentVariables(string s) => Environment.ExpandEnvironmentVariables(s);

        private static async Task DownloadFileAsync(string address, string filename)
        {
            using var httpClient = new HttpClient();
            using var request = new HttpRequestMessage(HttpMethod.Get, address);
            using var contentStream = await (await httpClient.SendAsync(request)).Content.ReadAsStreamAsync();
            using var stream = new FileStream(filename, FileMode.Create, FileAccess.Write, FileShare.None, 4096, true);
            await contentStream.CopyToAsync(stream);
        }

        public void DownloadFile(string address, string fileName) =>
            DownloadFileAsync(address, fileName).Wait();

        public static IBuildActions Instance { get; } = new SystemBuildActions();
    }
}
