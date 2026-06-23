using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal interface IPackagesConfigRestore
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
    /// It is worth noting that for macOS and Linux, nuget.exe is used with mono. However, mono is being deprecated and the last GitHub images
    /// to contain mono are:
    /// - Ubuntu 22.04
    /// - macOS 14
    ///
    /// If the packages from the packages.config files are not restored with the packages.config restore functionality below, there is a subsequent
    /// step that still may succeed in restoring the packages without the help of nuget.exe (by attempting to restore using dotnet).
    /// </summary>
    internal class PackagesConfigRestoreFactory
    {
        public static IPackagesConfigRestore Create(FileProvider fileProvider, DependencyDirectory packageDirectory, Semmle.Util.Logging.ILogger logger, FeedManager feedManager, HashSet<string> reachableFeeds)
        {
            if (SystemBuildActions.Instance.IsWindows() || SystemBuildActions.Instance.IsMonoInstalled())
            {
                return new NugetExeWrapper(fileProvider, packageDirectory, logger, feedManager, reachableFeeds);
            }

            return new NoOpPackagesConfig(fileProvider.PackagesConfigs, logger);
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

            private readonly FileProvider fileProvider;

            /// <summary>
            /// The packages directory.
            /// This will be in the user-specified or computed Temp location
            /// so as to not trample the source tree.
            /// </summary>
            private readonly DependencyDirectory packageDirectory;
            private readonly FeedManager feedManager;
            private readonly HashSet<string> reachableFeeds;

            private bool IsWindows => SystemBuildActions.Instance.IsWindows();

            private bool? isDefaultFeedReachable;
            private bool IsDefaultFeedReachable =>
                isDefaultFeedReachable ??= feedManager.IsDefaultFeedReachable();



            /// <summary>
            /// Create the package manager for a specified source tree.
            /// </summary>
            public NugetExeWrapper(FileProvider fileProvider, DependencyDirectory packageDirectory, Semmle.Util.Logging.ILogger logger, FeedManager feedManager, HashSet<string> reachableFeeds)
            {
                this.fileProvider = fileProvider;
                this.packageDirectory = packageDirectory;
                this.logger = logger;
                this.feedManager = feedManager;
                this.reachableFeeds = reachableFeeds;

                if (fileProvider.PackagesConfigs.Count > 0)
                {
                    logger.LogInfo($"Found packages.config files, trying to use nuget.exe for package restore");
                    nugetExe = ResolveNugetExe();
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

                var sourcesArgument = "";
                var feedsToUse = feedManager.FeedsToUse(packagesConfig, reachableFeeds).ToList();
                var useDefaultFeed = feedsToUse.Count == 0 && IsDefaultFeedReachable;

                // Explicitly construct the sources to be used for the restore command if any of the following is true:
                if (feedManager.CheckNugetFeedResponsiveness || feedManager.HasPrivateRegistryFeeds || useDefaultFeed)
                {
                    if (useDefaultFeed)
                    {
                        feedsToUse.Add(FeedManager.PublicNugetOrgFeed);
                    }
                    sourcesArgument = feedManager.FeedsToRestoreArgument(feedsToUse, "-Source");
                }

                /* Use nuget.exe to install a package.
                 * Note that there is a clutch of NuGet assemblies which could be used to
                 * invoke this directly, which would arguably be nicer. However they are
                 * really unwieldy and this solution works for now.
                 */

                string exe, args;
                if (RunWithMono)
                {
                    exe = "mono";
                    args = $"\"{nugetExe}\" install -OutputDirectory \"{packageDirectory}\" {sourcesArgument} \"{packagesConfig}\"";
                }
                else
                {
                    exe = nugetExe!;
                    args = $"install -OutputDirectory \"{packageDirectory}\" {sourcesArgument} \"{packagesConfig}\"";
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
        }

        private class NoOpPackagesConfig : IPackagesConfigRestore
        {
            private readonly Semmle.Util.Logging.ILogger logger;
            private readonly ICollection<string> packagesConfigs;

            public NoOpPackagesConfig(ICollection<string> packagesConfigs, Semmle.Util.Logging.ILogger logger)
            {
                this.packagesConfigs = packagesConfigs;
                this.logger = logger;
            }

            public int PackageCount => packagesConfigs.Count;

            public int InstallPackages()
            {
                if (PackageCount > 0)
                {
                    logger.LogInfo("Found packages.config files, but nuget.exe cannot be used to restore packages on this platform. Skipping restore of packages.config files.");
                }
                return 0;
            }
        }
    }
}
