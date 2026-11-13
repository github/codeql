using Xunit;
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using Semmle.Extraction.CSharp.DependencyFetching;

namespace Semmle.Extraction.Tests
{
    public class RegistryProxyStub : IRegistryProxy
    {
        public string Address { get; } = "";
        public ImmutableHashSet<string> RegistryURLs { get; } = ["https://example.com/registry1", "https://example.com/registry2"];
        public ImmutableHashSet<string> RegistryBaseURLs { get; } = [];
        public string? CertificatePath { get; } = null;
        public X509Certificate2? Certificate { get; } = null;

        public void SetProcessEnvironment(ProcessStartInfo pi) { }

        public void Dispose() { }
    }

    public class RegistryProxyStubWithBaseUrls : IRegistryProxy
    {
        public string Address { get; } = "";
        public ImmutableHashSet<string> RegistryURLs { get; } = ["https://example.com/registry1", "https://example.com/registry2", "https://example.com/base1", "https://example.com/base2"];
        public ImmutableHashSet<string> RegistryBaseURLs { get; } = ["https://example.com/base1", "https://example.com/base2"];
        public string? CertificatePath { get; } = null;
        public X509Certificate2? Certificate { get; } = null;

        public void SetProcessEnvironment(ProcessStartInfo pi) { }
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
            var registryProxy = new RegistryProxyStub();
            var fileProvider = new FileProviderStub();
            var feedManagerIo = new FeedManagerIOStub(["https://example.com/registry1", "https://feed.from/folder2"]);
            return new FeedManager(logger, dotnet, registryProxy, fileProvider, feedManagerIo);
        }

        /// <summary>
        /// Verify that `FeedManager` correctly computes the explicit feeds using feeds discovered in nuget.config files and
        /// private registries.
        /// See the initialization of `DotNetStub` and `RegistryProxyStub` in `MakeFeedManager` for the feeds configured
        /// to be returned and classified as explicit feeds.
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
        /// Verify that `FeedManager` correctly computes the inherited feeds using feeds discovered from the environment.
        /// See the initialization of `DotNetStub` in `MakeFeedManager` for the feeds configured
        /// to be returned and classified as inherited feeds.
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
        /// Verify that `FeedManager` correctly computes all feeds using feeds discovered in nuget.config files, private registries,
        /// and the environment.
        /// See the initialization of `DotNetStub` and `RegistryProxyStub` in `MakeFeedManager` for the feeds configured
        /// to be returned and included in all feeds.
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
        /// Verify that `FeedManager` correctly computes the reachable feeds using feeds discovered in
        /// nuget.config files, private registries, and the environment.
        /// See the initialization of `FeedManagerIOStub` in `MakeFeedManager` for the feeds configured as unreachable
        /// and therefore filtered out of the reachable feeds.
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
        /// Verify that `FeedManager` correctly computes the reachable explicit feeds using feeds discovered in
        /// nuget.config files and private registries.
        /// See the initialization of `FeedManagerIOStub` in `MakeFeedManager` for the feeds configured as unreachable
        /// and therefore filtered out of the reachable explicit feeds.
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
        /// Verify that `FeedManager` correctly computes the reachable fallback feeds using feeds discovered in
        /// nuget.config files and the default NuGet.org feed.
        /// See the initialization of `FeedManagerIOStub` in `MakeFeedManager` for the feeds configured as unreachable
        /// and therefore filtered out of the reachable fallback feeds.
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
        /// Verify that `FeedManager` correctly computes the feeds to use for a given packages.config file from feeds discovered
        /// in private registries and the environment.
        /// See the initialization of `DotNetStub` in `MakeFeedManager` for the feeds configured
        /// to be returned and selected for use.
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
        /// Verify that NuGet CLI restore excludes private registries and unreachable feeds,
        /// while leaving private registries available to dotnet restore.
        /// </summary>
        [Fact]
        public void TestNugetExeRestoreFeedsExcludePrivateRegistries()
        {
            // Setup
            var logger = new LoggerStub();
            var dotnet = new DotNetStub([], [], [],
                ["E https://example.com/registry2", "E https://feed.from/folder1", "E https://feed.from/folder2"]);
            using var feedManager = new FeedManager(logger, dotnet, new RegistryProxyStub(),
                new FileProviderStub(), new FeedManagerIOStub(["https://feed.from/folder2"]));

            // Execute
            var feeds = feedManager.MakeNugetExeRestoreFeeds("/path/to/packages.config");
            var dotnetFeeds = feedManager.MakeRestoreFeeds("/path/to/project.csproj");

            // Verify
            Assert.Equal(["https://feed.from/folder1"], feeds);
            Assert.Contains("https://example.com/registry2", dotnetFeeds);
        }

