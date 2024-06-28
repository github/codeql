using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
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
        private readonly IDiagnosticsWriter diagnosticsWriter;
        private readonly TemporaryDirectory legacyPackageDirectory;
        private readonly TemporaryDirectory missingPackageDirectory;
        private readonly ILogger logger;
        private readonly ICompilationInfoContainer compilationInfoContainer;

        public TemporaryDirectory PackageDirectory { get; }

        public NugetPackageRestorer(
            FileProvider fileProvider,
            FileContent fileContent,
            IDotNet dotnet,
            IDiagnosticsWriter diagnosticsWriter,
            ILogger logger,
            ICompilationInfoContainer compilationInfoContainer)
        {
            this.fileProvider = fileProvider;
            this.fileContent = fileContent;
            this.dotnet = dotnet;
            this.diagnosticsWriter = diagnosticsWriter;
            this.logger = logger;
            this.compilationInfoContainer = compilationInfoContainer;

            PackageDirectory = new TemporaryDirectory(ComputeTempDirectoryPath(fileProvider.SourceDir.FullName, "packages"), "package", logger);
            legacyPackageDirectory = new TemporaryDirectory(ComputeTempDirectoryPath(fileProvider.SourceDir.FullName, "legacypackages"), "legacy package", logger);
            missingPackageDirectory = new TemporaryDirectory(ComputeTempDirectoryPath(fileProvider.SourceDir.FullName, "missingpackages"), "missing package", logger);
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

        public static DirectoryInfo[] GetOrderedPackageVersionSubDirectories(string packagePath)
        {
            return new DirectoryInfo(packagePath)
                .EnumerateDirectories("*", new EnumerationOptions { MatchCasing = MatchCasing.CaseInsensitive, RecurseSubdirectories = false })
                .OrderByDescending(d => d.Name) // TODO: Improve sorting to handle pre-release versions.
                .ToArray();
        }

        public HashSet<AssemblyLookupLocation> Restore()
        {
            var assemblyLookupLocations = new HashSet<AssemblyLookupLocation>();
            var checkNugetFeedResponsiveness = EnvironmentVariables.GetBooleanOptOut(EnvironmentVariableNames.CheckNugetFeedResponsiveness);
            logger.LogInfo($"Checking NuGet feed responsiveness: {checkNugetFeedResponsiveness}");
            compilationInfoContainer.CompilationInfos.Add(("NuGet feed responsiveness checked", checkNugetFeedResponsiveness ? "1" : "0"));

            HashSet<string>? explicitFeeds = null;

            try
            {
                if (checkNugetFeedResponsiveness && !CheckFeeds(out explicitFeeds))
                {
                    // todo: we could also check the reachability of the inherited nuget feeds, but to use those in the fallback we would need to handle authentication too.
                    var unresponsiveMissingPackageLocation = DownloadMissingPackagesFromSpecificFeeds(explicitFeeds);
                    return unresponsiveMissingPackageLocation is null
                        ? []
                        : [unresponsiveMissingPackageLocation];
                }

                using (var nuget = new NugetExeWrapper(fileProvider, legacyPackageDirectory, logger))
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
                    logger.LogInfo($"Restored {nugetPackageDllPaths.Count} Nuget DLLs.");
                }
                if (excludedPaths.Count > 0)
                {
                    logger.LogInfo($"Excluding {excludedPaths.Count} Nuget DLLs.");
                }

                foreach (var excludedPath in excludedPaths)
                {
                    logger.LogInfo($"Excluded Nuget DLL: {excludedPath}");
                }

                nugetPackageDllPaths.ExceptWith(excludedPaths);
                assemblyLookupLocations.UnionWith(nugetPackageDllPaths.Select(p => new AssemblyLookupLocation(p)));
            }
            catch (Exception exc)
            {
                logger.LogError($"Failed to restore Nuget packages with nuget.exe: {exc.Message}");
            }

            var restoredProjects = RestoreSolutions(out var container);
            var projects = fileProvider.Projects.Except(restoredProjects);
            RestoreProjects(projects, out var containers);

            var dependencies = containers.Flatten(container);

            var paths = dependencies
                .Paths
                .Select(d => Path.Combine(PackageDirectory.DirInfo.FullName, d))
                .ToList();
            assemblyLookupLocations.UnionWith(paths.Select(p => new AssemblyLookupLocation(p)));

            LogAllUnusedPackages(dependencies);

            var missingPackageLocation = checkNugetFeedResponsiveness
                ? DownloadMissingPackagesFromSpecificFeeds(explicitFeeds)
                : DownloadMissingPackages();

            if (missingPackageLocation is not null)
            {
                assemblyLookupLocations.Add(missingPackageLocation);
            }
            return assemblyLookupLocations;
        }

        private List<string> GetReachableFallbackNugetFeeds(HashSet<string>? feedsFromNugetConfigs)
        {
            var fallbackFeeds = EnvironmentVariables.GetURLs(EnvironmentVariableNames.FallbackNugetFeeds).ToHashSet();
            if (fallbackFeeds.Count == 0)
            {
                fallbackFeeds.Add(PublicNugetOrgFeed);
                logger.LogInfo($"No fallback Nuget feeds specified. Adding default feed: {PublicNugetOrgFeed}");

                var shouldAddNugetConfigFeeds = EnvironmentVariables.GetBooleanOptOut(EnvironmentVariableNames.AddNugetConfigFeedsToFallback);
                logger.LogInfo($"Adding feeds from nuget.config to fallback restore: {shouldAddNugetConfigFeeds}");

                if (shouldAddNugetConfigFeeds && feedsFromNugetConfigs?.Count > 0)
                {
                    // There are some feeds in `feedsFromNugetConfigs` that have already been checked for reachability, we could skip those.
                    // But we might use different responsiveness testing settings when we try them in the fallback logic, so checking them again is safer.
                    fallbackFeeds.UnionWith(feedsFromNugetConfigs);
                    logger.LogInfo($"Using Nuget feeds from nuget.config files as fallback feeds: {string.Join(", ", feedsFromNugetConfigs.OrderBy(f => f))}");
                }
            }

            logger.LogInfo($"Checking fallback Nuget feed reachability on feeds: {string.Join(", ", fallbackFeeds.OrderBy(f => f))}");
            var (initialTimeout, tryCount) = GetFeedRequestSettings(isFallback: true);
            var reachableFallbackFeeds = fallbackFeeds.Where(feed => IsFeedReachable(feed, initialTimeout, tryCount, allowExceptions: false)).ToList();
            if (reachableFallbackFeeds.Count == 0)
            {
                logger.LogWarning("No fallback Nuget feeds are reachable.");
            }
            else
            {
                logger.LogInfo($"Reachable fallback Nuget feeds: {string.Join(", ", reachableFallbackFeeds.OrderBy(f => f))}");
            }

            compilationInfoContainer.CompilationInfos.Add(("Reachable fallback Nuget feed count", reachableFallbackFeeds.Count.ToString()));

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
        private IEnumerable<string> RestoreSolutions(out DependencyContainer dependencies)
        {
            var successCount = 0;
            var nugetSourceFailures = 0;
            var assets = new Assets(logger);
            var projects = fileProvider.Solutions.SelectMany(solution =>
                {
                    logger.LogInfo($"Restoring solution {solution}...");
                    var res = dotnet.Restore(new(solution, PackageDirectory.DirInfo.FullName, ForceDotnetRefAssemblyFetching: true));
                    if (res.Success)
                    {
                        successCount++;
                    }
                    if (res.HasNugetPackageSourceError)
                    {
                        nugetSourceFailures++;
                    }
                    assets.AddDependenciesRange(res.AssetsFilePaths);
                    return res.RestoredProjects;
                }).ToList();
            dependencies = assets.Dependencies;
            compilationInfoContainer.CompilationInfos.Add(("Successfully restored solution files", successCount.ToString()));
            compilationInfoContainer.CompilationInfos.Add(("Failed solution restore with package source error", nugetSourceFailures.ToString()));
            compilationInfoContainer.CompilationInfos.Add(("Restored projects through solution files", projects.Count.ToString()));
            return projects;
        }

        /// <summary>
        /// Executes `dotnet restore` on all projects in projects.
        /// This is done in parallel for performance reasons.
        /// Populates dependencies with the relative paths to the assets files generated by the restore.
        /// </summary>
        /// <param name="projects">A list of paths to project files.</param>
        private void RestoreProjects(IEnumerable<string> projects, out ConcurrentBag<DependencyContainer> dependencies)
        {
            var successCount = 0;
            var nugetSourceFailures = 0;
            ConcurrentBag<DependencyContainer> collectedDependencies = [];
            var sync = new object();
            var projectGroups = projects.GroupBy(Path.GetDirectoryName);
            Parallel.ForEach(projectGroups, new ParallelOptions { MaxDegreeOfParallelism = DependencyManager.Threads }, projectGroup =>
            {
                var assets = new Assets(logger);
                foreach (var project in projectGroup)
                {
                    logger.LogInfo($"Restoring project {project}...");
                    var res = dotnet.Restore(new(project, PackageDirectory.DirInfo.FullName, ForceDotnetRefAssemblyFetching: true));
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
                    }
                }
                collectedDependencies.Add(assets.Dependencies);
            });
            dependencies = collectedDependencies;
            compilationInfoContainer.CompilationInfos.Add(("Successfully restored project files", successCount.ToString()));
            compilationInfoContainer.CompilationInfos.Add(("Failed project restore with package source error", nugetSourceFailures.ToString()));
        }

        private AssemblyLookupLocation? DownloadMissingPackagesFromSpecificFeeds(HashSet<string>? feedsFromNugetConfigs)
        {
            var reachableFallbackFeeds = GetReachableFallbackNugetFeeds(feedsFromNugetConfigs);
            if (reachableFallbackFeeds.Count > 0)
            {
                return DownloadMissingPackages(fallbackNugetFeeds: reachableFallbackFeeds);
            }

            logger.LogWarning("Skipping download of missing packages from specific feeds as no fallback Nuget feeds are reachable.");
            return null;
        }

        private AssemblyLookupLocation? DownloadMissingPackages(IEnumerable<string>? fallbackNugetFeeds = null)
        {
            var alreadyDownloadedPackages = GetRestoredPackageDirectoryNames(PackageDirectory.DirInfo);
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
            using var tempDir = new TemporaryDirectory(ComputeTempDirectoryPath(fileProvider.SourceDir.FullName, "nugetconfig"), "generated nuget config", logger);
            var nugetConfig = fallbackNugetFeeds is null
                ? GetNugetConfig()
                : CreateFallbackNugetConfig(fallbackNugetFeeds, tempDir.DirInfo.FullName);

            compilationInfoContainer.CompilationInfos.Add(("Fallback nuget restore", notYetDownloadedPackages.Count.ToString()));

            var successCount = 0;
            var sync = new object();

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

        private void LogAllUnusedPackages(DependencyContainer dependencies)
        {
            var allPackageDirectories = GetAllPackageDirectories();

            logger.LogInfo($"Restored {allPackageDirectories.Count} packages");
            logger.LogInfo($"Found {dependencies.Packages.Count} packages in project.assets.json files");

            allPackageDirectories
                .Where(package => !dependencies.Packages.Contains(package))
                .Order()
                .ForEach(package => logger.LogDebug($"Unused package: {package}"));
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

        private static async Task ExecuteGetRequest(string address, HttpClient httpClient, CancellationToken cancellationToken)
        {
            using var stream = await httpClient.GetStreamAsync(address, cancellationToken);
            var buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = stream.Read(buffer, 0, buffer.Length)) > 0)
            {
                // do nothing
            }
        }

        private bool IsFeedReachable(string feed, int timeoutMilliSeconds, int tryCount, bool allowExceptions = true)
        {
            logger.LogInfo($"Checking if Nuget feed '{feed}' is reachable...");
            using HttpClient client = new();

            for (var i = 0; i < tryCount; i++)
            {
                using var cts = new CancellationTokenSource();
                cts.CancelAfter(timeoutMilliSeconds);
                try
                {
                    ExecuteGetRequest(feed, client, cts.Token).GetAwaiter().GetResult();
                    logger.LogInfo($"Querying Nuget feed '{feed}' succeeded.");
                    return true;
                }
                catch (Exception exc)
                {
                    if (exc is TaskCanceledException tce &&
                        tce.CancellationToken == cts.Token &&
                        cts.Token.IsCancellationRequested)
                    {
                        logger.LogInfo($"Didn't receive answer from Nuget feed '{feed}' in {timeoutMilliSeconds}ms.");
                        timeoutMilliSeconds *= 2;
                        continue;
                    }

                    // We're only interested in timeouts.
                    var start = allowExceptions ? "Considering" : "Not considering";
                    logger.LogInfo($"Querying Nuget feed '{feed}' failed in a timely manner. {start} the feed for use. The reason for the failure: {exc.Message}");
                    return allowExceptions;
                }
            }

            logger.LogWarning($"Didn't receive answer from Nuget feed '{feed}'. Tried it {tryCount} times.");
            return false;
        }

        private (int initialTimeout, int tryCount) GetFeedRequestSettings(bool isFallback)
        {
            int timeoutMilliSeconds = isFallback && int.TryParse(Environment.GetEnvironmentVariable(EnvironmentVariableNames.NugetFeedResponsivenessInitialTimeoutForFallback), out timeoutMilliSeconds)
                ? timeoutMilliSeconds
                : int.TryParse(Environment.GetEnvironmentVariable(EnvironmentVariableNames.NugetFeedResponsivenessInitialTimeout), out timeoutMilliSeconds)
                    ? timeoutMilliSeconds
                    : 1000;
            logger.LogDebug($"Initial timeout for Nuget feed reachability check is {timeoutMilliSeconds}ms.");

            int tryCount = isFallback && int.TryParse(Environment.GetEnvironmentVariable(EnvironmentVariableNames.NugetFeedResponsivenessRequestCountForFallback), out tryCount)
                ? tryCount
                : int.TryParse(Environment.GetEnvironmentVariable(EnvironmentVariableNames.NugetFeedResponsivenessRequestCount), out tryCount)
                    ? tryCount
                    : 4;
            logger.LogDebug($"Number of tries for Nuget feed reachability check is {tryCount}.");

            return (timeoutMilliSeconds, tryCount);
        }

        private bool CheckFeeds(out HashSet<string> explicitFeeds)
        {
            logger.LogInfo("Checking Nuget feeds...");
            (explicitFeeds, var allFeeds) = GetAllFeeds();

            var excludedFeeds = EnvironmentVariables.GetURLs(EnvironmentVariableNames.ExcludedNugetFeedsFromResponsivenessCheck)
                .ToHashSet();

            if (excludedFeeds.Count > 0)
            {
                logger.LogInfo($"Excluded Nuget feeds from responsiveness check: {string.Join(", ", excludedFeeds.OrderBy(f => f))}");
            }

            var (initialTimeout, tryCount) = GetFeedRequestSettings(isFallback: false);

            var allFeedsReachable = explicitFeeds.All(feed => excludedFeeds.Contains(feed) || IsFeedReachable(feed, initialTimeout, tryCount));
            if (!allFeedsReachable)
            {
                logger.LogWarning("Found unreachable Nuget feed in C# analysis with build-mode 'none'. This may cause missing dependencies in the analysis.");
                diagnosticsWriter.AddEntry(new DiagnosticMessage(
                    Language.CSharp,
                    "buildless/unreachable-feed",
                    "Found unreachable Nuget feed in C# analysis with build-mode 'none'",
                    visibility: new DiagnosticMessage.TspVisibility(statusPage: true, cliSummaryTable: true, telemetry: true),
                    markdownMessage: "Found unreachable Nuget feed in C# analysis with build-mode 'none'. This may cause missing dependencies in the analysis.",
                    severity: DiagnosticMessage.TspSeverity.Warning
                ));
            }
            compilationInfoContainer.CompilationInfos.Add(("All Nuget feeds reachable", allFeedsReachable ? "1" : "0"));


            var inheritedFeeds = allFeeds.Except(explicitFeeds).ToHashSet();
            if (inheritedFeeds.Count > 0)
            {
                logger.LogInfo($"Inherited Nuget feeds (not checked for reachability): {string.Join(", ", inheritedFeeds.OrderBy(f => f))}");
                compilationInfoContainer.CompilationInfos.Add(("Inherited Nuget feed count", inheritedFeeds.Count.ToString()));
            }

            return allFeedsReachable;
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

        private (HashSet<string> explicitFeeds, HashSet<string> allFeeds) GetAllFeeds()
        {
            var nugetConfigs = fileProvider.NugetConfigs;
            var explicitFeeds = nugetConfigs
                .SelectMany(config => GetFeeds(() => dotnet.GetNugetFeeds(config)))
                .ToHashSet();

            if (explicitFeeds.Count > 0)
            {
                logger.LogInfo($"Found {explicitFeeds.Count} Nuget feeds in nuget.config files: {string.Join(", ", explicitFeeds.OrderBy(f => f))}");
            }
            else
            {
                logger.LogDebug("No Nuget feeds found in nuget.config files.");
            }

            // todo: this could be improved.
            // We don't have to get the feeds from each of the folders from below, it would be enought to check the folders that recursively contain the others.
            var allFeeds = nugetConfigs
                .Select(config =>
                {
                    try
                    {
                        return new FileInfo(config).Directory?.FullName;
                    }
                    catch (Exception exc)
                    {
                        logger.LogWarning($"Failed to get directory of '{config}': {exc}");
                    }
                    return null;
                })
                .Where(folder => folder != null)
                .SelectMany(folder => GetFeeds(() => dotnet.GetNugetFeedsFromFolder(folder!)))
                .ToHashSet();

            logger.LogInfo($"Found {allFeeds.Count} Nuget feeds (with inherited ones) in nuget.config files: {string.Join(", ", allFeeds.OrderBy(f => f))}");

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
        }

        /// <summary>
        /// Computes a unique temp directory for the packages associated
        /// with this source tree. Use a SHA1 of the directory name.
        /// </summary>
        /// <returns>The full path of the temp directory.</returns>
        private static string ComputeTempDirectoryPath(string srcDir, string subfolderName)
        {
            var bytes = Encoding.Unicode.GetBytes(srcDir);
            var sha = SHA1.HashData(bytes);
            var sb = new StringBuilder();
            foreach (var b in sha.Take(8))
                sb.AppendFormat("{0:x2}", b);

            return Path.Combine(FileUtils.GetTemporaryWorkingDirectory(out _), sb.ToString(), subfolderName);
        }
    }
}
