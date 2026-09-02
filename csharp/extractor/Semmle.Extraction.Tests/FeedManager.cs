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

        [Fact]
        public void TestDefaultFeeds1()
        {
            // Setup
            var feedManager = MakeFeedManager();

            // Execute
            var reachableDefault = feedManager.ReachableDefaultFeeds;

            // Verify
            Assert.Equal([
                "https://api.nuget.org/v3/index.json"
            ], reachableDefault);
        }

        [Fact]
        public void TestDefaultFeeds2()
        {
            // Setup
            var logger = new LoggerStub();
            var dotnet = new DotNetStub([], [], [], []);
            var dependabotProxy = new DependabotProxyStubWithBaseUrls();
            var fileProvider = new FileProviderStub();
            var feedManagerIo = new FeedManagerIOStub(["https://example.com/registry2", "https://example.com/base1"]);
            var feedManager = new FeedManager(logger, dotnet, dependabotProxy, fileProvider, feedManagerIo);

            // Execute
            var reachableDefault = feedManager.ReachableDefaultFeeds;
            var reachableFallback = feedManager.ReachableFallbackFeeds;

            // Verify
            Assert.Equal([
                "https://example.com/base2"
            ], reachableDefault);
            Assert.Equal([
                "https://example.com/registry1",
                "https://example.com/base2"
            ], reachableFallback);
        }
    }
}