        /// <summary>
        /// Verify that NuGet CLI restore excludes private registries that replace NuGet.org,
        /// retaining other configured feeds.
        /// </summary>
        [Fact]
        public void TestNugetExeRestoreFeedsExcludePrivateBaseRegistries()
        {
            // Setup
            var logger = new LoggerStub();
            var dotnet = new DotNetStub([], [], [],
                ["E https://api.nuget.org/v3/index.json", "E https://feed.from/folder1"]);
            using var feedManager = new FeedManager(logger, dotnet, new RegistryProxyStubWithBaseUrls(),
                new FileProviderStub(), new FeedManagerIOStub([]));

            // Execute
            var feeds = feedManager.MakeNugetExeRestoreFeeds("/path/to/packages.config");

            // Verify
            Assert.Equal(["https://feed.from/folder1"], feeds);
        }

        /// <summary>
        /// Verify that NuGet CLI restore uses an empty local source when private registries replace the default feeds,
        /// regardless of their reachability.
        /// </summary>
        [Theory]
        [InlineData(false)]
        [InlineData(true)]
        public void TestNugetExeRestoreFeedsWithOnlyPrivateRegistries(bool unreachable)
        {
            // Setup
            var logger = new LoggerStub();
            var registryProxy = new RegistryProxyStubWithBaseUrls();
            var dotnet = new DotNetStub([], [], [], ["E https://api.nuget.org/v3/index.json"]);
            using var feedManager = new FeedManager(logger, dotnet, registryProxy,
                new FileProviderStub(), new FeedManagerIOStub(unreachable ? registryProxy.RegistryURLs.ToList() : []));

            // Execute
            var feeds = feedManager.MakeNugetExeRestoreFeeds("/path/to/packages.config");

            // Verify
            var source = Assert.Single(feeds);
            Assert.True(Path.IsPathFullyQualified(source));
            Assert.True(Directory.Exists(source));
        }

        /// <summary>
        /// Verify that NuGet CLI restore explicitly selects reachable feeds when no private registries are configured.
        /// </summary>
        [Fact]
        public void TestNugetExeRestoreFeedsWithoutPrivateRegistries()
        {
            // Setup
            var logger = new LoggerStub();
            var dotnet = new DotNetStub([], [], [], ["E https://feed.from/folder1"]);
            using var feedManager = new FeedManager(logger, dotnet, null,
                new FileProviderStub(), new FeedManagerIOStub([]));

            // Execute
            var feeds = feedManager.MakeNugetExeRestoreFeeds("/path/to/packages.config");

            // Verify
            Assert.Equal(["https://feed.from/folder1"], feeds);
        }

        /// <summary>
        /// Verify that NuGet CLI restore falls back to the default NuGet.org feed when no feeds are configured.
        /// </summary>
        [Fact]
        public void TestNugetExeRestoreFeedsUseDefaults()
        {
            // Setup
            var logger = new LoggerStub();
            var dotnet = new DotNetStub([], [], [], []);
            using var feedManager = new FeedManager(logger, dotnet, null,
                new FileProviderStub(), new FeedManagerIOStub([]));

            // Execute
            var feeds = feedManager.MakeNugetExeRestoreFeeds("/path/to/packages.config");

            // Verify
            Assert.Equal(["https://api.nuget.org/v3/index.json"], feeds);
        }

