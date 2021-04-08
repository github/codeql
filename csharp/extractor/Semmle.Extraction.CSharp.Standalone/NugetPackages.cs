using Semmle.Util;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;

namespace Semmle.BuildAnalyser
{
    /// <summary>
    /// Manage the downloading of NuGet packages.
    /// Locates packages in a source tree and downloads all of the
    /// referenced assemblies to a temp folder.
    /// </summary>
    internal class NugetPackages
    {
        /// <summary>
        /// Create the package manager for a specified source tree.
        /// </summary>
        /// <param name="sourceDir">The source directory.</param>
        public NugetPackages(string sourceDir, TemporaryDirectory packageDirectory)
        {
            SourceDirectory = sourceDir;
            PackageDirectory = packageDirectory;

            // Expect nuget.exe to be in a `nuget` directory under the directory containing this exe.
            var currentAssembly = System.Reflection.Assembly.GetExecutingAssembly().Location;
            var directory = Path.GetDirectoryName(currentAssembly);
            if (directory is null)
                throw new FileNotFoundException($"Directory path '{currentAssembly}' of current assembly is null");

            nugetExe = Path.Combine(directory, "nuget", "nuget.exe");

            if (!File.Exists(nugetExe))
                throw new FileNotFoundException(string.Format("NuGet could not be found at {0}", nugetExe));

            packages = new DirectoryInfo(SourceDirectory).
                EnumerateFiles("packages.config", SearchOption.AllDirectories).
                ToArray();
        }

        // List of package files to download.
        private readonly FileInfo[] packages;

        /// <summary>
        /// The list of package files.
        /// </summary>
        public IEnumerable<FileInfo> PackageFiles => packages;

        /// <summary>
        /// Download the packages to the temp folder.
        /// </summary>
        /// <param name="pm">The progress monitor used for reporting errors etc.</param>
        public void InstallPackages(IProgressMonitor pm)
        {
            foreach (var package in packages)
            {
                RestoreNugetPackage(package.FullName, pm);
            }
        }

        /// <summary>
        /// The source directory used.
        /// </summary>
        public string SourceDirectory
        {
            get;
            private set;
        }

        /// <summary>
        /// The computed packages directory.
        /// This will be in the Temp location
        /// so as to not trample the source tree.
        /// </summary>
        public TemporaryDirectory PackageDirectory { get; }

        /// <summary>
        /// Restore all files in a specified package.
        /// </summary>
        /// <param name="package">The package file.</param>
        /// <param name="pm">Where to log progress/errors.</param>
        private void RestoreNugetPackage(string package, IProgressMonitor pm)
        {
            pm.NugetInstall(package);

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
                    pm.FailedNugetCommand(pi.FileName, pi.Arguments, "Couldn't start process.");
                    return;
                }

                var output = p.StandardOutput.ReadToEnd();
                var error = p.StandardError.ReadToEnd();

                p.WaitForExit();
                if (p.ExitCode != 0)
                {
                    pm.FailedNugetCommand(pi.FileName, pi.Arguments, output + error);
                }
            }
            catch (Exception ex)
                when (ex is System.ComponentModel.Win32Exception || ex is FileNotFoundException)
            {
                pm.FailedNugetCommand(pi.FileName, pi.Arguments, ex.Message);
            }
        }

        private readonly string nugetExe;
    }
}
