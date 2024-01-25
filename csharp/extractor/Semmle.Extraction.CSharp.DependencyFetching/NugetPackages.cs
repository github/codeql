using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using Microsoft.Build.Framework;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    /// <summary>
    /// Manage the downloading of NuGet packages.
    /// Locates packages in a source tree and downloads all of the
    /// referenced assemblies to a temp folder.
    /// </summary>
    internal class NugetPackages
    {
        private readonly string? nugetExe;
        private readonly Util.Logging.ILogger logger;

        /// <summary>
        /// The list of package files.
        /// </summary>
        private readonly FileInfo[] packageFiles;

        /// <summary>
        /// The computed packages directory.
        /// This will be in the Temp location
        /// so as to not trample the source tree.
        /// </summary>
        private readonly TemporaryDirectory packageDirectory;

        /// <summary>
        /// Create the package manager for a specified source tree.
        /// </summary>
        public NugetPackages(string sourceDir, TemporaryDirectory packageDirectory, Util.Logging.ILogger logger)
        {
            this.packageDirectory = packageDirectory;
            this.logger = logger;

            packageFiles = new DirectoryInfo(sourceDir)
                .EnumerateFiles("packages.config", SearchOption.AllDirectories)
                .ToArray();

            if (packageFiles.Length > 0)
            {
                logger.LogInfo($"Found {packageFiles.Length} packages.config files, trying to use nuget.exe for package restore");
                nugetExe = ResolveNugetExe(sourceDir);
            }
            else
            {
                logger.LogInfo("Found no packages.config file");
            }
        }

        /// <summary>
        /// Tries to find the location of `nuget.exe` in the nuget directory under the directory
        /// containing the executing assembly. If it can't be found, it is downloaded to the
        /// `.nuget` directory under the source directory.
        /// </summary>
        /// <param name="sourceDir">The source directory.</param>
        private string ResolveNugetExe(string sourceDir)
        {
            var currentAssembly = System.Reflection.Assembly.GetExecutingAssembly().Location;
            var directory = Path.GetDirectoryName(currentAssembly)
                ?? throw new FileNotFoundException($"Directory path '{currentAssembly}' of current assembly is null");

            var nuget = Path.Combine(directory, "nuget", "nuget.exe");
            if (File.Exists(nuget))
            {
                logger.LogInfo($"Found nuget.exe at {nuget}");
                return nuget;
            }

            return DownloadNugetExe(sourceDir);
        }

        private string DownloadNugetExe(string sourceDir)
        {
            var directory = Path.Combine(sourceDir, ".nuget");
            var nuget = Path.Combine(directory, "nuget.exe");

            // Nuget.exe already exists in the .nuget directory.
            if (File.Exists(nuget))
            {
                logger.LogInfo($"Found nuget.exe at {nuget}");
                return nuget;
            }

            Directory.CreateDirectory(directory);
            logger.LogInfo("Attempting to download nuget.exe");
            try
            {
                FileUtils.DownloadFile(FileUtils.NugetExeUrl, nuget);
                logger.LogInfo($"Downloaded nuget.exe to {nuget}");
                return nuget;
            }
            catch
            {
                // Download failed.
                throw new FileNotFoundException("Download of nuget.exe failed.");
            }
        }

        /// <summary>
        /// Restore all files in a specified package.
        /// </summary>
        /// <param name="package">The package file.</param>
        private void RestoreNugetPackage(string package)
        {
            logger.LogInfo($"Restoring file {package}...");

            /* Use nuget.exe to install a package.
             * Note that there is a clutch of NuGet assemblies which could be used to
             * invoke this directly, which would arguably be nicer. However they are
             * really unwieldy and this solution works for now.
             */

            string exe, args;
            if (Util.Win32.IsWindows())
            {
                exe = nugetExe!;
                args = string.Format("install -OutputDirectory {0} {1}", packageDirectory, package);
            }
            else
            {
                exe = "mono";
                args = string.Format("{0} install -OutputDirectory {1} {2}", nugetExe, packageDirectory, package);
            }

            var pi = new ProcessStartInfo(exe, args)
            {
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false
            };

            var threadId = Environment.CurrentManagedThreadId;
            void onOut(string s) => logger.LogInfo(s, threadId);
            void onError(string s) => logger.LogError(s, threadId);
            var exitCode = pi.ReadOutput(out var _, onOut, onError);
            if (exitCode != 0)
            {
                logger.LogError($"Command {pi.FileName} {pi.Arguments} failed with exit code {exitCode}");
            }
            else
            {
                logger.LogInfo($"Restored file {package}");
            }
        }

        /// <summary>
        /// Download the packages to the temp folder.
        /// </summary>
        public void InstallPackages()
        {
            foreach (var package in packageFiles)
            {
                RestoreNugetPackage(package.FullName);
            }
        }
    }
}
