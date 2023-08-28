using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
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
        private readonly string nugetExe;
        private readonly ProgressMonitor progressMonitor;

        /// <summary>
        /// The list of package files.
        /// </summary>
        public FileInfo[] PackageFiles { get; }

        /// <summary>
        /// The source directory used.
        /// </summary>
        public string SourceDirectory { get; }

        /// <summary>
        /// The computed packages directory.
        /// This will be in the Temp location
        /// so as to not trample the source tree.
        /// </summary>
        public TemporaryDirectory PackageDirectory { get; }

        /// <summary>
        /// Create the package manager for a specified source tree.
        /// </summary>
        public NugetPackages(string sourceDir, TemporaryDirectory packageDirectory, ProgressMonitor progressMonitor)
        {
            SourceDirectory = sourceDir;
            PackageDirectory = packageDirectory;
            this.progressMonitor = progressMonitor;

            nugetExe = ResolveNugetExe(sourceDir);
            PackageFiles = new DirectoryInfo(SourceDirectory)
                .EnumerateFiles("packages.config", SearchOption.AllDirectories)
                .ToArray();
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
                progressMonitor.LogInfo($"Found nuget.exe at {nuget}");
                return nuget;
            }
            else
            {
                progressMonitor.LogInfo($"Nuget.exe could not be found at {nuget}");
                return DownloadNugetExe(sourceDir);
            }
        }

        private string DownloadNugetExe(string sourceDir)
        {
            var directory = Path.Combine(sourceDir, ".nuget");
            var nuget = Path.Combine(directory, "nuget.exe");

            // Nuget.exe already exists in the .nuget directory.
            if (File.Exists(nuget))
            {
                progressMonitor.LogInfo($"Found nuget.exe at {nuget}");
                return nuget;
            }

            Directory.CreateDirectory(directory);
            progressMonitor.LogInfo("Attempting to download nuget.exe");
            try
            {
                FileUtils.DownloadFile(FileUtils.nugetExeUrl, nuget);
                progressMonitor.LogInfo($"Downloaded nuget.exe to {nuget}");
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
            progressMonitor.NugetInstall(package);

            /* Use nuget.exe to install a package.
             * Note that there is a clutch of NuGet assemblies which could be used to
             * invoke this directly, which would arguably be nicer. However they are
             * really unwieldy and this solution works for now.
             */

            string exe, args;
            if (Util.Win32.IsWindows())
            {
                exe = nugetExe;
                args = string.Format("install -OutputDirectory {0} {1}", PackageDirectory, package);
            }
            else
            {
                exe = "mono";
                args = string.Format("{0} install -OutputDirectory {1} {2}", nugetExe, PackageDirectory, package);
            }

            var pi = new ProcessStartInfo(exe, args)
            {
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false
            };

            try
            {
                using var p = Process.Start(pi);

                if (p is null)
                {
                    progressMonitor.FailedNugetCommand(pi.FileName, pi.Arguments, "Couldn't start process.");
                    return;
                }

                var output = p.StandardOutput.ReadToEnd();
                var error = p.StandardError.ReadToEnd();

                p.WaitForExit();
                if (p.ExitCode != 0)
                {
                    progressMonitor.FailedNugetCommand(pi.FileName, pi.Arguments, output + error);
                }
            }
            catch (Exception ex)
                when (ex is System.ComponentModel.Win32Exception || ex is FileNotFoundException)
            {
                progressMonitor.FailedNugetCommand(pi.FileName, pi.Arguments, ex.Message);
            }
        }

        /// <summary>
        /// Download the packages to the temp folder.
        /// </summary>
        public void InstallPackages()
        {
            foreach (var package in PackageFiles)
            {
                RestoreNugetPackage(package.FullName);
            }
        }
    }
}
