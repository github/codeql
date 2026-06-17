using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal interface IPackagesConfigRestore : IDisposable
    {
        /// <summary>
        /// The number of packages.config files found in the source tree.
        /// </summary>
        int PackageCount { get; }

        /// <summary>
        /// Download the packages to the temp folder.
        /// </summary>
        int InstallPackages();
    }

    /// <summary>
    /// Factory for creating a package manager to restore NuGet packages referenced in packages.config files.
    /// If the environment doesn't support using nuget.exe to restore packages from packages.config files, a no-op implementation is returned.
    /// It is worth noting that for MacOS and Linux, nuget.exe is used with mono. However, mono is being deprecated and the last images to contain
    /// mono are
    /// - Ubuntu 22.04
    /// - MacOS 14
    /// 
    /// It is worth noting that even with the removal of mono, the content of the packages.config files are parsed and added to the packages list in
    /// the FileContent implementation. If the packages are not restored in this step, there is a subsequent step that still may succeed in
    /// restoring the packages, albeit without the help of nuget.exe.
    /// </summary>
    internal class PackagesConfigRestoreFactory
    {
        public static IPackagesConfigRestore Create(FileProvider fileProvider, DependencyDirectory packageDirectory, Semmle.Util.Logging.ILogger logger, Func<bool> useDefaultFeed)
        {
            if (SystemBuildActions.Instance.IsWindows() || SystemBuildActions.Instance.IsMonoInstalled())
            {
                return new NugetExeWrapper(fileProvider, packageDirectory, logger, useDefaultFeed);
            }

            return new NoOpPackagesConfig(fileProvider, logger);
        }

        /// <summary>
        /// Manage the downloading of NuGet packages with nuget.exe.
        /// Locates packages in a source tree and downloads all of the
        /// referenced assemblies to a temp folder.
        /// </summary>
        private class NugetExeWrapper : IPackagesConfigRestore
        {
            private readonly string? nugetExe;
            private readonly Semmle.Util.Logging.ILogger logger;

            public int PackageCount => fileProvider.PackagesConfigs.Count;

            private readonly string? backupNugetConfig;
            private readonly string? nugetConfigPath;
            private readonly FileProvider fileProvider;

            /// <summary>
            /// The packages directory.
            /// This will be in the user-specified or computed Temp location
            /// so as to not trample the source tree.
            /// </summary>
            private readonly DependencyDirectory packageDirectory;

            private bool IsWindows => SystemBuildActions.Instance.IsWindows();

            /// <summary>
            /// Create the package manager for a specified source tree.
            /// </summary>
            public NugetExeWrapper(FileProvider fileProvider, DependencyDirectory packageDirectory, Semmle.Util.Logging.ILogger logger, Func<bool> useDefaultFeed)
            {
                this.fileProvider = fileProvider;
                this.packageDirectory = packageDirectory;
                this.logger = logger;

                if (fileProvider.PackagesConfigs.Count > 0)
                {
                    logger.LogInfo($"Found packages.config files, trying to use nuget.exe for package restore");
                    nugetExe = ResolveNugetExe();
                    if (!HasPackageSource() && useDefaultFeed())
                    {
                        // We only modify or add a top level nuget.config file
                        nugetConfigPath = Path.Join(fileProvider.SourceDir.FullName, "nuget.config");
                        try
                        {
                            if (File.Exists(nugetConfigPath))
                            {
                                var tempFolderPath = FileUtils.GetTemporaryWorkingDirectory(out _);

                                do
                                {
                                    backupNugetConfig = Path.Join(tempFolderPath, Path.GetRandomFileName());
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
            /// Tries to find the location of `nuget.exe`. It looks for
            /// - the environment variable specifying a location,
            /// - files in the repository,
            /// - tries to resolve nuget from the PATH, or
            /// - downloads it if it is not found.
            /// </summary>
            private string ResolveNugetExe()
            {
                var envVarPath = Environment.GetEnvironmentVariable(EnvironmentVariableNames.NugetExePath);
                if (!string.IsNullOrEmpty(envVarPath))
                {
                    logger.LogInfo($"Using nuget.exe from environment variable: '{envVarPath}'");
                    return envVarPath;
                }

                try
                {
                    return DownloadNugetExe(fileProvider.SourceDir.FullName);
                }
                catch (Exception exc)
                {
                    logger.LogInfo($"Download of nuget.exe failed: {exc.Message}");
                }

                var nugetExesInRepo = fileProvider.NugetExes;
                if (nugetExesInRepo.Count > 1)
                {
                    logger.LogInfo($"Found multiple nuget.exe files in the repository: {string.Join(", ", nugetExesInRepo.OrderBy(s => s))}");
                }

                if (nugetExesInRepo.Count > 0)
                {
                    var path = nugetExesInRepo.First();
                    logger.LogInfo($"Using nuget.exe from path '{path}'");
                    return path;
                }

                var executableName = IsWindows ? "nuget.exe" : "nuget";
                var nugetPath = FileUtils.FindProgramOnPath(executableName);
                if (nugetPath is not null)
                {
                    nugetPath = Path.Join(nugetPath, executableName);
                    logger.LogInfo($"Using nuget.exe from PATH: {nugetPath}");
                    return nugetPath;
                }

                throw new Exception("Could not find or download nuget.exe.");
            }

            private string DownloadNugetExe(string sourceDir)
            {
                var directory = Path.Join(sourceDir, ".nuget");
                var nuget = Path.Join(directory, "nuget.exe");

                // Nuget.exe already exists in the .nuget directory.
                if (File.Exists(nuget))
                {
                    logger.LogInfo($"Found nuget.exe at {nuget}");
                    return nuget;
                }

                Directory.CreateDirectory(directory);
                logger.LogInfo("Attempting to download nuget.exe");
                FileUtils.DownloadFile(FileUtils.NugetExeUrl, nuget, logger);
                logger.LogInfo($"Downloaded nuget.exe to {nuget}");
                return nuget;
            }

            private bool RunWithMono => !IsWindows && !string.IsNullOrEmpty(Path.GetExtension(nugetExe));

            /// <summary>
            /// Restore all packages in the specified packages.config file.
            /// </summary>
            /// <param name="packagesConfig">The packages.config file.</param>
            private bool TryRestoreNugetPackage(string packagesConfig)
            {
                logger.LogInfo($"Restoring file \"{packagesConfig}\"...");

                /* Use nuget.exe to install a package.
                 * Note that there is a clutch of NuGet assemblies which could be used to
                 * invoke this directly, which would arguably be nicer. However they are
                 * really unwieldy and this solution works for now.
                 */

                string exe, args;
                if (RunWithMono)
                {
                    exe = "mono";
                    args = $"\"{nugetExe}\" install -OutputDirectory \"{packageDirectory}\" \"{packagesConfig}\"";
                }
                else
                {
                    exe = nugetExe!;
                    args = $"install -OutputDirectory \"{packageDirectory}\" \"{packagesConfig}\"";
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
                var exitCode = pi.ReadOutput(out _, onOut, onError);
                if (exitCode != 0)
                {
                    logger.LogError($"Command {pi.FileName} {pi.Arguments} failed with exit code {exitCode}");
                    return false;
                }
                else
                {
                    logger.LogInfo($"Restored file \"{packagesConfig}\"");
                    return true;
                }
            }

            /// <summary>
            /// Download the packages to the temp folder.
            /// </summary>
            public int InstallPackages()
            {
                return fileProvider.PackagesConfigs.Count(TryRestoreNugetPackage);
            }

            private bool HasPackageSource()
            {
                if (IsWindows)
                {
                    return true;
                }

                try
                {
                    logger.LogInfo("Checking if default package source is available...");
                    RunMonoNugetCommand("sources list -ForceEnglishOutput", out var stdout);
                    if (stdout.All(line => line != "No sources found."))
                    {
                        return true;
                    }

                    return false;
                }
                catch (Exception e)
                {
                    logger.LogWarning($"Failed to check if default package source is added: {e}");
                    return true;
                }
            }

            private void RunMonoNugetCommand(string command, out IList<string> stdout)
            {
                string exe, args;
                if (RunWithMono)
                {
                    exe = "mono";
                    args = $"\"{nugetExe}\" {command}";
                }
                else
                {
                    exe = nugetExe!;
                    args = command;
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
                pi.ReadOutput(out stdout, onOut, onError);
            }

            private void AddDefaultPackageSource(string nugetConfig)
            {
                logger.LogInfo("Adding default package source...");
                RunMonoNugetCommand($"sources add -Name DefaultNugetOrg -Source {NugetPackageRestorer.PublicNugetOrgFeed} -ConfigFile \"{nugetConfig}\"", out _);
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

        private class NoOpPackagesConfig : IPackagesConfigRestore
        {
            private readonly Semmle.Util.Logging.ILogger logger;
            private readonly FileProvider fileProvider;

            public NoOpPackagesConfig(FileProvider fileProvider, Semmle.Util.Logging.ILogger logger)
            {
                this.fileProvider = fileProvider;
                this.logger = logger;
            }

            public int PackageCount => fileProvider.PackagesConfigs.Count;

            public int InstallPackages()
            {
                if (PackageCount > 0)
                {
                    logger.LogInfo("Found packages.config files, but nuget.exe cannot be used to restore packages on this platform. Skipping restore of packages.config files.");
                }
                return 0;
            }

            public void Dispose() { }
        }
    }
}
