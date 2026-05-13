using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using NuGet.Versioning;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal sealed partial class NugetPackageRestorer : IDisposable
    {
        internal const string PublicNugetOrgFeed = "https://api.nuget.org/v3/index.json";

        private readonly FileProvider fileProvider;
        private readonly FileContent fileContent;
        private readonly IDotNet dotnet;
        private readonly DependabotProxy? dependabotProxy;
        private readonly IDiagnosticsWriter diagnosticsWriter;
        private readonly DependencyDirectory legacyPackageDirectory;
        private readonly DependencyDirectory missingPackageDirectory;
        private readonly DependencyDirectory emptyPackageDirectory;
        private readonly ILogger logger;
        private readonly ICompilationInfoContainer compilationInfoContainer;
        private readonly bool checkNugetFeedResponsiveness = EnvironmentVariables.GetBooleanOptOut(EnvironmentVariableNames.CheckNugetFeedResponsiveness);
        private readonly ImmutableHashSet<string> privateRegistryFeeds;
        private readonly bool hasPrivateRegistryFeeds;

        public DependencyDirectory PackageDirectory { get; }

        public NugetPackageRestorer(
            FileProvider fileProvider,
            FileContent fileContent,
            IDotNet dotnet,
            DependabotProxy? dependabotProxy,
            IDiagnosticsWriter diagnosticsWriter,
            ILogger logger,
            ICompilationInfoContainer compilationInfoContainer)
        {
            this.fileProvider = fileProvider;
            this.fileContent = fileContent;
            this.dotnet = dotnet;
            this.dependabotProxy = dependabotProxy;
            this.privateRegistryFeeds = dependabotProxy?.RegistryURLs.ToImmutableHashSet() ?? [];
            this.hasPrivateRegistryFeeds = privateRegistryFeeds.Count > 0;
            this.diagnosticsWriter = diagnosticsWriter;
            this.logger = logger;
            this.compilationInfoContainer = compilationInfoContainer;

            PackageDirectory = new DependencyDirectory("packages", "package", logger);
            legacyPackageDirectory = new DependencyDirectory("legacypackages", "legacy package", logger);
            missingPackageDirectory = new DependencyDirectory("missingpackages", "missing package", logger);
            emptyPackageDirectory = new DependencyDirectory("empty", "empty package", logger);
        }

        public string? TryRestore(string package)
        {
            if (TryRestorePackageManually(package))
            {
                var packageDir = DependencyManager.GetPackageDirectory(package, missingPackageDirectory.DirInfo);
                if (packageDir is not null)
                {
                    return GetNewestNugetPackageVersionFolder(packageDir, package);
                }
            }

            return null;
        }

        public string GetNewestNugetPackageVersionFolder(string packagePath, string packageFriendlyName)
        {
            var versionFolders = GetOrderedPackageVersionSubDirectories(packagePath);
            if (versionFolders.Length > 1)
            {
                var versions = string.Join(", ", versionFolders.Select(d => d.Name));
                logger.LogDebug($"Found multiple {packageFriendlyName} DLLs in NuGet packages at {packagePath}. Using the latest version ({versionFolders[0].Name}) from: {versions}.");
            }

            var selectedFrameworkFolder = versionFolders.FirstOrDefault()?.FullName;
            if (selectedFrameworkFolder is null)
            {
                logger.LogDebug($"Found {packageFriendlyName} DLLs in NuGet packages at {packagePath}, but no version folder was found.");
                selectedFrameworkFolder = packagePath;
            }

            logger.LogDebug($"Found {packageFriendlyName} DLLs in NuGet packages at {selectedFrameworkFolder}.");
            return selectedFrameworkFolder;
        }

        public DirectoryInfo[] GetOrderedPackageVersionSubDirectories(string packagePath)
        {
            // Only consider directories with valid NuGet version names.
            return new DirectoryInfo(packagePath)
                .EnumerateDirectories("*", new EnumerationOptions { MatchCasing = MatchCasing.CaseInsensitive, RecurseSubdirectories = false })
                .SelectMany(d =>
                {
                    if (NuGetVersion.TryParse(d.Name, out var version))
                    {
                        return new[] { new { Directory = d, NuGetVersion = version } };
                    }
                    logger.LogInfo($"Ignoring package directory '{d.FullName}' as it does not have a valid NuGet version name.");
                    return [];
                })
                .OrderByDescending(dw => dw.NuGetVersion)
                .Select(dw => dw.Directory)
                .ToArray();
        }

        public HashSet<AssemblyLookupLocation> Restore()
        {
            var assemblyLookupLocations = new HashSet<AssemblyLookupLocation>();
            logger.LogInfo($"Checking NuGet feed responsiveness: {checkNugetFeedResponsiveness}");
            compilationInfoContainer.CompilationInfos.Add(("NuGet feed responsiveness checked", checkNugetFeedResponsiveness ? "1" : "0"));

            HashSet<string> explicitFeeds = [];
            HashSet<string> reachableFeeds = [];

            try
            {
                // Find feeds that are configured in NuGet.config files and divide them into ones that
                // are explicitly configured for the project or by a private registry, and "all feeds"
                // (including inherited ones) from other locations on the host outside of the working directory.
                (explicitFeeds, var allFeeds) = GetAllFeeds();

                if (checkNugetFeedResponsiveness)
                {
                    var inheritedFeeds = allFeeds.Except(explicitFeeds).ToHashSet();

                    if (inheritedFeeds.Count > 0)
                    {
                        compilationInfoContainer.CompilationInfos.Add(("Inherited NuGet feed count", inheritedFeeds.Count.ToString()));
                    }

                    var timeout = CheckSpecifiedFeeds(explicitFeeds, out var reachableExplicitFeeds);
                    reachableFeeds.UnionWith(reachableExplicitFeeds);

                    var allExplicitReachable = explicitFeeds.Count == reachableExplicitFeeds.Count;
                    EmitUnreachableFeedsDiagnostics(allExplicitReachable);

                    if (timeout)
                    {
                        // If we experience a timeout, we use this fallback.
                        // todo: we could also check the reachability of the inherited nuget feeds, but to use those in the fallback we would need to handle authentication too.
                        var unresponsiveMissingPackageLocation = DownloadMissingPackagesFromSpecificFeeds([], explicitFeeds);
                        return unresponsiveMissingPackageLocation is null
                            ? []
                            : [unresponsiveMissingPackageLocation];
                    }

                    // Inherited feeds should only be used, if they are indeed reachable (as they may be environment specific).
                    CheckSpecifiedFeeds(inheritedFeeds, out var reachableInheritedFeeds);
                    reachableFeeds.UnionWith(reachableInheritedFeeds);
                }

                using (var nuget = new NugetExeWrapper(fileProvider, legacyPackageDirectory, logger, IsDefaultFeedReachable))
                {
                    var count = nuget.InstallPackages();

                    if (nuget.PackageCount > 0)
                    {
                        compilationInfoContainer.CompilationInfos.Add(("packages.config files", nuget.PackageCount.ToString()));
                        compilationInfoContainer.CompilationInfos.Add(("Successfully restored packages.config files", count.ToString()));
                    }
                }

                var nugetPackageDlls = legacyPackageDirectory.DirInfo.GetFiles("*.dll", new EnumerationOptions { RecurseSubdirectories = true });
                var nugetPackageDllPaths = nugetPackageDlls.Select(f => f.FullName).ToHashSet();
                var excludedPaths = nugetPackageDllPaths
                    .Where(path => IsPathInSubfolder(path, legacyPackageDirectory.DirInfo.FullName, "tools"))
                    .ToList();

                if (nugetPackageDllPaths.Count > 0)
                {
                    logger.LogInfo($"Restored {nugetPackageDllPaths.Count} NuGet DLLs.");
                }
                if (excludedPaths.Count > 0)
                {
                    logger.LogInfo($"Excluding {excludedPaths.Count} NuGet DLLs.");
                }

                foreach (var excludedPath in excludedPaths)
                {
                    logger.LogInfo($"Excluded NuGet DLL: {excludedPath}");
                }

                nugetPackageDllPaths.ExceptWith(excludedPaths);
                assemblyLookupLocations.UnionWith(nugetPackageDllPaths.Select(p => new AssemblyLookupLocation(p)));
            }
            catch (Exception exc)
            {
                logger.LogError($"Failed to restore NuGet packages with nuget.exe: {exc.Message}");
            }

            // Restore project dependencies with `dotnet restore`.
            var restoredProjects = RestoreSolutions(reachableFeeds, out var container);
            var projects = fileProvider.Projects.Except(restoredProjects);
            RestoreProjects(projects, reachableFeeds, out var containers);

            var dependencies = containers.Flatten(container);

            var paths = dependencies
                .Paths
                .Select(d => Path.Combine(PackageDirectory.DirInfo.FullName, d))
                .ToList();
            assemblyLookupLocations.UnionWith(paths.Select(p => new AssemblyLookupLocation(p)));

            var usedPackageNames = GetAllUsedPackageDirNames(dependencies);

            var missingPackageLocation = checkNugetFeedResponsiveness
                ? DownloadMissingPackagesFromSpecificFeeds(usedPackageNames, explicitFeeds)
                : DownloadMissingPackages(usedPackageNames);

            if (missingPackageLocation is not null)
            {
                assemblyLookupLocations.Add(missingPackageLocation);
            }
            return assemblyLookupLocations;
        }

        /// <summary>
        /// Tests which of the feeds given by <paramref name="feedsToCheck"/> are reachable.
        /// </summary>
        /// <param name="feedsToCheck">The feeds to check.</param>
        /// <param name="isFallback">Whether the feeds are fallback feeds or not.</param>
        /// <param name="isTimeout">Whether a timeout occurred while checking the feeds.</param>
        /// <returns>The list of feeds that could be reached.</returns>
        private List<string> GetReachableNuGetFeeds(HashSet<string> feedsToCheck, bool isFallback, out bool isTimeout)
        {
            var fallbackStr = isFallback ? "fallback " : "";
            logger.LogInfo($"Checking {fallbackStr}NuGet feed reachability on feeds: {string.Join(", ", feedsToCheck.OrderBy(f => f))}");

            var (initialTimeout, tryCount) = GetFeedRequestSettings(isFallback);
            var timeout = false;
            var reachableFeeds = feedsToCheck
                .Where(feed =>
                {
                    var reachable = IsFeedReachable(feed, initialTimeout, tryCount, out var feedTimeout);
                    timeout |= feedTimeout;
                    return reachable;
                })
                .ToList();

            if (reachableFeeds.Count == 0)
            {
                logger.LogWarning($"No {fallbackStr}NuGet feeds are reachable.");
            }
            else
            {
                logger.LogInfo($"Reachable {fallbackStr}NuGet feeds: {string.Join(", ", reachableFeeds.OrderBy(f => f))}");
            }

            isTimeout = timeout;
            return reachableFeeds;
        }

        private bool IsDefaultFeedReachable()
        {
            if (checkNugetFeedResponsiveness)
            {
                var (initialTimeout, tryCount) = GetFeedRequestSettings(isFallback: false);
                return IsFeedReachable(PublicNugetOrgFeed, initialTimeout, tryCount, out var _);
            }

            return true;
        }

        private List<string> GetReachableFallbackNugetFeeds(HashSet<string>? feedsFromNugetConfigs)
        {
            var fallbackFeeds = EnvironmentVariables.GetURLs(EnvironmentVariableNames.FallbackNugetFeeds).ToHashSet();
            if (fallbackFeeds.Count == 0)
            {
                fallbackFeeds.Add(PublicNugetOrgFeed);
                logger.LogInfo($"No fallback NuGet feeds specified. Adding default feed: {PublicNugetOrgFeed}");

                var shouldAddNugetConfigFeeds = EnvironmentVariables.GetBooleanOptOut(EnvironmentVariableNames.AddNugetConfigFeedsToFallback);
                logger.LogInfo($"Adding feeds from nuget.config to fallback restore: {shouldAddNugetConfigFeeds}");

                if (shouldAddNugetConfigFeeds && feedsFromNugetConfigs?.Count > 0)
                {
                    // There are some feeds in `feedsFromNugetConfigs` that have already been checked for reachability, we could skip those.
                    // But we might use different responsiveness testing settings when we try them in the fallback logic, so checking them again is safer.
                    fallbackFeeds.UnionWith(feedsFromNugetConfigs);
                    logger.LogInfo($"Using NuGet feeds from nuget.config files as fallback feeds: {string.Join(", ", feedsFromNugetConfigs.OrderBy(f => f))}");
                }
            }

            var reachableFallbackFeeds = GetReachableNuGetFeeds(fallbackFeeds, isFallback: true, out var _);

            compilationInfoContainer.CompilationInfos.Add(("Reachable fallback NuGet feed count", reachableFallbackFeeds.Count.ToString()));

            return reachableFallbackFeeds;
        }

        /// <summary>
        /// Executes `dotnet restore` on all solution files in solutions.
        /// As opposed to RestoreProjects this is not run in parallel using PLINQ
        /// as `dotnet restore` on a solution already uses multiple threads for restoring
        /// the projects (this can be disabled with the `--disable-parallel` flag).
        /// Populates dependencies with the relevant dependencies from the assets files generated by the restore.
        /// Returns a list of projects that are up to date with respect to restore.
        /// </summary>
        private IEnumerable<string> RestoreSolutions(HashSet<string> reachableFeeds, out DependencyContainer dependencies)
        {
            var successCount = 0;
            var nugetSourceFailures = 0;
            var nugetMissingPackageFailures = 0;

            var assets = new Assets(logger);

            var isWindows = fileContent.UseWindowsForms || fileContent.UseWpf;

            var projects = fileProvider.Solutions.SelectMany(solution =>
                {
                    logger.LogInfo($"Restoring solution {solution}...");
                    var nugetSources = MakeRestoreSourcesArgument(solution, reachableFeeds);
                    var res = dotnet.Restore(new(solution, PackageDirectory.DirInfo.FullName, ForceDotnetRefAssemblyFetching: true, NugetSources: nugetSources, TargetWindows: isWindows));
                    if (res.Success)
                    {
                        successCount++;
                    }
                    if (res.HasNugetPackageSourceError)
                    {
                        nugetSourceFailures++;
                    }
                    if (res.HasNugetPackageMissingError)
                    {
                        nugetMissingPackageFailures++;
                    }
                    assets.AddDependenciesRange(res.AssetsFilePaths);
                    return res.RestoredProjects;
                }).ToList();
            dependencies = assets.Dependencies;
            compilationInfoContainer.CompilationInfos.Add(("Successfully restored solution files", successCount.ToString()));
            compilationInfoContainer.CompilationInfos.Add(("Failed solution restore with package source error", nugetSourceFailures.ToString()));
            compilationInfoContainer.CompilationInfos.Add(("Failed solution restore with missing package error", nugetMissingPackageFailures.ToString()));
            compilationInfoContainer.CompilationInfos.Add(("Restored projects through solution files", projects.Count.ToString()));
            return projects;
        }

        private string FeedsToRestoreArgument(IEnumerable<string> feeds)
        {
            // If there are no feeds, we want to override any default feeds that `dotnet restore` would use by passing a dummy source argument.
            if (!feeds.Any())
            {
                return $" -s \"{emptyPackageDirectory.DirInfo.FullName}\"";
            }

            // Add package sources. If any are present, they override all sources specified in
            // the configuration file(s).
            var feedArgs = new StringBuilder();
            foreach (var feed in feeds)
            {
                feedArgs.Append($" -s \"{feed}\"");
            }

            return feedArgs.ToString();
        }

        /// <summary>
        /// Constructs the list of NuGet sources to use for this restore.
        /// (1) Use the feeds we get from `dotnet nuget list source`
        /// (2) Use private registries, if they are configured
        /// </summary>
        /// <param name="path">Path to project/solution</param>
        /// <param name="reachableFeeds">The set of reachable NuGet feeds.</param>
        /// <returns>A string representing the NuGet sources argument for the restore command.</returns>
        private string? MakeRestoreSourcesArgument(string path, HashSet<string> reachableFeeds)
        {
            // Do not construct an set of explicit NuGet sources to use for restore.
            if (!checkNugetFeedResponsiveness && !hasPrivateRegistryFeeds)
            {
                return null;
            }

            // Find the path specific feeds.
            var folder = GetDirectoryName(path);
            var feedsToConsider = folder is not null ? GetFeeds(() => dotnet.GetNugetFeedsFromFolder(folder)).ToHashSet() : [];

            if (hasPrivateRegistryFeeds)
            {
                feedsToConsider.UnionWith(privateRegistryFeeds);
            }

            var feedsToUse = checkNugetFeedResponsiveness
                ? feedsToConsider.Where(reachableFeeds.Contains)
                : feedsToConsider;

            return FeedsToRestoreArgument(feedsToUse);
        }

        /// <summary>
        /// Executes `dotnet restore` on all projects in projects.
        /// This is done in parallel for performance reasons.
        /// Populates dependencies with the relative paths to the assets files generated by the restore.
        /// </summary>
        /// <param name="projects">A list of paths to project files.</param>
        /// <param name="reachableFeeds">The set of reachable NuGet feeds.</param>
        private void RestoreProjects(IEnumerable<string> projects, HashSet<string> reachableFeeds, out ConcurrentBag<DependencyContainer> dependencies)
        {
            var successCount = 0;
            var nugetSourceFailures = 0;
            var nugetMissingPackageFailures = 0;
            ConcurrentBag<DependencyContainer> collectedDependencies = [];

            var isWindows = fileContent.UseWindowsForms || fileContent.UseWpf;

            var sync = new Lock();
            var projectGroups = projects.GroupBy(Path.GetDirectoryName);
            Parallel.ForEach(projectGroups, new ParallelOptions { MaxDegreeOfParallelism = DependencyManager.Threads }, projectGroup =>
            {
                var assets = new Assets(logger);
                foreach (var project in projectGroup)
                {
                    logger.LogInfo($"Restoring project {project}...");
                    var nugetSources = MakeRestoreSourcesArgument(project, reachableFeeds);
                    var res = dotnet.Restore(new(project, PackageDirectory.DirInfo.FullName, ForceDotnetRefAssemblyFetching: true, NugetSources: nugetSources, TargetWindows: isWindows));
                    assets.AddDependenciesRange(res.AssetsFilePaths);
                    lock (sync)
                    {
                        if (res.Success)
                        {
                            successCount++;
                        }
                        if (res.HasNugetPackageSourceError)
                        {
                            nugetSourceFailures++;
                        }
                        if (res.HasNugetPackageMissingError)
                        {
                            nugetMissingPackageFailures++;
                        }
                    }
                }
                collectedDependencies.Add(assets.Dependencies);
            });
            dependencies = collectedDependencies;
            compilationInfoContainer.CompilationInfos.Add(("Successfully restored project files", successCount.ToString()));
            compilationInfoContainer.CompilationInfos.Add(("Failed project restore with package source error", nugetSourceFailures.ToString()));
            compilationInfoContainer.CompilationInfos.Add(("Failed project restore with missing package error", nugetMissingPackageFailures.ToString()));
        }

        private AssemblyLookupLocation? DownloadMissingPackagesFromSpecificFeeds(IEnumerable<string> usedPackageNames, HashSet<string>? feedsFromNugetConfigs)
        {
            var reachableFallbackFeeds = GetReachableFallbackNugetFeeds(feedsFromNugetConfigs);
            if (reachableFallbackFeeds.Count > 0)
            {
                return DownloadMissingPackages(usedPackageNames, fallbackNugetFeeds: reachableFallbackFeeds);
            }

            logger.LogWarning("Skipping download of missing packages from specific feeds as no fallback NuGet feeds are reachable.");
            return null;
        }

        private AssemblyLookupLocation? DownloadMissingPackages(IEnumerable<string> usedPackageNames, IEnumerable<string>? fallbackNugetFeeds = null)
        {
            var alreadyDownloadedPackages = usedPackageNames.Select(p => p.ToLowerInvariant());
            var alreadyDownloadedLegacyPackages = GetRestoredLegacyPackageNames();

            var notYetDownloadedPackages = new HashSet<PackageReference>(fileContent.AllPackages);
            foreach (var alreadyDownloadedPackage in alreadyDownloadedPackages)
            {
                notYetDownloadedPackages.Remove(new(alreadyDownloadedPackage, PackageReferenceSource.SdkCsProj));
            }
            foreach (var alreadyDownloadedLegacyPackage in alreadyDownloadedLegacyPackages)
            {
                notYetDownloadedPackages.Remove(new(alreadyDownloadedLegacyPackage, PackageReferenceSource.PackagesConfig));
            }

            if (notYetDownloadedPackages.Count == 0)
            {
                return null;
            }

            var multipleVersions = notYetDownloadedPackages
                .GroupBy(p => p.Name)
                .Where(g => g.Count() > 1)
                .Select(g => g.Key)
                .ToList();

            foreach (var package in multipleVersions)
            {
                logger.LogWarning($"Found multiple not yet restored packages with name '{package}'.");
                notYetDownloadedPackages.Remove(new(package, PackageReferenceSource.PackagesConfig));
            }

            logger.LogInfo($"Found {notYetDownloadedPackages.Count} packages that are not yet restored");
            using var tempDir = new TemporaryDirectory(ComputeTempDirectoryPath("nugetconfig"), "generated nuget config", logger);
            var nugetConfig = fallbackNugetFeeds is null
                ? GetNugetConfig()
                : CreateFallbackNugetConfig(fallbackNugetFeeds, tempDir.DirInfo.FullName);

            compilationInfoContainer.CompilationInfos.Add(("Fallback nuget restore", notYetDownloadedPackages.Count.ToString()));

            var successCount = 0;
            var sync = new Lock();

            Parallel.ForEach(notYetDownloadedPackages, new ParallelOptions { MaxDegreeOfParallelism = DependencyManager.Threads }, package =>
            {
                var success = TryRestorePackageManually(package.Name, nugetConfig, package.PackageReferenceSource, tryWithoutNugetConfig: fallbackNugetFeeds is null);
                if (!success)
                {
                    return;
                }

                lock (sync)
                {
                    successCount++;
                }
            });

            compilationInfoContainer.CompilationInfos.Add(("Successfully ran fallback nuget restore", successCount.ToString()));

            return missingPackageDirectory.DirInfo.FullName;
        }

        private string? CreateFallbackNugetConfig(IEnumerable<string> fallbackNugetFeeds, string folderPath)
        {
            var sb = new StringBuilder();
            fallbackNugetFeeds.ForEach((feed, index) => sb.AppendLine($"<add key=\"feed{index}\" value=\"{feed}\" />"));

            var nugetConfigPath = Path.Combine(folderPath, "nuget.config");
            logger.LogInfo($"Creating fallback nuget.config file {nugetConfigPath}.");
            File.WriteAllText(nugetConfigPath,
                $"""
                <?xml version="1.0" encoding="utf-8"?>
                <configuration>
                    <packageSources>
                        <clear />
                {sb}
                    </packageSources>
                </configuration>
                """);

            return nugetConfigPath;
        }

        private string? GetNugetConfig()
        {
            var nugetConfigs = fileProvider.NugetConfigs;
            string? nugetConfig;
            if (nugetConfigs.Count > 1)
            {
                logger.LogInfo($"Found multiple nuget.config files: {string.Join(", ", nugetConfigs)}.");
                nugetConfig = fileProvider.RootNugetConfig;
                if (nugetConfig == null)
                {
                    logger.LogInfo("Could not find a top-level nuget.config file.");
                }
            }
            else
            {
                nugetConfig = nugetConfigs.FirstOrDefault();
            }

            if (nugetConfig != null)
            {
                logger.LogInfo($"Using nuget.config file {nugetConfig}.");
            }

            return nugetConfig;
        }

        private IEnumerable<string> GetAllUsedPackageDirNames(DependencyContainer dependencies)
        {
            var allPackageDirectories = GetAllPackageDirectories();

            logger.LogInfo($"Restored {allPackageDirectories.Count} packages");
            logger.LogInfo($"Found {dependencies.Packages.Count} packages in project.assets.json files");

            var usage = allPackageDirectories.Select(package => (package, isUsed: dependencies.Packages.Contains(package)));

            usage
                .Where(package => !package.isUsed)
                .Order()
                .ForEach(package => logger.LogDebug($"Unused package: {package.package}"));

            return usage
                .Where(package => package.isUsed)
                .Select(package => package.package);
        }

        private ICollection<string> GetAllPackageDirectories()
        {
            return new DirectoryInfo(PackageDirectory.DirInfo.FullName)
                .EnumerateDirectories("*", new EnumerationOptions { MatchCasing = MatchCasing.CaseInsensitive, RecurseSubdirectories = false })
                .Select(d => d.Name)
                .ToList();
        }

        private static bool IsPathInSubfolder(string path, string rootFolder, string subFolder)
        {
            return path.IndexOf(
                $"{Path.DirectorySeparatorChar}{subFolder}{Path.DirectorySeparatorChar}",
                rootFolder.Length,
                StringComparison.InvariantCultureIgnoreCase) >= 0;
        }

        private IEnumerable<string> GetRestoredLegacyPackageNames()
        {
            var oldPackageDirectories = GetRestoredPackageDirectoryNames(legacyPackageDirectory.DirInfo);
            foreach (var oldPackageDirectory in oldPackageDirectories)
            {
                // nuget install restores packages to 'packagename.version' folders (dotnet restore to 'packagename/version' folders)
                // typical folder names look like:
                //   newtonsoft.json.13.0.3
                // there are more complex ones too, such as:
                //   runtime.tizen.4.0.0-armel.Microsoft.NETCore.DotNetHostResolver.2.0.0-preview2-25407-01

                var match = LegacyNugetPackage().Match(oldPackageDirectory);
                if (!match.Success)
                {
                    logger.LogWarning($"Package directory '{oldPackageDirectory}' doesn't match the expected pattern.");
                    continue;
                }

                yield return match.Groups[1].Value.ToLowerInvariant();
            }
        }

        private static IEnumerable<string> GetRestoredPackageDirectoryNames(DirectoryInfo root)
        {
            return Directory.GetDirectories(root.FullName)
                .Select(d => Path.GetFileName(d).ToLowerInvariant());
        }

        private bool TryRestorePackageManually(string package, string? nugetConfig = null, PackageReferenceSource packageReferenceSource = PackageReferenceSource.SdkCsProj,
            bool tryWithoutNugetConfig = true, bool tryPrereleaseVersion = true)
        {
            logger.LogInfo($"Restoring package {package}...");
            using var tempDir = new TemporaryDirectory(
                ComputeTempDirectoryPath(package, "missingpackages_workingdir"), "missing package working", logger);
            var success = dotnet.New(tempDir.DirInfo.FullName);
            if (!success)
            {
                return false;
            }

            if (packageReferenceSource == PackageReferenceSource.PackagesConfig)
            {
                TryChangeTargetFrameworkMoniker(tempDir.DirInfo);
            }

            success = dotnet.AddPackage(tempDir.DirInfo.FullName, package);
            if (!success)
            {
                return false;
            }

            var res = TryRestorePackageManually(package, nugetConfig, tempDir, tryPrereleaseVersion);
            if (res.Success)
            {
                return true;
            }

            if (tryWithoutNugetConfig && res.HasNugetPackageSourceError && nugetConfig is not null)
            {
                logger.LogDebug($"Trying to restore '{package}' without nuget.config.");
                // Restore could not be completed because the listed source is unavailable. Try without the nuget.config:
                res = TryRestorePackageManually(package, nugetConfig: null, tempDir, tryPrereleaseVersion);
                if (res.Success)
                {
                    return true;
                }
            }

            logger.LogInfo($"Failed to restore nuget package {package}");
            return false;
        }

        private RestoreResult TryRestorePackageManually(string package, string? nugetConfig, TemporaryDirectory tempDir, bool tryPrereleaseVersion)
        {
            var res = dotnet.Restore(new(tempDir.DirInfo.FullName, missingPackageDirectory.DirInfo.FullName, ForceDotnetRefAssemblyFetching: false, PathToNugetConfig: nugetConfig, ForceReevaluation: true));

            if (!res.Success && tryPrereleaseVersion && res.HasNugetNoStablePackageVersionError)
            {
                logger.LogDebug($"Failed to restore nuget package {package} because no stable version was found.");
                TryChangePackageVersion(tempDir.DirInfo, "*-*");

                res = dotnet.Restore(new(tempDir.DirInfo.FullName, missingPackageDirectory.DirInfo.FullName, ForceDotnetRefAssemblyFetching: false, PathToNugetConfig: nugetConfig, ForceReevaluation: true));
                if (!res.Success)
                {
                    TryChangePackageVersion(tempDir.DirInfo, "*");
                }
            }

            return res;
        }

        private void TryChangeTargetFrameworkMoniker(DirectoryInfo tempDir)
        {
            TryChangeProjectFile(tempDir, TargetFramework(), $"<TargetFramework>{FrameworkPackageNames.LatestNetFrameworkMoniker}</TargetFramework>", "target framework moniker");
        }

        private void TryChangePackageVersion(DirectoryInfo tempDir, string newVersion)
        {
            TryChangeProjectFile(tempDir, PackageReferenceVersion(), $"Version=\"{newVersion}\"", "package reference version");
        }

        private void TryChangeProjectFile(DirectoryInfo projectDir, Regex pattern, string replacement, string patternName)
        {
            try
            {
                logger.LogDebug($"Changing the {patternName} in {projectDir.FullName}...");

                var csprojs = projectDir.GetFiles("*.csproj", new EnumerationOptions { RecurseSubdirectories = false, MatchCasing = MatchCasing.CaseInsensitive });
                if (csprojs.Length != 1)
                {
                    logger.LogError($"Could not find the .csproj file in {projectDir.FullName}, count = {csprojs.Length}");
                    return;
                }

                var csproj = csprojs[0];
                var content = File.ReadAllText(csproj.FullName);
                var matches = pattern.Matches(content);
                if (matches.Count == 0)
                {
                    logger.LogError($"Could not find the {patternName} in {csproj.FullName}");
                    return;
                }

                content = pattern.Replace(content, replacement, 1);
                File.WriteAllText(csproj.FullName, content);
            }
            catch (Exception exc)
            {
                logger.LogError($"Failed to change the {patternName} in {projectDir.FullName}: {exc}");
            }
        }

        private static async Task<HttpResponseMessage> ExecuteGetRequest(string address, HttpClient httpClient, CancellationToken cancellationToken)
        {
            return await httpClient.GetAsync(address, HttpCompletionOption.ResponseHeadersRead, cancellationToken);
        }

        private bool IsFeedReachable(string feed, int timeoutMilliSeconds, int tryCount, out bool isTimeout)
        {
            logger.LogInfo($"Checking if NuGet feed '{feed}' is reachable...");

            // Configure the HttpClient to be aware of the Dependabot Proxy, if used.
            HttpClientHandler httpClientHandler = new();
            if (dependabotProxy != null)
            {
                httpClientHandler.Proxy = new WebProxy(dependabotProxy.Address);

                if (dependabotProxy.Certificate != null)
                {
                    httpClientHandler.ServerCertificateCustomValidationCallback = (message, cert, chain, _) =>
                    {
                        if (chain is null || cert is null)
                        {
                            var msg = cert is null && chain is null
                                ? "certificate and chain"
                                : chain is null
                                    ? "chain"
                                    : "certificate";
                            logger.LogWarning($"Dependabot proxy certificate validation failed due to missing {msg}");
                            return false;
                        }
                        chain.ChainPolicy.TrustMode = X509ChainTrustMode.CustomRootTrust;
                        chain.ChainPolicy.CustomTrustStore.Add(dependabotProxy.Certificate);
                        return chain.Build(cert);
                    };
                }
            }

            using HttpClient client = new(httpClientHandler);

            isTimeout = false;

            for (var i = 0; i < tryCount; i++)
            {
                using var cts = new CancellationTokenSource();
                cts.CancelAfter(timeoutMilliSeconds);
                try
                {
                    logger.LogInfo($"Attempt {i + 1}/{tryCount} to reach NuGet feed '{feed}'.");
                    using var response = ExecuteGetRequest(feed, client, cts.Token).GetAwaiter().GetResult();
                    response.EnsureSuccessStatusCode();
                    logger.LogInfo($"Querying NuGet feed '{feed}' succeeded.");
                    return true;
                }
                catch (Exception exc)
                {
                    if (exc is TaskCanceledException tce &&
                        tce.CancellationToken == cts.Token &&
                        cts.Token.IsCancellationRequested)
                    {
                        logger.LogInfo($"Didn't receive answer from NuGet feed '{feed}' in {timeoutMilliSeconds}ms.");
                        timeoutMilliSeconds *= 2;
                        continue;
                    }

                    logger.LogInfo($"Querying NuGet feed '{feed}' failed. The reason for the failure: {exc.Message}");
                    return false;
                }
            }

            logger.LogWarning($"Didn't receive answer from NuGet feed '{feed}'. Tried it {tryCount} times.");
            isTimeout = true;
            return false;
        }

        private (int initialTimeout, int tryCount) GetFeedRequestSettings(bool isFallback)
        {
            int timeoutMilliSeconds = isFallback && int.TryParse(Environment.GetEnvironmentVariable(EnvironmentVariableNames.NugetFeedResponsivenessInitialTimeoutForFallback), out timeoutMilliSeconds)
                ? timeoutMilliSeconds
                : int.TryParse(Environment.GetEnvironmentVariable(EnvironmentVariableNames.NugetFeedResponsivenessInitialTimeout), out timeoutMilliSeconds)
                    ? timeoutMilliSeconds
                    : 1000;
            logger.LogDebug($"Initial timeout for NuGet feed reachability check is {timeoutMilliSeconds}ms.");

            int tryCount = isFallback && int.TryParse(Environment.GetEnvironmentVariable(EnvironmentVariableNames.NugetFeedResponsivenessRequestCountForFallback), out tryCount)
                ? tryCount
                : int.TryParse(Environment.GetEnvironmentVariable(EnvironmentVariableNames.NugetFeedResponsivenessRequestCount), out tryCount)
                    ? tryCount
                    : 4;
            logger.LogDebug($"Number of tries for NuGet feed reachability check is {tryCount}.");

            return (timeoutMilliSeconds, tryCount);
        }

        /// <summary>
        /// Retrieves a list of excluded NuGet feeds from the corresponding environment variable.
        /// </summary>
        private HashSet<string> GetExcludedFeeds()
        {
            var excludedFeeds = EnvironmentVariables.GetURLs(EnvironmentVariableNames.ExcludedNugetFeedsFromResponsivenessCheck)
                .ToHashSet();

            if (excludedFeeds.Count > 0)
            {
                logger.LogInfo($"Excluded NuGet feeds from responsiveness check: {string.Join(", ", excludedFeeds.OrderBy(f => f))}");
            }

            return excludedFeeds;
        }

        /// <summary>
        /// Checks that we can connect to the specified NuGet feeds.
        /// </summary>
        /// <param name="feeds">The set of package feeds to check.</param>
        /// <param name="reachableFeeds">The list of feeds that were reachable.</param>
        /// <returns>
        /// True if there is a timeout when trying to reach the feeds (excluding any feeds that are configured
        /// to be excluded from the check) or false otherwise.
        /// </returns>
        private bool CheckSpecifiedFeeds(HashSet<string> feeds, out HashSet<string> reachableFeeds)
        {
            // Exclude any feeds from the feed check that are configured by the corresponding environment variable.
            // These feeds are always assumed to be reachable.
            var excludedFeeds = GetExcludedFeeds();

            HashSet<string> feedsToCheck = feeds.Where(feed =>
            {
                if (excludedFeeds.Contains(feed))
                {
                    logger.LogInfo($"Not checking reachability of NuGet feed '{feed}' as it is in the list of excluded feeds.");
                    return false;
                }
                return true;
            }).ToHashSet();

            reachableFeeds = GetReachableNuGetFeeds(feedsToCheck, isFallback: false, out var isTimeout).ToHashSet();

            // Always consider feeds excluded for the reachability check as reachable.
            reachableFeeds.UnionWith(feeds.Where(feed => excludedFeeds.Contains(feed)));

            return isTimeout;
        }

        /// <summary>
        /// If <paramref name="allFeedsReachable"/> is `false`, logs this and emits a diagnostic.
        /// Adds a `CompilationInfos` entry either way.
        /// </summary>
        /// <param name="allFeedsReachable">Whether all feeds were reachable or not.</param>
        private void EmitUnreachableFeedsDiagnostics(bool allFeedsReachable)
        {
            if (!allFeedsReachable)
            {
                logger.LogWarning("Found unreachable NuGet feed in C# analysis with build-mode 'none'. This may cause missing dependencies in the analysis.");
                diagnosticsWriter.AddEntry(new DiagnosticMessage(
                    Language.CSharp,
                    "buildless/unreachable-feed",
                    "Found unreachable NuGet feed in C# analysis with build-mode 'none'",
                    visibility: new DiagnosticMessage.TspVisibility(statusPage: true, cliSummaryTable: true, telemetry: true),
                    markdownMessage: "Found unreachable NuGet feed in C# analysis with build-mode 'none'. This may cause missing dependencies in the analysis.",
                    severity: DiagnosticMessage.TspSeverity.Note
                ));
            }
            compilationInfoContainer.CompilationInfos.Add(("All NuGet feeds reachable", allFeedsReachable ? "1" : "0"));
        }

        private IEnumerable<string> GetFeeds(Func<IList<string>> getNugetFeeds)
        {
            var results = getNugetFeeds();
            var regex = EnabledNugetFeed();
            foreach (var result in results)
            {
                var match = regex.Match(result);
                if (!match.Success)
                {
                    logger.LogError($"Failed to parse feed from '{result}'");
                    continue;
                }

                var url = match.Groups[1].Value;
                if (!url.StartsWith("https://", StringComparison.InvariantCultureIgnoreCase) &&
                    !url.StartsWith("http://", StringComparison.InvariantCultureIgnoreCase))
                {
                    logger.LogInfo($"Skipping feed '{url}' as it is not a valid URL.");
                    continue;
                }

                if (!string.IsNullOrWhiteSpace(url))
                {
                    yield return url;
                }
            }
        }

        private string? GetDirectoryName(string path)
        {
            try
            {
                return new FileInfo(path).Directory?.FullName;
            }
            catch (Exception exc)
            {
                logger.LogWarning($"Failed to get directory of '{path}': {exc}");
            }
            return null;
        }

        private (HashSet<string> explicitFeeds, HashSet<string> allFeeds) GetAllFeeds()
        {
            var nugetConfigs = fileProvider.NugetConfigs;

            // On systems with case-sensitive file systems (for simplicity, we assume that is Linux), the
            // filenames of NuGet configuration files must be named correctly. For compatibility with projects
            // that are typically built on Windows or macOS where this doesn't matter, we accept all variants
            // of `nuget.config` ourselves. However, `dotnet` does not. If we detect that incorrectly-named
            // files are present, we emit a diagnostic to warn the user.
            if (SystemBuildActions.Instance.IsLinux())
            {
                string[] acceptedNugetConfigNames = ["nuget.config", "NuGet.config", "NuGet.Config"];
                var invalidNugetConfigs = nugetConfigs
                    .Where(path => !acceptedNugetConfigNames.Contains(Path.GetFileName(path)));

                if (invalidNugetConfigs.Count() > 0)
                {
                    logger.LogWarning(string.Format(
                        "Found incorrectly named NuGet configuration files: {0}",
                        string.Join(", ", invalidNugetConfigs)
                    ));
                    diagnosticsWriter.AddEntry(new DiagnosticMessage(
                        Language.CSharp,
                        "buildless/case-sensitive-nuget-config",
                        "Found NuGet configuration files which are not correctly named",
                        visibility: new DiagnosticMessage.TspVisibility(statusPage: true, cliSummaryTable: true, telemetry: true),
                        markdownMessage: string.Format(
                            "On platforms with case-sensitive file systems, NuGet only accepts files with one of the following names: {0}.\n\n" +
                            "CodeQL found the following files while performing an analysis on a platform with a case-sensitive file system:\n\n" +
                            "{1}\n\n" +
                            "To avoid unexpected results, rename these files to match the casing of one of the accepted filenames.",
                            string.Join(", ", acceptedNugetConfigNames),
                            string.Join("\n", invalidNugetConfigs.Select(path => string.Format("- `{0}`", path)))
                        ),
                        severity: DiagnosticMessage.TspSeverity.Warning
                    ));
                }
            }

            // Find feeds that are explicitly configured in the NuGet configuration files that we found.
            var explicitFeeds = nugetConfigs
                .SelectMany(config => GetFeeds(() => dotnet.GetNugetFeeds(config)))
                .ToHashSet();

            if (explicitFeeds.Count > 0)
            {
                logger.LogInfo($"Found {explicitFeeds.Count} NuGet feeds in nuget.config files: {string.Join(", ", explicitFeeds.OrderBy(f => f))}");
            }
            else
            {
                logger.LogDebug("No NuGet feeds found in nuget.config files.");
            }

            // If private package registries are configured for C#, then consider those
            // in addition to the ones that are configured in `nuget.config` files.
            if (hasPrivateRegistryFeeds)
            {
                logger.LogInfo($"Found {privateRegistryFeeds.Count} private registry feeds configured for C#: {string.Join(", ", privateRegistryFeeds.OrderBy(f => f))}");
                explicitFeeds.UnionWith(privateRegistryFeeds);
            }

            HashSet<string> allFeeds = [];

            // Add all explicitFeeds to the set of all feeds.
            allFeeds.UnionWith(explicitFeeds);

            // Obtain the list of feeds from the root source directory.
            // If a NuGet file is present it will be respected, otherwise we will just get the machine/environment specific feeds.
            var nugetFeedsFromRoot = GetFeeds(() => dotnet.GetNugetFeedsFromFolder(fileProvider.SourceDir.FullName));
            allFeeds.UnionWith(nugetFeedsFromRoot);

            if (nugetConfigs.Count > 0)
            {
                var nugetConfigFeeds = nugetConfigs
                    .Select(GetDirectoryName)
                    .Where(folder => folder != null)
                    .SelectMany(folder => GetFeeds(() => dotnet.GetNugetFeedsFromFolder(folder!)))
                    .ToHashSet();

                allFeeds.UnionWith(nugetConfigFeeds);
            }

            logger.LogInfo($"Found {allFeeds.Count} NuGet feeds (with inherited ones) in nuget.config files: {string.Join(", ", allFeeds.OrderBy(f => f))}");

            return (explicitFeeds, allFeeds);
        }

        [GeneratedRegex(@"<TargetFramework>.*</TargetFramework>", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex TargetFramework();

        [GeneratedRegex(@"Version=""(\*|\*-\*)""", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex PackageReferenceVersion();

        [GeneratedRegex(@"^(.+)\.(\d+\.\d+\.\d+(-(.+))?)$", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex LegacyNugetPackage();

        [GeneratedRegex(@"^E\s(.*)$", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex EnabledNugetFeed();

        public void Dispose()
        {
            PackageDirectory?.Dispose();
            legacyPackageDirectory?.Dispose();
            missingPackageDirectory?.Dispose();
            emptyPackageDirectory?.Dispose();
        }

        /// <summary>
        /// Returns the full path to a temporary directory with the given subfolder name.
        /// </summary>
        private static string ComputeTempDirectoryPath(string subfolderName)
        {
            return Path.Combine(FileUtils.GetTemporaryWorkingDirectory(out _), subfolderName);
        }

        /// <summary>
        /// Computes a unique temporary directory path based on the source directory and the subfolder name.
        /// </summary>
        private static string ComputeTempDirectoryPath(string srcDir, string subfolderName)
        {
            return Path.Combine(FileUtils.GetTemporaryWorkingDirectory(out _), FileUtils.ComputeHash(srcDir), subfolderName);
        }
    }
}
