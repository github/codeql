using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using System.Text.RegularExpressions;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal sealed partial class FeedManager : IDisposable
    {
        internal const string PublicNugetOrgFeed = "https://api.nuget.org/v3/index.json";

        private readonly ILogger logger;
        private readonly IDotNet dotnet;
        private readonly IFileProvider fileProvider;
        private readonly DependencyDirectory emptyPackageDirectory;
        private readonly ImmutableHashSet<string> privateRegistryFeeds;
        private readonly IFeedManagerIO feedManagerIo;

        /// <summary>
        /// Gets whether there are private package registries configured for C#.
        /// </summary>
        public bool HasPrivateRegistryFeeds { get; }

        /// <summary>
        /// Gets whether the reachability of the NuGet feeds should be checked before using them for restore.
        /// </summary>
        public bool CheckNugetFeedResponsiveness { get; } = EnvironmentVariables.GetBooleanOptOut(EnvironmentVariableNames.CheckNugetFeedResponsiveness);

        private readonly Lazy<ImmutableHashSet<string>> lazyExplicitFeeds;

        /// <summary>
        /// Gets the list of NuGet feeds that are explicitly configured
        /// - NuGet configuration files.
        /// - Private package registries that are configured for C#.
        /// </summary>
        public ImmutableHashSet<string> ExplicitFeeds => lazyExplicitFeeds.Value;

        private readonly Lazy<ImmutableHashSet<string>> lazyAllFeeds;

        /// <summary>
        /// Gets the list of all NuGet feeds that are configured in the environment. That is
        /// - Explicit feeds
        /// - Inherited feeds from the machine and environment (if not explicitly disabled by a
        /// root directory NuGet configuration).
        /// </summary>
        public ImmutableHashSet<string> AllFeeds => lazyAllFeeds.Value;

        /// <summary>
        /// Gets the list of inherited NuGet feeds that are configured in the environment.
        /// </summary>
        public ImmutableHashSet<string> InheritedFeeds => AllFeeds.Except(ExplicitFeeds).ToImmutableHashSet();

        private readonly Lazy<ImmutableHashSet<string>> lazyReachableExplicitFeeds;

        /// <summary>
        /// Gets the list of reachable NuGet feeds that are explicitly configured.
        /// </summary>
        public ImmutableHashSet<string> ReachableExplicitFeeds => lazyReachableExplicitFeeds.Value;

        private readonly Lazy<ImmutableHashSet<string>> lazyReachableFeeds;
        /// <summary>
        /// Gets the list of reachable NuGet feeds that are configured in the environment.
        /// </summary>
        public ImmutableHashSet<string> ReachableFeeds => lazyReachableFeeds.Value;

        private readonly Lazy<ImmutableHashSet<string>> lazyReachableFallbackFeeds;
        /// <summary>
        /// Gets the list of reachable NuGet feeds that are configured as fallback feeds.
        /// </summary>
        public ImmutableHashSet<string> ReachableFallbackFeeds => lazyReachableFallbackFeeds.Value;

        private readonly Lazy<ImmutableHashSet<string>> lazyReachableDefaultFeeds;

        /// <summary>
        /// Gets the list of default NuGet feeds that are configured in the environment.
        /// This is either the public NuGet feed or a set of feeds specified by the environment.
        /// </summary>
        public ImmutableHashSet<string> DefaultFeeds { get; init; }

        /// <summary>
        /// Gets the list of reachable default NuGet feeds.
        /// </summary>
        public ImmutableHashSet<string> ReachableDefaultFeeds => lazyReachableDefaultFeeds.Value;

        public FeedManager(ILogger logger, IDotNet dotnet, IDependabotProxy? dependabotProxy, IFileProvider fileProvider, IFeedManagerIO feedManagerIo)
        {
            this.logger = logger;
            this.dotnet = dotnet;
            this.fileProvider = fileProvider;
            this.feedManagerIo = feedManagerIo;
            privateRegistryFeeds = dependabotProxy?.RegistryURLs ?? [];
            HasPrivateRegistryFeeds = privateRegistryFeeds.Count > 0;
            DefaultFeeds = dependabotProxy?.RegistryBaseURLs.Any() == true
                ? dependabotProxy.RegistryBaseURLs
                : [PublicNugetOrgFeed];
            emptyPackageDirectory = new DependencyDirectory("empty", "empty package", logger);

            lazyExplicitFeeds = new Lazy<ImmutableHashSet<string>>(GetExplicitFeeds);
            lazyAllFeeds = new Lazy<ImmutableHashSet<string>>(GetAllFeeds);
            lazyReachableExplicitFeeds = new Lazy<ImmutableHashSet<string>>(() => CheckSpecifiedFeeds(ExplicitFeeds));
            lazyReachableFeeds = new Lazy<ImmutableHashSet<string>>(() =>
            {
                // Inherited feeds should only be used, if they are indeed reachable (as they may be environment specific).
                var reachableInheritedFeeds = CheckSpecifiedFeeds(InheritedFeeds);
                return ReachableExplicitFeeds.Union(reachableInheritedFeeds).ToImmutableHashSet();
            });
            lazyReachableFallbackFeeds = new Lazy<ImmutableHashSet<string>>(() =>
            {
                var reachableFallbackFeeds = GetReachableFallbackNugetFeeds();
                return reachableFallbackFeeds.ToImmutableHashSet();
            });
            lazyReachableDefaultFeeds = new Lazy<ImmutableHashSet<string>>(() => CheckSpecifiedFeeds(DefaultFeeds));
        }

        public FeedManager(ILogger logger, IDotNet dotnet, IDependabotProxy? dependabotProxy, IFileProvider fileProvider)
            : this(logger, dotnet, dependabotProxy, fileProvider, new FeedManagerIO(logger, dependabotProxy))
        {
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

        private IEnumerable<string> GetFeedsFromFolder(string folderPath) =>
            GetFeeds(() => dotnet.GetNugetFeedsFromFolder(folderPath));

        private IEnumerable<string> GetFeedsFromNugetConfig(string nugetConfigPath) =>
            GetFeeds(() => dotnet.GetNugetFeeds(nugetConfigPath));

        /// <summary>
        /// Constructs the NuGet sources argument for the restore command based on the given feeds.
        /// If there are no feeds, a dummy source argument is added to override any default feeds that `restore` would use.
        /// </summary>
        /// <param name="feeds">The list of feeds to use for the restore command.</param>
        /// <returns>The list of NuGet sources arguments for the restore command.</returns>
        public List<string> RestoreFeeds(IEnumerable<string> feeds)
        {
            // If there are no feeds, we want to override any default feeds that `restore` would use by passing a dummy source argument.
            if (!feeds.Any())
            {
                return [emptyPackageDirectory.DirInfo.FullName];
            }

            return feeds.ToList();
        }

        private IEnumerable<string> FeedsToUseAux(HashSet<string> feedsToConsider)
        {
            if (HasPrivateRegistryFeeds)
            {
                feedsToConsider.UnionWith(privateRegistryFeeds);
            }

            var feedsToUse = CheckNugetFeedResponsiveness
                ? feedsToConsider.Where(ReachableFeeds.Contains)
                : feedsToConsider;

            return feedsToUse;
        }

        /// <summary>
        /// Constructs the list of NuGet sources to use for this restore.
        /// (1) Use the feeds we get from `dotnet nuget list source`
        /// (2) Use private registries, if they are configured
        /// </summary>
        /// <param name="path">Path to project/solution/packages.config</param>
        /// <returns>The list of NuGet feeds to use for this restore.</returns>
        public IEnumerable<string> FeedsToUse(string path)
        {
            // Find the path specific feeds.
            var folder = feedManagerIo.GetDirectoryName(path);
            var feedsToConsider = folder is not null ? GetFeedsFromFolder(folder).ToHashSet() : new HashSet<string>();

            return FeedsToUseAux(feedsToConsider);
        }

        /// <summary>
        /// Constructs the list of NuGet sources to use for dotnet restore.
        /// (1) Use the feeds we get from `dotnet nuget list source`
        /// (2) Use private registries, if they are configured
        /// </summary>
        /// <param name="path">Path to project/solution</param>
        /// <returns>A list representing the NuGet sources arguments for the `dotnet restore` command.</returns>
        public List<string> MakeRestoreFeeds(string path)
        {
            // Do not construct a set of explicit NuGet sources to use for restore.
            if (!CheckNugetFeedResponsiveness && !HasPrivateRegistryFeeds)
            {
                return [];
            }

            var feedsToUse = FeedsToUse(path);

            return RestoreFeeds(feedsToUse);
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
        /// <returns>The list of feeds that were reachable.</returns>
        private ImmutableHashSet<string> CheckSpecifiedFeeds(ImmutableHashSet<string> feeds)
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

            var reachable = GetReachableNuGetFeeds(feedsToCheck, isFallback: false);

            // Always consider feeds excluded for the reachability check as reachable.
            return reachable.Union(feeds.Where(feed => excludedFeeds.Contains(feed))).ToImmutableHashSet();
        }

        /// <summary>
        /// Tests which of the feeds given by <paramref name="feedsToCheck"/> are reachable.
        /// </summary>
        /// <param name="feedsToCheck">The feeds to check.</param>
        /// <param name="isFallback">Whether the feeds are fallback feeds or not.</param>
        /// <returns>The list of feeds that could be reached.</returns>
        private List<string> GetReachableNuGetFeeds(HashSet<string> feedsToCheck, bool isFallback)
        {
            var fallbackStr = isFallback ? "fallback " : "";
            logger.LogInfo($"Checking {fallbackStr}NuGet feed reachability on feeds: {string.Join(", ", feedsToCheck.OrderBy(f => f))}");

            var (initialTimeout, tryCount) = GetFeedRequestSettings(isFallback);
            var reachableFeeds = feedsToCheck
                .Where(feed => feedManagerIo.IsFeedReachable(feed, initialTimeout, tryCount))
                .ToList();

            if (reachableFeeds.Count == 0)
            {
                logger.LogWarning($"No {fallbackStr}NuGet feeds are reachable.");
            }
            else
            {
                logger.LogInfo($"Reachable {fallbackStr}NuGet feeds: {string.Join(", ", reachableFeeds.OrderBy(f => f))}");
            }

            return reachableFeeds;
        }

        private List<string> GetReachableFallbackNugetFeeds()
        {
            var fallbackFeeds = EnvironmentVariables.GetURLs(EnvironmentVariableNames.FallbackNugetFeeds).ToHashSet();
            if (fallbackFeeds.Count == 0)
            {
                fallbackFeeds.UnionWith(DefaultFeeds);
                logger.LogInfo($"No fallback NuGet feeds specified. Adding default feeds: {string.Join(", ", DefaultFeeds.OrderBy(f => f))}");

                var shouldAddNugetConfigFeeds = EnvironmentVariables.GetBooleanOptOut(EnvironmentVariableNames.AddNugetConfigFeedsToFallback);
                logger.LogInfo($"Adding feeds from nuget.config to fallback restore: {shouldAddNugetConfigFeeds}");

                if (shouldAddNugetConfigFeeds && ExplicitFeeds.Count > 0)
                {
                    // Feeds in `ExplicitFeeds` may already have been checked for reachability.
                    // However, the fallback logic may use different responsiveness settings, so check them again.
                    fallbackFeeds.UnionWith(ExplicitFeeds);
                    logger.LogInfo($"Using NuGet feeds from nuget.config files as fallback feeds: {string.Join(", ", ExplicitFeeds.OrderBy(f => f))}");
                }
            }

            return GetReachableNuGetFeeds(fallbackFeeds, isFallback: true);
        }

        private ImmutableHashSet<string> GetExplicitFeeds()
        {
            var nugetConfigs = fileProvider.NugetConfigs;

            // Find feeds that are explicitly configured in the NuGet configuration files that we found.
            var explicitFeeds = nugetConfigs
                .SelectMany(GetFeedsFromNugetConfig)
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
            if (HasPrivateRegistryFeeds)
            {
                logger.LogInfo($"Found {privateRegistryFeeds.Count} private registry feeds configured for C#: {string.Join(", ", privateRegistryFeeds.OrderBy(f => f))}");
                explicitFeeds.UnionWith(privateRegistryFeeds);
            }

            return explicitFeeds.ToImmutableHashSet();
        }

        private ImmutableHashSet<string> GetAllFeeds()
        {
            var nugetConfigs = fileProvider.NugetConfigs;

            HashSet<string> allFeeds = [];

            // Add all explicitFeeds to the set of all feeds.
            allFeeds.UnionWith(ExplicitFeeds);

            // Obtain the list of feeds from the root source directory.
            // If a NuGet file is present it will be respected, otherwise we will just get the machine/environment specific feeds.
            var nugetFeedsFromRoot = GetFeedsFromFolder(fileProvider.SourceDir.FullName);
            allFeeds.UnionWith(nugetFeedsFromRoot);

            if (nugetConfigs.Count > 0)
            {
                var nugetConfigFeeds = nugetConfigs
                    .Select(feedManagerIo.GetDirectoryName)
                    .Where(folder => folder != null)
                    .SelectMany(folder => GetFeedsFromFolder(folder!))
                    .ToHashSet();

                allFeeds.UnionWith(nugetConfigFeeds);
            }

            logger.LogInfo($"Found {allFeeds.Count} NuGet feeds (with inherited ones) in nuget.config files: {string.Join(", ", allFeeds.OrderBy(f => f))}");

            return allFeeds.ToImmutableHashSet();
        }

        [GeneratedRegex(@"^E\s(.*)$", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex EnabledNugetFeed();

        public void Dispose()
        {
            emptyPackageDirectory.Dispose();
        }
    }
}
