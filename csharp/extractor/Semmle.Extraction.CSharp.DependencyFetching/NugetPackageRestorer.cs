using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.IO;
using System.Linq;
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
        private readonly FileProvider fileProvider;
        private readonly FileContent fileContent;
        private readonly IDotNet dotnet;
        private readonly IDiagnosticsWriter diagnosticsWriter;
        private readonly DependencyDirectory legacyPackageDirectory;
        private readonly DependencyDirectory missingPackageDirectory;
        private readonly ILogger logger;
        private readonly ICompilationInfoContainer compilationInfoContainer;
        private readonly FeedManager feedManager;

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
            this.diagnosticsWriter = diagnosticsWriter;
            this.logger = logger;
            this.compilationInfoContainer = compilationInfoContainer;

            PackageDirectory = new DependencyDirectory("packages", "package", logger);
            legacyPackageDirectory = new DependencyDirectory("legacypackages", "legacy package", logger);
            missingPackageDirectory = new DependencyDirectory("missingpackages", "missing package", logger);
            feedManager = new FeedManager(logger, dotnet, dependabotProxy, fileProvider);
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
            logger.LogInfo($"Checking NuGet feed responsiveness: {feedManager.CheckNugetFeedResponsiveness}");
            compilationInfoContainer.CompilationInfos.Add(("NuGet feed responsiveness checked", feedManager.CheckNugetFeedResponsiveness ? "1" : "0"));

            HashSet<string> reachableFeeds = [];

            EmitNugetConfigDiagnostics();

            // Find feeds that are configured in NuGet.config files and divide them into ones that
            // are explicitly configured for the project or by a private registry, and "all feeds"
            // (including inherited ones) from other locations on the host outside of the working directory.
            (var explicitFeeds, var allFeeds) = feedManager.GetAllFeeds();

            if (feedManager.CheckNugetFeedResponsiveness)
            {
                var inheritedFeeds = allFeeds.Except(explicitFeeds).ToHashSet();

                if (inheritedFeeds.Count > 0)
                {
                    compilationInfoContainer.CompilationInfos.Add(("Inherited NuGet feed count", inheritedFeeds.Count.ToString()));
                }

                var timeout = feedManager.CheckSpecifiedFeeds(explicitFeeds, out var reachableExplicitFeeds);
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
                feedManager.CheckSpecifiedFeeds(inheritedFeeds, out var reachableInheritedFeeds);
                reachableFeeds.UnionWith(reachableInheritedFeeds);
            }

            try
            {
                using (var packagesConfigRestore = PackagesConfigRestoreFactory.Create(fileProvider, legacyPackageDirectory, logger, feedManager.IsDefaultFeedReachable))
                {
                    var count = packagesConfigRestore.InstallPackages();

                    if (packagesConfigRestore.PackageCount > 0)
                    {
                        compilationInfoContainer.CompilationInfos.Add(("packages.config files", packagesConfigRestore.PackageCount.ToString()));
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
                .Select(d => Path.Join(PackageDirectory.DirInfo.FullName, d))
                .ToList();
            assemblyLookupLocations.UnionWith(paths.Select(p => new AssemblyLookupLocation(p)));

            var usedPackageNames = GetAllUsedPackageDirNames(dependencies);

            var missingPackageLocation = feedManager.CheckNugetFeedResponsiveness
                ? DownloadMissingPackagesFromSpecificFeeds(usedPackageNames, explicitFeeds)
                : DownloadMissingPackages(usedPackageNames);

            if (missingPackageLocation is not null)
            {
                assemblyLookupLocations.Add(missingPackageLocation);
            }
            return assemblyLookupLocations;
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
                    var nugetSources = feedManager.MakeRestoreSourcesArgument(solution, reachableFeeds);
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
                    var nugetSources = feedManager.MakeRestoreSourcesArgument(project, reachableFeeds);
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
            var reachableFallbackFeeds = feedManager.GetReachableFallbackNugetFeeds(feedsFromNugetConfigs);
            compilationInfoContainer.CompilationInfos.Add(("Reachable fallback NuGet feed count", reachableFallbackFeeds.Count.ToString()));

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

            var nugetConfigPath = Path.Join(folderPath, "nuget.config");
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

        private void EmitNugetConfigDiagnostics()
        {
            // On systems with case-sensitive file systems (for simplicity, we assume that is Linux), the
            // filenames of NuGet configuration files must be named correctly. For compatibility with projects
            // that are typically built on Windows or macOS where this doesn't matter, we accept all variants
            // of `nuget.config` ourselves. However, `dotnet` does not. If we detect that incorrectly-named
            // files are present, we emit a diagnostic to warn the user.
            var nugetConfigs = fileProvider.NugetConfigs;

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
        }

        [GeneratedRegex(@"<TargetFramework>.*</TargetFramework>", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex TargetFramework();

        [GeneratedRegex(@"Version=""(\*|\*-\*)""", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex PackageReferenceVersion();

        [GeneratedRegex(@"^(.+)\.(\d+\.\d+\.\d+(-(.+))?)$", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex LegacyNugetPackage();

        public void Dispose()
        {
            PackageDirectory?.Dispose();
            legacyPackageDirectory?.Dispose();
            missingPackageDirectory?.Dispose();
            feedManager.Dispose();
        }

        /// <summary>
        /// Returns the full path to a temporary directory with the given subfolder name.
        /// </summary>
        private static string ComputeTempDirectoryPath(string subfolderName)
        {
            return Path.Join(FileUtils.GetTemporaryWorkingDirectory(out _), subfolderName);
        }

        /// <summary>
        /// Computes a unique temporary directory path based on the source directory and the subfolder name.
        /// </summary>
        private static string ComputeTempDirectoryPath(string srcDir, string subfolderName)
        {
            return Path.Join(FileUtils.GetTemporaryWorkingDirectory(out _), FileUtils.ComputeHash(srcDir), subfolderName);
        }
    }
}