        /// <summary>
        /// Verify that non-base private registries do not prevent NuGet CLI restore from falling back to NuGet.org
        /// when no usable folder feeds remain.
        /// </summary>
        [Theory]
        [InlineData(false)]
        [InlineData(true)]
        public void TestNugetExeRestoreFeedsUseDefaultsWithPrivateRegistries(bool unreachableFolderFeed)
        {
            // Setup
            var logger = new LoggerStub();
            var dotnet = new DotNetStub([], [], [],
                unreachableFolderFeed ? ["E https://feed.from/folder1"] : []);
            using var feedManager = new FeedManager(logger, dotnet, new RegistryProxyStub(),
                new FileProviderStub(), new FeedManagerIOStub(["https://feed.from/folder1"]));

            // Execute
            var feeds = feedManager.MakeNugetExeRestoreFeeds("/path/to/packages.config");

            // Verify
            Assert.Equal(["https://api.nuget.org/v3/index.json"], feeds);
        }

        /// <summary>
        /// Verify that NuGet CLI restore identifies equivalent private registry URLs regardless of host case
        /// or explicit default ports, while preserving case-sensitive registry paths.
        /// </summary>
        [Theory]
        [InlineData("https://EXAMPLE.COM/registry2")]
        [InlineData("https://example.com:443/registry2")]
        [InlineData("https://EXAMPLE.COM:443/registry2")]
        public void TestNugetExeRestoreFeedsCompareRegistryUris(string folderFeed)
        {
            // Setup
            var logger = new LoggerStub();
            var dotnet = new DotNetStub([], [], [], [$"E {folderFeed}"]);
            using var feedManager = new FeedManager(logger, dotnet, new RegistryProxyStub(),
                new FileProviderStub(), new FeedManagerIOStub([]));

            // Execute
            var feeds = feedManager.MakeNugetExeRestoreFeeds("/path/to/packages.config");

            // Verify
            Assert.Equal(["https://api.nuget.org/v3/index.json"], feeds);
        }

        /// <summary>
        /// Verify that `FeedManager` correctly computes the default feeds and reachable default feeds
        /// when no private registries are configured.
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
        /// Verify that `FeedManager` correctly computes the default feeds and reachable default feeds
        /// when private registries are configured to replace the default feeds.
        /// See the initialization of `RegistryProxyStubWithBaseUrls` for the feeds configured to replace the default feeds.
        /// </summary>
        [Fact]
        public void TestDefaultFeedsPrivateRegistries()
        {
            // Setup
            var logger = new LoggerStub();
            var dotnet = new DotNetStub([], [], [], []);
            var registryProxy = new RegistryProxyStubWithBaseUrls();
            var fileProvider = new FileProviderStub();
            var feedManagerIo = new FeedManagerIOStub(["https://example.com/registry2", "https://example.com/base1"]);
            var feedManager = new FeedManager(logger, dotnet, registryProxy, fileProvider, feedManagerIo);

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
        /// Verify that `FeedManager` correctly computes all feeds when https://api.nuget.org/v3/index.json is not replaced
        /// by a private registry because no private registry is configured to replace the base feed.
        /// </summary>
        [Fact]
        public void TestNugetOrgNotReplaced()
        {
            // Setup
            var logger = new LoggerStub();
            var dotnet = new DotNetStub([], [], [], ["E https://api.nuget.org/v3/index.json"]);
            var registryProxy = new RegistryProxyStub();
            var fileProvider = new FileProviderStub();
            var feedManagerIo = new FeedManagerIOStub(["https://example.com/registry2", "https://example.com/base1"]);
            var feedManager = new FeedManager(logger, dotnet, registryProxy, fileProvider, feedManagerIo);

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
        /// Verify that `FeedManager` correctly computes the explicit and all feeds when https://api.nuget.org/v3/index.json and
        /// related NuGet.org URLs are replaced by private registries configured to replace the base feeds.
        /// See the initialization of `RegistryProxyStubWithBaseUrls` for the feeds configured as default replacements.
        /// </summary>
        [Fact]
        public void TestNugetOrgReplacement()
        {
            // Setup
            var logger = new LoggerStub();
            var dotnet = new DotNetStub([], [], ["E https://www.nuget.org/api/v2/"], ["E https://api.nuget.org/v3/index.json"]);
            var registryProxy = new RegistryProxyStubWithBaseUrls();
            var fileProvider = new FileProviderStub();
            var feedManagerIo = new FeedManagerIOStub(["https://example.com/registry2", "https://example.com/base1"]);
            var feedManager = new FeedManager(logger, dotnet, registryProxy, fileProvider, feedManagerIo);

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
