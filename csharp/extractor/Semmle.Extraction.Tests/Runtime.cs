using Xunit;
using System.Collections.Generic;
using Semmle.BuildAnalyser;
using Semmle.Extraction.CSharp.Standalone;

namespace Semmle.Extraction.Tests
{
    internal class DotNetStub : IDotNet
    {
        private readonly IList<string> runtimes;

        public DotNetStub(IList<string> runtimes) => this.runtimes = runtimes;

        public bool AddPackage(string folder, string package) => true;

        public bool New(string folder) => true;

        public bool RestoreToDirectory(string project, string directory, string? pathToNugetConfig = null) => true;

        public IList<string> GetListedRuntimes() => runtimes;

        public IList<string> GetListedSdks() => new List<string>();

        public bool Exec(string execArgs) => true;
    }

    public class RuntimeTests
    {
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
            var dotnet = new DotNetStub(listedRuntimes);
            var runtime = new Runtime(dotnet);

            // Execute
            var runtimes = runtime.GetNewestRuntimes();

            // Verify
            Assert.Equal(2, runtimes.Count);

            Assert.True(runtimes.TryGetValue("Microsoft.AspNetCore.App", out var aspNetCoreApp));
            Assert.Equal("/path/dotnet/shared/Microsoft.AspNetCore.App/7.0.2", aspNetCoreApp.FullPath);

            Assert.True(runtimes.TryGetValue("Microsoft.NETCore.App", out var netCoreApp));
            Assert.Equal("/path/dotnet/shared/Microsoft.NETCore.App/7.0.2", netCoreApp.FullPath);
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
            var dotnet = new DotNetStub(listedRuntimes);
            var runtime = new Runtime(dotnet);

            // Execute
            var runtimes = runtime.GetNewestRuntimes();

            // Verify
            Assert.Single(runtimes);

            Assert.True(runtimes.TryGetValue("Microsoft.NETCore.App", out var netCoreApp));
            Assert.Equal("/path/dotnet/shared/Microsoft.NETCore.App/8.0.0-preview.5.43280.8", netCoreApp.FullPath);
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
            var dotnet = new DotNetStub(listedRuntimes);
            var runtime = new Runtime(dotnet);

            // Execute
            var runtimes = runtime.GetNewestRuntimes();

            // Verify
            Assert.Single(runtimes);

            Assert.True(runtimes.TryGetValue("Microsoft.NETCore.App", out var netCoreApp));
            Assert.Equal("/path/dotnet/shared/Microsoft.NETCore.App/8.0.0-rc.4.43280.8", netCoreApp.FullPath);
        }

    }
}
