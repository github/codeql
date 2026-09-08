using Xunit;
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.IO;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using Semmle.Extraction.CSharp.DependencyFetching;

namespace Semmle.Extraction.Tests
{
    public class DependabotProxyStub : IDependabotProxy
    {
        public string Address { get; } = "";
        public ImmutableHashSet<string> RegistryURLs { get; } = ["https://example.com/registry1", "https://example.com/registry2"];
        public ImmutableHashSet<string> RegistryBaseURLs { get; } = [];
        public string? CertificatePath { get; } = null;
        public X509Certificate2? Certificate { get; } = null;

        public void Dispose() { }
    }

    public class DependabotProxyStubWithBaseUrls : IDependabotProxy
    {
        public string Address { get; } = "";
        public ImmutableHashSet<string> RegistryURLs { get; } = ["https://example.com/registry1", "https://example.com/registry2", "https://example.com/base1", "https://example.com/base2"];
        public ImmutableHashSet<string> RegistryBaseURLs { get; } = ["https://example.com/base1", "https://example.com/base2"];
        public string? CertificatePath { get; } = null;
        public X509Certificate2? Certificate { get; } = null;

        public void Dispose() { }
    }

    public class FeedManagerIOStub : IFeedManagerIO
    {
        private readonly List<string> unreachableFeeds;

        public FeedManagerIOStub(List<string> unreachableFeeds)
        {
            this.unreachableFeeds = unreachableFeeds;
        }

        public string? GetDirectoryName(string path)
        {
            return "/path/to/folder";
        }

        public bool IsFeedReachable(string feed, int timeoutMilliSeconds, int tryCount)
        {
            return !unreachableFeeds.Contains(feed);
        }
    }

    public class FileProviderStub : IFileProvider
    {
        public DirectoryInfo SourceDir { get; } = new DirectoryInfo("/path/to/source");
        public IEnumerable<string> SmallNonBinary { get; } = Enumerable.Empty<string>();
        public IEnumerable<string> Sources { get; } = Enumerable.Empty<string>();
        public ICollection<string> Projects { get; } = new List<string>();
        public ICollection<string> Solutions { get; } = new List<string>();
        public IEnumerable<string> Dlls { get; } = Enumerable.Empty<string>();
        public ICollection<string> NugetConfigs { get; } = ["/path/to/nuget.config"];
        public ICollection<string> NugetExes { get; } = new List<string>();
        public string? RootNugetConfig { get; } = null;
        public IEnumerable<string> GlobalJsons { get; } = Enumerable.Empty<string>();
        public ICollection<string> PackagesConfigs { get; } = new List<string>();
        public ICollection<string> RazorViews { get; } = new List<string>();
        public ICollection<string> Resources { get; } = new List<string>();
    }

    /// <summary>
    /// The purpose of this test class is to verify the behavior of the FeedManager class.
    /// The tests use stub implementations of the FeedManager's dependencies to control the behavior of the FeedManager
    /// and verify its behavior.
    /// </summary>
    public class FeedManagerTests
    {
        private static FeedManager MakeFeedManager()
        {
            var logger = new LoggerStub();
            var dotnet = new DotNetStub([], [], ["E https://feed.from/config"], ["E https://feed.from/folder1", "E https://feed.from/folder2", "D https://feed.from/folder3"]);
            var dependabotProxy = new DependabotProxyStub();
            var fileProvider = new FileProviderStub();
            var feedManagerIo = new FeedManagerIOStub(["https://example.com/registry1", "https://feed.from/folder2"]);
            return new FeedManager(logger, dotnet, dependabotProxy, fileProvider, feedManagerIo);
        }

        /// <summary>
        /// The purpose of this test is to verify that the FeedManager correctly computes the set of
        /// explicit feeds.
        /// </summary>
        [Fact]
        public void TestExplicitFeeds()
        {
            // Setup
            var feedManager = MakeFeedManager();

            // Execute
            var actualFeeds = feedManager.ExplicitFeeds;

            // Verify
            Assert.Equal([
                "https://example.com/registry1",
                "https://example.com/registry2",
                "https://feed.from/config"
            ], actualFeeds);
        }

