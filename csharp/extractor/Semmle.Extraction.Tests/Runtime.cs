using Xunit;
using System;
using System.Collections.Generic;
using Semmle.Extraction.CSharp.DependencyFetching;

namespace Semmle.Extraction.Tests
{
    internal class DotNetStub : IDotNet
    {
        private readonly IList<string> runtimes;
        private readonly IList<string> sdks;

        public DotNetStub(IList<string> runtimes, IList<string> sdks)
        {
            this.runtimes = runtimes;
            this.sdks = sdks;
        }
        public bool AddPackage(string folder, string package) => true;

        public bool New(string folder) => true;

        public RestoreResult Restore(RestoreSettings restoreSettings) => new(true, Array.Empty<string>());

        public IList<string> GetListedRuntimes() => runtimes;

        public IList<string> GetListedSdks() => sdks;

        public bool Exec(string execArgs) => true;

        public IList<string> GetNugetFeeds(string nugetConfig) => [];

        public IList<string> GetNugetFeedsFromFolder(string folderPath) => [];
    }

    public class RuntimeTests
    {
        private static string FixExpectedPathOnWindows(string path) => path.Replace('\\', '/');

        [Fact]
        public void TestRuntime1()
        {
            // Setup
            var listedRuntimes = new List<string> {
                "Microsoft.AspNetCore.App 5.0.12 [/path/dotnet/shared/Microsoft.AspNetCore.App]",
                "Microsoft.AspNetCore.App 6.0.4 [/path/dotnet/shared/Microsoft.AspNetCore.App]",
                "Microsoft.AspNetCore.App 7.0.0 [/path/dotnet/shared/Microsoft.AspNetCore.App]",
                "Microsoft.AspNetCore.App 7.0.2 [/path/dotnet/shared/Microsoft.AspNetCore.App]",
                "Microsoft.NETCore.App 5.0.12 [/path/dotnet/shared/Microsoft.NETCore.App]",
                "Microsoft.NETCore.App 6.0.4 [/path/dotnet/shared/Microsoft.NETCore.App]",
                "Microsoft.NETCore.App 7.0.0 [/path/dotnet/shared/Microsoft.NETCore.App]",
                "Microsoft.NETCore.App 7.0.2 [/path/dotnet/shared/Microsoft.NETCore.App]"
                };
            var dotnet = new DotNetStub(listedRuntimes, null!);
            var runtime = new Runtime(dotnet);

            // Execute
            var runtimes = runtime.GetNewestRuntimes();

            // Verify
            Assert.Equal(2, runtimes.Count);

            Assert.True(runtimes.TryGetValue("Microsoft.AspNetCore.App", out var aspNetCoreApp));
            Assert.Equal("/path/dotnet/shared/Microsoft.AspNetCore.App/7.0.2", FixExpectedPathOnWindows(aspNetCoreApp.FullPath));

            Assert.True(runtimes.TryGetValue("Microsoft.NETCore.App", out var netCoreApp));
            Assert.Equal("/path/dotnet/shared/Microsoft.NETCore.App/7.0.2", FixExpectedPathOnWindows(netCoreApp.FullPath));
        }

        [Fact]
        public void TestRuntime2()
        {
            // Setup
            var listedRuntimes = new List<string>
            {
                "Microsoft.NETCore.App 7.0.2 [/path/dotnet/shared/Microsoft.NETCore.App]",
                "Microsoft.NETCore.App 8.0.0-preview.5.43280.8 [/path/dotnet/shared/Microsoft.NETCore.App]",
                "Microsoft.NETCore.App 8.0.0-preview.5.23280.8 [/path/dotnet/shared/Microsoft.NETCore.App]"
            };
            var dotnet = new DotNetStub(listedRuntimes, null!);
            var runtime = new Runtime(dotnet);

            // Execute
            var runtimes = runtime.GetNewestRuntimes();

            // Verify
            Assert.Single(runtimes);

            Assert.True(runtimes.TryGetValue("Microsoft.NETCore.App", out var netCoreApp));
            Assert.Equal("/path/dotnet/shared/Microsoft.NETCore.App/8.0.0-preview.5.43280.8", FixExpectedPathOnWindows(netCoreApp.FullPath));
        }

        [Fact]
        public void TestRuntime3()
        {
            // Setup
            var listedRuntimes = new List<string>
            {
                "Microsoft.NETCore.App 7.0.2 [/path/dotnet/shared/Microsoft.NETCore.App]",
                "Microsoft.NETCore.App 8.0.0-rc.4.43280.8 [/path/dotnet/shared/Microsoft.NETCore.App]",
                "Microsoft.NETCore.App 8.0.0-preview.5.23280.8 [/path/dotnet/shared/Microsoft.NETCore.App]"
            };
            var dotnet = new DotNetStub(listedRuntimes, null!);
            var runtime = new Runtime(dotnet);

            // Execute
            var runtimes = runtime.GetNewestRuntimes();

            // Verify
            Assert.Single(runtimes);

            Assert.True(runtimes.TryGetValue("Microsoft.NETCore.App", out var netCoreApp));
            Assert.Equal("/path/dotnet/shared/Microsoft.NETCore.App/8.0.0-rc.4.43280.8", FixExpectedPathOnWindows(netCoreApp.FullPath));
        }

