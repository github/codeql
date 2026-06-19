using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    internal sealed partial class FeedManager : IDisposable
    {
        private readonly ILogger logger;
        private readonly IDotNet dotnet;
        private readonly DependencyDirectory emptyPackageDirectory;

        public ImmutableHashSet<string> PrivateRegistryFeeds { get; }
        public bool HasPrivateRegistryFeeds { get; }
        public bool CheckNugetFeedResponsiveness { get; } = EnvironmentVariables.GetBooleanOptOut(EnvironmentVariableNames.CheckNugetFeedResponsiveness);

        public FeedManager(ILogger logger, IDotNet dotnet, DependabotProxy? dependabotProxy)
        {
            this.logger = logger;
            this.dotnet = dotnet;
            PrivateRegistryFeeds = dependabotProxy?.RegistryURLs.ToImmutableHashSet() ?? [];
            HasPrivateRegistryFeeds = PrivateRegistryFeeds.Count > 0;
            emptyPackageDirectory = new DependencyDirectory("empty", "empty package", logger);
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

        public IEnumerable<string> GetFeedsFromFolder(string folderPath) =>
            GetFeeds(() => dotnet.GetNugetFeedsFromFolder(folderPath));


        public IEnumerable<string> GetFeedsFromNugetConfig(string nugetConfigPath) =>
            GetFeeds(() => dotnet.GetNugetFeeds(nugetConfigPath));

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
        public string? MakeRestoreSourcesArgument(string path, HashSet<string> reachableFeeds)
        {
            // Do not construct an set of explicit NuGet sources to use for restore.
            if (!CheckNugetFeedResponsiveness && !HasPrivateRegistryFeeds)
            {
                return null;
            }

            // Find the path specific feeds.
            var folder = FileUtils.GetDirectoryName(path, logger);
            var feedsToConsider = folder is not null ? GetFeedsFromFolder(folder).ToHashSet() : new HashSet<string>();

            if (HasPrivateRegistryFeeds)
            {
                feedsToConsider.UnionWith(PrivateRegistryFeeds);
            }

            var feedsToUse = CheckNugetFeedResponsiveness
                ? feedsToConsider.Where(reachableFeeds.Contains)
                : feedsToConsider;

            return FeedsToRestoreArgument(feedsToUse);
        }

        [GeneratedRegex(@"^E\s(.*)$", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex EnabledNugetFeed();

        public void Dispose()
        {
            emptyPackageDirectory.Dispose();
        }
    }
}