        /// <summary>
        /// The purpose of this test is to verify that the FeedManager correctly computes the set of
        /// inherited feeds.
        /// </summary>
        [Fact]
        public void TestInheritedFeeds()
        {
            // Setup
            var feedManager = MakeFeedManager();

            // Execute
            var inherited = feedManager.InheritedFeeds;

            // Verify
            Assert.Equal([
                "https://feed.from/folder1",
                "https://feed.from/folder2"
            ], inherited);
        }

        /// <summary>
        /// The purpose of this test is to verify that the FeedManager correctly computes the set of
        /// all feeds.
        /// </summary>
        [Fact]
        public void TestAllFeeds()
        {
            // Setup
            var feedManager = MakeFeedManager();

            // Execute
            var all = feedManager.AllFeeds;

            // Verify
            Assert.Equal([
                "https://example.com/registry1",
                "https://example.com/registry2",
                "https://feed.from/config",
                "https://feed.from/folder1",
                "https://feed.from/folder2"
            ], all);
        }

        /// <summary>
        /// The purpose of this test is to verify that the FeedManager correctly computes the set of
        /// reachable feeds.
        /// </summary>
        [Fact]
        public void TestReachableFeeds()
        {
            // Setup
            var feedManager = MakeFeedManager();

            // Execute
            var reachableFeeds = feedManager.ReachableFeeds;

            // Verify
            Assert.Equal([
                "https://example.com/registry2",
                "https://feed.from/config",
                "https://feed.from/folder1"
            ], reachableFeeds);
        }

        /// <summary>
        /// The purpose of this test is to verify that the FeedManager correctly computes the set of
        /// reachable explicit feeds.
        /// </summary>
        [Fact]
        public void TestReachableExplicitFeeds()
        {
            // Setup
            var feedManager = MakeFeedManager();

            // Execute
            var reachableFeeds = feedManager.ReachableExplicitFeeds;

            // Verify
            Assert.Equal([
                "https://example.com/registry2",
                "https://feed.from/config"
            ], reachableFeeds);
        }

        /// <summary>
        /// The purpose of this test is to verify that the FeedManager correctly computes the set of
        /// reachable fallback feeds.
        /// </summary>
        [Fact]
        public void TestReachableFallbackFeeds()
        {
            // Setup
            var feedManager = MakeFeedManager();

            // Execute
            var reachableFallback = feedManager.ReachableFallbackFeeds;

            // Verify
            Assert.Equal([
                "https://example.com/registry2",
                "https://feed.from/config",
                "https://api.nuget.org/v3/index.json"
            ], reachableFallback);
        }

        /// <summary>
        /// The purpose of this test is to verify that the FeedManager correctly computes the set of
        /// feeds to use for a given file.
        /// </summary>
        [Fact]
        public void TestFeedsToUse()
        {
            // Setup
            var feedManager = MakeFeedManager();

            // Execute
            var feedsToUse = feedManager.FeedsToUse("/path/to/packages.config").ToHashSet();

            // Verify
            Assert.Equal([
                "https://example.com/registry2",
                "https://feed.from/folder1"
            ], feedsToUse);
        }

        /// <summary>
        /// The purpose of this test is to verify that the FeedManager correctly computes the set of
        /// default feeds and reachable default feeds when no private registries are configured.
        /// </summary>
        [Fact]
        public void TestDefaultFeedsNugetOrg()
        {
            // Setup
            var feedManager = MakeFeedManager();

            // Execute
            var defaultFeeds = feedManager.DefaultFeeds;
            var reachableDefault = feedManager.ReachableDefaultFeeds;

            // Verify
            Assert.Equal([
                "https://api.nuget.org/v3/index.json"
            ], defaultFeeds);
            Assert.Equal([
                "https://api.nuget.org/v3/index.json"
            ], reachableDefault);
        }

