using System;
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
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal sealed partial class FeedManager : IDisposable
    {
        internal const string PublicNugetOrgFeed = "https://api.nuget.org/v3/index.json";

        private readonly ILogger logger;
        private readonly IDotNet dotnet;
        private readonly FileProvider fileProvider;
        private readonly DependabotProxy? dependabotProxy;
        private readonly DependencyDirectory emptyPackageDirectory;
        private readonly ImmutableHashSet<string> privateRegistryFeeds;

        public bool HasPrivateRegistryFeeds { get; }
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

        private readonly Lazy<(bool, ImmutableHashSet<string>)> lazyReachableExplicitFeeds;

        /// <summary>
        /// Gets whether there was a timeout when checking the reachability of the explicitly configured NuGet feeds.
        /// </summary>
        public bool ExplicitFeedTimeout => lazyReachableExplicitFeeds.Value.Item1;

        /// <summary>
        /// Gets the list of reachable NuGet feeds that are explicitly configured.
        /// </summary>
        public ImmutableHashSet<string> ReachableExplicitFeeds => lazyReachableExplicitFeeds.Value.Item2;

        private readonly Lazy<ImmutableHashSet<string>> lazyReachableFeeds;
        /// <summary>
        /// Gets the list of reachable NuGet feeds that are configured in the environment.
        /// </summary>
        public ImmutableHashSet<string> ReachableFeeds => lazyReachableFeeds.Value;

        public FeedManager(ILogger logger, IDotNet dotnet, DependabotProxy? dependabotProxy, FileProvider fileProvider)
        {
            this.logger = logger;
            this.dotnet = dotnet;
            this.dependabotProxy = dependabotProxy;
            this.fileProvider = fileProvider;
            privateRegistryFeeds = dependabotProxy?.RegistryURLs.ToImmutableHashSet() ?? [];
            HasPrivateRegistryFeeds = privateRegistryFeeds.Count > 0;
            emptyPackageDirectory = new DependencyDirectory("empty", "empty package", logger);

            lazyExplicitFeeds = new Lazy<ImmutableHashSet<string>>(GetExplicitFeeds);
            lazyAllFeeds = new Lazy<ImmutableHashSet<string>>(GetAllFeeds);
            lazyReachableExplicitFeeds = new Lazy<(bool, ImmutableHashSet<string>)>(() =>
            {
                var timeout = CheckSpecifiedFeeds(ExplicitFeeds, out var reachableFeeds);
                return (timeout, reachableFeeds);
            });
            lazyReachableFeeds = new Lazy<ImmutableHashSet<string>>(() =>
            {
                // Inherited feeds should only be used, if they are indeed reachable (as they may be environment specific).
                CheckSpecifiedFeeds(InheritedFeeds, out var reachableInheritedFeeds);
                return ReachableExplicitFeeds.Union(reachableInheritedFeeds).ToImmutableHashSet();
            });
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

        public string FeedsToRestoreArgument(IEnumerable<string> feeds, string sourceArgumentPrefix)
        {
            // If there are no feeds, we want to override any default feeds that `restore` would use by passing a dummy source argument.
            if (!feeds.Any())
            {
                return $" {sourceArgumentPrefix} \"{emptyPackageDirectory.DirInfo.FullName}\"";
            }

            // Add package sources. If any are present, they override all sources specified in
            // the configuration file(s).
            var feedArgs = new StringBuilder();
            foreach (var feed in feeds)
            {
                feedArgs.Append($" {sourceArgumentPrefix} \"{feed}\"");
            }

            return feedArgs.ToString();
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
            var folder = GetDirectoryName(path);
            var feedsToConsider = folder is not null ? GetFeedsFromFolder(folder).ToHashSet() : new HashSet<string>();

            return FeedsToUseAux(feedsToConsider);
        }

        public IEnumerable<string> FeedsToUseFromConfig(string config)
        {
            var feedsToConsider = GetFeedsFromNugetConfig(config).ToHashSet();

            return FeedsToUseAux(feedsToConsider);
        }

        public string FeedsToDotnetRestoreArgument(IEnumerable<string> feeds)
        {
            return FeedsToRestoreArgument(feeds, "-s");
        }

        /// <summary>
        /// Constructs the list of NuGet sources to use for dotnet restore.
        /// (1) Use the feeds we get from `dotnet nuget list source`
        /// (2) Use private registries, if they are configured
        /// </summary>
        /// <param name="path">Path to project/solution</param>
        /// <returns>A string representing the NuGet sources argument for the restore command.</returns>
        public string? MakeDotnetRestoreSourcesArgument(string path)
        {
            // Do not construct a set of explicit NuGet sources to use for restore.
            if (!CheckNugetFeedResponsiveness && !HasPrivateRegistryFeeds)
            {
                return null;
            }

            var feedsToUse = FeedsToUse(path);

            return FeedsToDotnetRestoreArgument(feedsToUse);
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
        private bool CheckSpecifiedFeeds(ImmutableHashSet<string> feeds, out ImmutableHashSet<string> reachableFeeds)
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

            var reachable = GetReachableNuGetFeeds(feedsToCheck, isFallback: false, out var isTimeout);

            // Always consider feeds excluded for the reachability check as reachable.
            reachableFeeds = reachable.Union(feeds.Where(feed => excludedFeeds.Contains(feed))).ToImmutableHashSet();

            return isTimeout;
        }

        public bool IsDefaultFeedReachable()
        {
            if (CheckNugetFeedResponsiveness)
            {
                var (initialTimeout, tryCount) = GetFeedRequestSettings(isFallback: false);
                return IsFeedReachable(PublicNugetOrgFeed, initialTimeout, tryCount, out var _);
            }

            return true;
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

        public List<string> GetReachableFallbackNugetFeeds(ImmutableHashSet<string>? feedsFromNugetConfigs)
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

            return GetReachableNuGetFeeds(fallbackFeeds, isFallback: true, out var _);
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
                    .Select(GetDirectoryName)
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
