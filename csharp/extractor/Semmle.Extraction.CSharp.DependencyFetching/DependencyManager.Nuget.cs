using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    public sealed partial class DependencyManager
    {
        private void RestoreNugetPackages(List<FileInfo> allNonBinaryFiles, IEnumerable<string> allProjects, IEnumerable<string> allSolutions, HashSet<AssemblyLookupLocation> dllLocations)
        {
            var checkNugetFeedResponsiveness = EnvironmentVariables.GetBoolean(EnvironmentVariableNames.CheckNugetFeedResponsiveness);
            try
            {
                if (checkNugetFeedResponsiveness && !CheckFeeds(allNonBinaryFiles))
                {
                    // todo: we could also check the reachability of the inherited nuget feeds, but to use those in the fallback we would need to handle authentication too.
                    DownloadMissingPackagesFromSpecificFeeds(allNonBinaryFiles, dllLocations);
                    return;
                }

                using (var nuget = new NugetPackages(sourceDir.FullName, legacyPackageDirectory, logger))
                {
                    var count = nuget.InstallPackages();

                    if (nuget.PackageCount > 0)
                    {
                        CompilationInfos.Add(("packages.config files", nuget.PackageCount.ToString()));
                        CompilationInfos.Add(("Successfully restored packages.config files", count.ToString()));
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
                dllLocations.UnionWith(nugetPackageDllPaths.Select(p => new AssemblyLookupLocation(p)));
            }
            catch (Exception exc)
            {
                logger.LogError($"Failed to restore Nuget packages with nuget.exe: {exc.Message}");
            }

            var restoredProjects = RestoreSolutions(allSolutions, out var assets1);
            var projects = allProjects.Except(restoredProjects);
            RestoreProjects(projects, out var assets2);

            var dependencies = Assets.GetCompilationDependencies(logger, assets1.Union(assets2));

            var paths = dependencies
                .Paths
                .Select(d => Path.Combine(packageDirectory.DirInfo.FullName, d))
                .ToList();
            dllLocations.UnionWith(paths.Select(p => new AssemblyLookupLocation(p)));

            LogAllUnusedPackages(dependencies);

            if (checkNugetFeedResponsiveness)
            {
                DownloadMissingPackagesFromSpecificFeeds(allNonBinaryFiles, dllLocations);
            }
            else
            {
                DownloadMissingPackages(allNonBinaryFiles, dllLocations);
            }
        }

        internal const string PublicNugetFeed = "https://api.nuget.org/v3/index.json";

        private List<string> GetReachableFallbackNugetFeeds()
        {
            var fallbackFeeds = EnvironmentVariables.GetURLs(EnvironmentVariableNames.FallbackNugetFeeds).ToHashSet();
            if (fallbackFeeds.Count == 0)
            {
                fallbackFeeds.Add(PublicNugetFeed);
            }

            logger.LogInfo($"Checking fallback Nuget feed reachability on feeds:  {string.Join(", ", fallbackFeeds.OrderBy(f => f))}");
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

            return reachableFallbackFeeds;
        }

        /// <summary>
        /// Executes `dotnet restore` on all solution files in solutions.
        /// As opposed to RestoreProjects this is not run in parallel using PLINQ
        /// as `dotnet restore` on a solution already uses multiple threads for restoring
        /// the projects (this can be disabled with the `--disable-parallel` flag).
        /// Populates assets with the relative paths to the assets files generated by the restore.
        /// Returns a list of projects that are up to date with respect to restore.
        /// </summary>
        /// <param name="solutions">A list of paths to solution files.</param>
        private IEnumerable<string> RestoreSolutions(IEnumerable<string> solutions, out IEnumerable<string> assets)
        {
            var successCount = 0;
            var nugetSourceFailures = 0;
            var assetFiles = new List<string>();
            var projects = solutions.SelectMany(solution =>
                {
                    logger.LogInfo($"Restoring solution {solution}...");
                    var res = dotnet.Restore(new(solution, packageDirectory.DirInfo.FullName, ForceDotnetRefAssemblyFetching: true));
                    if (res.Success)
                    {
                        successCount++;
                    }
                    if (res.HasNugetPackageSourceError)
                    {
                        nugetSourceFailures++;
                    }
                    assetFiles.AddRange(res.AssetsFilePaths);
                    return res.RestoredProjects;
                }).ToList();
            assets = assetFiles;
            CompilationInfos.Add(("Successfully restored solution files", successCount.ToString()));
            CompilationInfos.Add(("Failed solution restore with package source error", nugetSourceFailures.ToString()));
            CompilationInfos.Add(("Restored projects through solution files", projects.Count.ToString()));
            return projects;
        }

        /// <summary>
        /// Executes `dotnet restore` on all projects in projects.
        /// This is done in parallel for performance reasons.
        /// Populates assets with the relative paths to the assets files generated by the restore.
        /// </summary>
        /// <param name="projects">A list of paths to project files.</param>
        private void RestoreProjects(IEnumerable<string> projects, out IEnumerable<string> assets)
        {
            var successCount = 0;
            var nugetSourceFailures = 0;
            var assetFiles = new List<string>();
            var sync = new object();
            Parallel.ForEach(projects, new ParallelOptions { MaxDegreeOfParallelism = threads }, project =>
            {
                logger.LogInfo($"Restoring project {project}...");
                var res = dotnet.Restore(new(project, packageDirectory.DirInfo.FullName, ForceDotnetRefAssemblyFetching: true));
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
                    assetFiles.AddRange(res.AssetsFilePaths);
                }
            });
            assets = assetFiles;
            CompilationInfos.Add(("Successfully restored project files", successCount.ToString()));
            CompilationInfos.Add(("Failed project restore with package source error", nugetSourceFailures.ToString()));
        }

        private void DownloadMissingPackagesFromSpecificFeeds(List<FileInfo> allNonBinaryFiles, HashSet<AssemblyLookupLocation> dllLocations)
        {
            var reachableFallbackFeeds = GetReachableFallbackNugetFeeds();
            if (reachableFallbackFeeds.Count > 0)
            {
                DownloadMissingPackages(allNonBinaryFiles, dllLocations, withNugetConfigFromSrc: false, fallbackNugetFeeds: reachableFallbackFeeds);
            }
            else
            {
                logger.LogWarning("Skipping download of missing packages from specific feeds as no fallback Nuget feeds are reachable.");
            }
        }

        private void DownloadMissingPackages(List<FileInfo> allFiles, HashSet<AssemblyLookupLocation> dllLocations, bool withNugetConfigFromSrc = true, IEnumerable<string>? fallbackNugetFeeds = null)
        {
            var alreadyDownloadedPackages = GetRestoredPackageDirectoryNames(packageDirectory.DirInfo);
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
                return;
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
            using var tempDir = new TemporaryDirectory(ComputeTempDirectory(sourceDir.FullName, "nugetconfig"));
            var nugetConfig = withNugetConfigFromSrc
                ? GetNugetConfig(allFiles)
                : CreateFallbackNugetConfig(fallbackNugetFeeds, tempDir.DirInfo.FullName);

            CompilationInfos.Add(("Fallback nuget restore", notYetDownloadedPackages.Count.ToString()));

            var successCount = 0;
            var sync = new object();

            Parallel.ForEach(notYetDownloadedPackages, new ParallelOptions { MaxDegreeOfParallelism = threads }, package =>
            {
                var success = TryRestorePackageManually(package.Name, nugetConfig, package.PackageReferenceSource, tryWithoutNugetConfig: withNugetConfigFromSrc);
                if (!success)
                {
                    return;
                }

                lock (sync)
                {
                    successCount++;
                }
            });

            CompilationInfos.Add(("Successfully ran fallback nuget restore", successCount.ToString()));

            dllLocations.Add(missingPackageDirectory.DirInfo.FullName);
        }

        private string? CreateFallbackNugetConfig(IEnumerable<string>? fallbackNugetFeeds, string folderPath)
        {
            if (fallbackNugetFeeds is null)
            {
                // We're not overriding the inherited Nuget feeds
                logger.LogInfo("No fallback Nuget feeds provided. Not creating a fallback nuget.config file.");
                return null;
            }

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

        private string[] GetAllNugetConfigs(List<FileInfo> allFiles) => allFiles.SelectFileNamesByName("nuget.config").ToArray();

        private string? GetNugetConfig(List<FileInfo> allFiles)
        {
            var nugetConfigs = GetAllNugetConfigs(allFiles);
            string? nugetConfig;
            if (nugetConfigs.Length > 1)
            {
                logger.LogInfo($"Found multiple nuget.config files: {string.Join(", ", nugetConfigs)}.");
                nugetConfig = allFiles
                    .SelectRootFiles(sourceDir)
                    .SelectFileNamesByName("nuget.config")
                    .FirstOrDefault();
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
                .ForEach(package => logger.LogInfo($"Unused package: {package}"));
        }


        private ICollection<string> GetAllPackageDirectories()
        {
            return new DirectoryInfo(packageDirectory.DirInfo.FullName)
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

        private bool TryRestorePackageManually(string package, string? nugetConfig = null, PackageReferenceSource packageReferenceSource = PackageReferenceSource.SdkCsProj, bool tryWithoutNugetConfig = true)
        {
            logger.LogInfo($"Restoring package {package}...");
            using var tempDir = new TemporaryDirectory(ComputeTempDirectory(package, "missingpackages_workingdir"));
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

            var res = dotnet.Restore(new(tempDir.DirInfo.FullName, missingPackageDirectory.DirInfo.FullName, ForceDotnetRefAssemblyFetching: false, PathToNugetConfig: nugetConfig));
            if (!res.Success)
            {
                if (tryWithoutNugetConfig && res.HasNugetPackageSourceError && nugetConfig is not null)
                {
                    // Restore could not be completed because the listed source is unavailable. Try without the nuget.config:
                    res = dotnet.Restore(new(tempDir.DirInfo.FullName, missingPackageDirectory.DirInfo.FullName, ForceDotnetRefAssemblyFetching: false, PathToNugetConfig: null, ForceReevaluation: true));
                }

                // TODO: the restore might fail, we could retry with
                // - a prerelease (*-* instead of *) version of the package,
                // - a different target framework moniker.

                if (!res.Success)
                {
                    logger.LogInfo($"Failed to restore nuget package {package}");
                    return false;
                }
            }

            return true;
        }

        private void TryChangeTargetFrameworkMoniker(DirectoryInfo tempDir)
        {
            try
            {
                logger.LogInfo($"Changing the target framework moniker in {tempDir.FullName}...");

                var csprojs = tempDir.GetFiles("*.csproj", new EnumerationOptions { RecurseSubdirectories = false, MatchCasing = MatchCasing.CaseInsensitive });
                if (csprojs.Length != 1)
                {
                    logger.LogError($"Could not find the .csproj file in {tempDir.FullName}, count = {csprojs.Length}");
                    return;
                }

                var csproj = csprojs[0];
                var content = File.ReadAllText(csproj.FullName);
                var matches = TargetFramework().Matches(content);
                if (matches.Count == 0)
                {
                    logger.LogError($"Could not find target framework in {csproj.FullName}");
                }
                else
                {
                    content = TargetFramework().Replace(content, $"<TargetFramework>{FrameworkPackageNames.LatestNetFrameworkMoniker}</TargetFramework>", 1);
                    File.WriteAllText(csproj.FullName, content);
                }
            }
            catch (Exception exc)
            {
                logger.LogError($"Failed to update target framework in {tempDir.FullName}: {exc}");
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

        private bool CheckFeeds(List<FileInfo> allFiles)
        {
            logger.LogInfo("Checking Nuget feeds...");
            var (explicitFeeds, allFeeds) = GetAllFeeds(allFiles);
            var inheritedFeeds = allFeeds.Except(explicitFeeds).ToHashSet();

            var excludedFeeds = EnvironmentVariables.GetURLs(EnvironmentVariableNames.ExcludedNugetFeedsFromResponsivenessCheck)
                .ToHashSet() ?? [];

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
            CompilationInfos.Add(("All Nuget feeds reachable", allFeedsReachable ? "1" : "0"));

            if (inheritedFeeds.Count > 0)
            {
                logger.LogInfo($"Inherited Nuget feeds: {string.Join(", ", inheritedFeeds.OrderBy(f => f))}");
                CompilationInfos.Add(("Inherited Nuget feed count", inheritedFeeds.Count.ToString()));
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

        private (HashSet<string>, HashSet<string>) GetAllFeeds(List<FileInfo> allFiles)
        {
            IList<string> GetNugetFeeds(string nugetConfig)
            {
                logger.LogInfo($"Getting Nuget feeds from '{nugetConfig}'...");
                return dotnet.GetNugetFeeds(nugetConfig);
            }

            IList<string> GetNugetFeedsFromFolder(string folderPath)
            {
                logger.LogInfo($"Getting Nuget feeds in folder '{folderPath}'...");
                return dotnet.GetNugetFeedsFromFolder(folderPath);
            }

            var nugetConfigs = GetAllNugetConfigs(allFiles);
            var explicitFeeds = nugetConfigs
                .SelectMany(config => GetFeeds(() => GetNugetFeeds(config)))
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
                .SelectMany(folder => GetFeeds(() => GetNugetFeedsFromFolder(folder!)))
                .ToHashSet();

            logger.LogInfo($"Found {allFeeds.Count} Nuget feeds (with inherited ones) in nuget.config files: {string.Join(", ", allFeeds.OrderBy(f => f))}");

            return (explicitFeeds, allFeeds);
        }

        [GeneratedRegex(@"<TargetFramework>.*</TargetFramework>", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex TargetFramework();

        [GeneratedRegex(@"^(.+)\.(\d+\.\d+\.\d+(-(.+))?)$", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex LegacyNugetPackage();

        [GeneratedRegex(@"^E\s(.*)$", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex EnabledNugetFeed();
    }
}