        /// <summary>
        /// The purpose of this test is to verify that the FeedManager correctly computes the set of
        /// default feeds, reachable default feeds, and fallback feeds when private registries
        /// are configured and some of them replace the default feeds.
        /// </summary>
        [Fact]
        public void TestDefaultFeedsPrivateRegistries()
        {
            // Setup
            var logger = new LoggerStub();
            var dotnet = new DotNetStub([], [], [], []);
            var dependabotProxy = new DependabotProxyStubWithBaseUrls();
            var fileProvider = new FileProviderStub();
            var feedManagerIo = new FeedManagerIOStub(["https://example.com/registry2", "https://example.com/base1"]);
            var feedManager = new FeedManager(logger, dotnet, dependabotProxy, fileProvider, feedManagerIo);

            // Execute
            var defaultFeeds = feedManager.DefaultFeeds;
            var reachableDefault = feedManager.ReachableDefaultFeeds;
            var reachableFallback = feedManager.ReachableFallbackFeeds;

            // Verify
            Assert.Equal([
                "https://example.com/base1",
                "https://example.com/base2"
            ], defaultFeeds);
            Assert.Equal([
                "https://example.com/base2"
            ], reachableDefault);
            Assert.Equal([
                "https://example.com/registry1",
                "https://example.com/base2"
            ], reachableFallback);
        }

        /// <summary>
        /// The purpose of this test is to verify that the FeedManager correctly computes the set of
        /// all feeds when https://api.nuget.org/v3/index.json is not replaced by any private registries because
        /// none of them are configured to replace the base feeds.
        /// </summary>
        [Fact]
        public void TestNugetOrgNotReplaced()
        {
            // Setup
            var logger = new LoggerStub();
            var dotnet = new DotNetStub([], [], [], ["E https://api.nuget.org/v3/index.json"]);
            var dependabotProxy = new DependabotProxyStub();
            var fileProvider = new FileProviderStub();
            var feedManagerIo = new FeedManagerIOStub(["https://example.com/registry2", "https://example.com/base1"]);
            var feedManager = new FeedManager(logger, dotnet, dependabotProxy, fileProvider, feedManagerIo);

            // Execute
            var explicitFeeds = feedManager.ExplicitFeeds;
            var allFeeds = feedManager.AllFeeds;

            // Verify
            Assert.Equal([
                "https://example.com/registry1",
                "https://example.com/registry2",
            ], explicitFeeds);
            Assert.Equal([
                "https://example.com/registry1",
                "https://example.com/registry2",
                "https://api.nuget.org/v3/index.json"
            ], allFeeds);

        }

        /// <summary>
        /// The purpose of this test is to verify that the FeedManager correctly computes the set of
        /// all feeds when https://api.nuget.org/v3/index.json and related NuGet.org URLs are replaced by private
        /// registries configured to replace the base feeds.
        /// </summary>
        [Fact]
        public void TestNugetOrgReplacement()
        {
            // Setup
            var logger = new LoggerStub();
            var dotnet = new DotNetStub([], [], ["E https://www.nuget.org/api/v2/"], ["E https://api.nuget.org/v3/index.json"]);
            var dependabotProxy = new DependabotProxyStubWithBaseUrls();
            var fileProvider = new FileProviderStub();
            var feedManagerIo = new FeedManagerIOStub(["https://example.com/registry2", "https://example.com/base1"]);
            var feedManager = new FeedManager(logger, dotnet, dependabotProxy, fileProvider, feedManagerIo);

            // Execute
            var explicitFeeds = feedManager.ExplicitFeeds;
            var allFeeds = feedManager.AllFeeds;

            // Verify
            Assert.Equal([
                "https://example.com/base1",
                "https://example.com/base2",
                "https://example.com/registry1",
                "https://example.com/registry2"
            ], explicitFeeds);
            Assert.Equal([
                "https://example.com/base1",
                "https://example.com/base2",
                "https://example.com/registry1",
                "https://example.com/registry2",
            ], allFeeds);
        }
    }
}
