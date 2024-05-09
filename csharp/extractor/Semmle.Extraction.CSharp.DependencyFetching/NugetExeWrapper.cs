using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    /// <summary>
    /// Manage the downloading of NuGet packages with nuget.exe.
    /// Locates packages in a source tree and downloads all of the
    /// referenced assemblies to a temp folder.
    /// </summary>
    internal class NugetExeWrapper : IDisposable
    {
        private readonly string? nugetExe;
        private readonly Util.Logging.ILogger logger;

        /// <summary>
        /// The list of package files.
        /// </summary>
        private readonly ICollection<string> packageFiles;

        public int PackageCount => packageFiles.Count;

        private readonly string? backupNugetConfig;
        private readonly string? nugetConfigPath;

        /// <summary>
        /// The computed packages directory.
        /// This will be in the Temp location
        /// so as to not trample the source tree.
        /// </summary>
        private readonly TemporaryDirectory packageDirectory;

        /// <summary>
        /// Create the package manager for a specified source tree.
        /// </summary>
        public NugetExeWrapper(FileProvider fileProvider, TemporaryDirectory packageDirectory, Util.Logging.ILogger logger)
        {
            this.packageDirectory = packageDirectory;
            this.logger = logger;

            packageFiles = fileProvider.PackagesConfigs;

            if (packageFiles.Count > 0)
            {
                logger.LogInfo($"Found packages.config files, trying to use nuget.exe for package restore");
                nugetExe = ResolveNugetExe(fileProvider.SourceDir.FullName);
                if (HasNoPackageSource())
                {
                    // We only modify or add a top level nuget.config file
                    nugetConfigPath = Path.Combine(fileProvider.SourceDir.FullName, "nuget.config");
                    try
                    {
                        if (File.Exists(nugetConfigPath))
                        {
                            var tempFolderPath = FileUtils.GetTemporaryWorkingDirectory(out var _);

                            do
                            {
                                backupNugetConfig = Path.Combine(tempFolderPath, Path.GetRandomFileName());
                            }
                            while (File.Exists(backupNugetConfig));
                            File.Copy(nugetConfigPath, backupNugetConfig, true);
                        }
                        else
                        {
                            File.WriteAllText(nugetConfigPath,
                                """
                                <?xml version="1.0" encoding="utf-8"?>
                                <configuration>
                                  <packageSources>
                                  </packageSources>
                                </configuration>
                                """);
                        }
                        AddDefaultPackageSource(nugetConfigPath);
                    }
                    catch (Exception e)
                    {
                        logger.LogError($"Failed to add default package source to {nugetConfigPath}: {e}");
                    }
                }
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
        private bool TryRestoreNugetPackage(string package)
        {
            logger.LogInfo($"Restoring file {package}...");

            /* Use nuget.exe to install a package.
             * Note that there is a clutch of NuGet assemblies which could be used to
             * invoke this directly, which would arguably be nicer. However they are
             * really unwieldy and this solution works for now.
             */

            string exe, args;
            if (Win32.IsWindows())
            {
                exe = nugetExe!;
                args = $"install -OutputDirectory {packageDirectory} {package}";
            }
            else
            {
                exe = "mono";
                args = $"{nugetExe} install -OutputDirectory {packageDirectory} {package}";
            }

            var pi = new ProcessStartInfo(exe, args)
            {
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false
            };

            var threadId = Environment.CurrentManagedThreadId;
            void onOut(string s) => logger.LogDebug(s, threadId);
            void onError(string s) => logger.LogError(s, threadId);
            var exitCode = pi.ReadOutput(out var _, onOut, onError);
            if (exitCode != 0)
            {
                logger.LogError($"Command {pi.FileName} {pi.Arguments} failed with exit code {exitCode}");
                return false;
            }
            else
            {
                logger.LogInfo($"Restored file {package}");
                return true;
            }
        }

        /// <summary>
        /// Download the packages to the temp folder.
        /// </summary>
        public int InstallPackages()
        {
            return packageFiles.Count(package => TryRestoreNugetPackage(package));
        }

        private bool HasNoPackageSource()
        {
            if (Win32.IsWindows())
            {
                return false;
            }

            try
            {
                logger.LogInfo("Checking if default package source is available...");
                RunMonoNugetCommand("sources list -ForceEnglishOutput", out var stdout);
                if (stdout.All(line => line != "No sources found."))
                {
                    return false;
                }

                return true;
            }
            catch (Exception e)
            {
                logger.LogWarning($"Failed to check if default package source is added: {e}");
                return false;
            }
        }

        private void RunMonoNugetCommand(string command, out IList<string> stdout)
        {
            var exe = "mono";
            var args = $"{nugetExe} {command}";
            var pi = new ProcessStartInfo(exe, args)
            {
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false
            };

            var threadId = Environment.CurrentManagedThreadId;
            void onOut(string s) => logger.LogDebug(s, threadId);
            void onError(string s) => logger.LogError(s, threadId);
            pi.ReadOutput(out stdout, onOut, onError);
        }

        private void AddDefaultPackageSource(string nugetConfig)
        {
            logger.LogInfo("Adding default package source...");
            RunMonoNugetCommand($"sources add -Name DefaultNugetOrg -Source {NugetPackageRestorer.PublicNugetOrgFeed} -ConfigFile \"{nugetConfig}\"", out var _);
        }

        public void Dispose()
        {
            if (nugetConfigPath is null)
            {
                return;
            }

            try
            {
                if (backupNugetConfig is null)
                {
                    logger.LogInfo("Removing nuget.config file");
                    File.Delete(nugetConfigPath);
                    return;
                }

                logger.LogInfo("Reverting nuget.config file content");
                // The content of the original nuget.config file is reverted without changing the file's attributes or casing:
                using (var backup = File.OpenRead(backupNugetConfig))
                using (var current = File.OpenWrite(nugetConfigPath))
                {
                    current.SetLength(0);   // Truncate file
                    backup.CopyTo(current); // Restore original content
                }

                logger.LogInfo("Deleting backup nuget.config file");
                File.Delete(backupNugetConfig);
            }
            catch (Exception exc)
            {
                logger.LogError($"Failed to restore original nuget.config file: {exc}");
            }
        }
    }
}