        [Fact]
        public void TestRuntime4()
        {
            // Setup
            var listedRuntimes = new List<string>
            {
                @"Microsoft.AspNetCore.App 6.0.5 [C:\Program Files\dotnet\shared\Microsoft.AspNetCore.App]",
                @"Microsoft.AspNetCore.App 6.0.20 [C:\Program Files\dotnet\shared\Microsoft.AspNetCore.App]",
                @"Microsoft.AspNetCore.App 7.0.2 [C:\Program Files\dotnet\shared\Microsoft.AspNetCore.App]",
                @"Microsoft.NETCore.App 6.0.5 [C:\Program Files\dotnet\shared\Microsoft.NETCore.App]",
                @"Microsoft.NETCore.App 6.0.20 [C:\Program Files\dotnet\shared\Microsoft.NETCore.App]",
                @"Microsoft.NETCore.App 7.0.2 [C:\Program Files\dotnet\shared\Microsoft.NETCore.App]",
                @"Microsoft.WindowsDesktop.App 6.0.5 [C:\Program Files\dotnet\shared\Microsoft.WindowsDesktop.App]",
                @"Microsoft.WindowsDesktop.App 6.0.20 [C:\Program Files\dotnet\shared\Microsoft.WindowsDesktop.App]",
                @"Microsoft.WindowsDesktop.App 7.0.4 [C:\Program Files\dotnet\shared\Microsoft.WindowsDesktop.App]"
            };
            var dotnet = new DotNetStub(listedRuntimes, null!);
            var runtime = new Runtime(dotnet);

            // Execute
            var runtimes = runtime.GetNewestRuntimes();

            // Verify
            Assert.Equal(3, runtimes.Count);

            Assert.True(runtimes.TryGetValue("Microsoft.AspNetCore.App", out var aspNetCoreApp));
            Assert.Equal(@"C:/Program Files/dotnet/shared/Microsoft.AspNetCore.App/7.0.2", FixExpectedPathOnWindows(aspNetCoreApp.FullPath));

            Assert.True(runtimes.TryGetValue("Microsoft.NETCore.App", out var netCoreApp));
            Assert.Equal(@"C:/Program Files/dotnet/shared/Microsoft.NETCore.App/7.0.2", FixExpectedPathOnWindows(netCoreApp.FullPath));
        }
    }

    public class SdkTests
    {
        private static string FixExpectedPathOnWindows(string path) => path.Replace('\\', '/');

        [Fact]
        public void TestSdk1()
        {
            // Setup
            var listedSdks = new List<string>
            {
                "6.0.413 [/usr/local/share/dotnet/sdk1]",
                "7.0.102 [/usr/local/share/dotnet/sdk2]",
                "7.0.302 [/usr/local/share/dotnet/sdk3]",
                "7.0.400 [/usr/local/share/dotnet/sdk4]",
                "5.0.402 [/usr/local/share/dotnet/sdk5]",
                "6.0.102 [/usr/local/share/dotnet/sdk6]",
                "6.0.301 [/usr/local/share/dotnet/sdk7]",
            };
            var dotnet = new DotNetStub(null!, listedSdks);
            var sdk = new Sdk(dotnet, new LoggerStub());

            // Execute
            var version = sdk.Version;

            // Verify
            Assert.NotNull(version);
            Assert.Equal("/usr/local/share/dotnet/sdk4/7.0.400", FixExpectedPathOnWindows(version.FullPath));
        }

        [Fact]
        public void TestSdk2()
        {
            // Setup
            var listedSdks = new List<string>
            {
                "6.0.413 [/usr/local/share/dotnet/sdk1]",
                "7.0.102 [/usr/local/share/dotnet/sdk2]",
                "8.0.100-preview.7.23376.3 [/usr/local/share/dotnet/sdk3]",
                "7.0.400 [/usr/local/share/dotnet/sdk4]",
            };
            var dotnet = new DotNetStub(null!, listedSdks);
            var sdk = new Sdk(dotnet, new LoggerStub());

            // Execute
            var version = sdk.Version;

            // Verify
            Assert.NotNull(version);
            Assert.Equal("/usr/local/share/dotnet/sdk3/8.0.100-preview.7.23376.3", FixExpectedPathOnWindows(version.FullPath));
        }
    }
}
