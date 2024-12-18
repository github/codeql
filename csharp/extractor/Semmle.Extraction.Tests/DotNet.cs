using Xunit;
using System.Collections.Generic;
using Semmle.Extraction.CSharp.DependencyFetching;
using System;
using System.Linq;

namespace Semmle.Extraction.Tests
{
    internal class DotNetCliInvokerStub : IDotNetCliInvoker
    {
        private readonly IList<string> output;
        private string lastArgs = "";
        public string WorkingDirectory { get; private set; } = "";
        public bool Success { get; set; } = true;

        public DotNetCliInvokerStub(IList<string> output)
        {
            this.output = output;
        }

        public string Exec => "dotnet";

        public bool RunCommand(string args, bool silent)
        {
            lastArgs = args;
            return Success;
        }

        public bool RunCommand(string args, out IList<string> output, bool silent)
        {
            lastArgs = args;
            output = this.output;
            return Success;
        }

        public bool RunCommand(string args, string? workingDirectory, out IList<string> output, bool silent)
        {
            WorkingDirectory = workingDirectory ?? "";
            return RunCommand(args, out output, silent);
        }

        public string GetLastArgs() => lastArgs;
    }

    public class DotNetTests
    {
        private static IDotNet MakeDotnet(IDotNetCliInvoker dotnetCliInvoker) =>
            DotNet.Make(dotnetCliInvoker, new LoggerStub());

        private static IList<string> MakeDotnetRestoreOutput() =>
            new List<string> {
                "  Determining projects to restore...",
                "  Writing assets file to disk. Path: /path/to/project.assets.json",
                "  Restored /path/to/project.csproj (in 1.23 sec).",
                "  Other output...",
                "  More output...",
                "  Assets file has not changed. Skipping assets file writing. Path: /path/to/project2.assets.json",
                "  Restored /path/to/project2.csproj (in 4.56 sec).",
                "  Other output...",
                };

        private static IList<string> MakeDotnetListRuntimesOutput() =>
            new List<string> {
                "Microsoft.AspNetCore.App 7.0.2 [/path/dotnet/shared/Microsoft.AspNetCore.App]",
                "Microsoft.NETCore.App 7.0.2 [/path/dotnet/shared/Microsoft.NETCore.App]"
            };

        [Fact]
        public void TestDotnetInfo()
        {
            // Setup
            var dotnetCliInvoker = new DotNetCliInvokerStub(new List<string>());

            // Execute
            _ = MakeDotnet(dotnetCliInvoker);

            // Verify
            var lastArgs = dotnetCliInvoker.GetLastArgs();
            Assert.Equal("--info", lastArgs);
        }

        [Fact]
        public void TestDotnetInfoFailure()
        {
            // Setup
            var dotnetCliInvoker = new DotNetCliInvokerStub(new List<string>()) { Success = false };

            // Execute
            try
            {
                _ = MakeDotnet(dotnetCliInvoker);
            }

            // Verify
            catch (Exception e)
            {
                Assert.Equal("dotnet --info failed.", e.Message);
                return;
            }
            Assert.Fail("Expected exception");
        }

        [Fact]
        public void TestDotnetRestoreProjectToDirectory1()
        {
            // Setup
            var dotnetCliInvoker = new DotNetCliInvokerStub(new List<string>());
            var dotnet = MakeDotnet(dotnetCliInvoker);

            // Execute
            dotnet.Restore(new("myproject.csproj", "mypackages", false));

            // Verify
            var lastArgs = dotnetCliInvoker.GetLastArgs();
            Assert.Equal("restore --no-dependencies \"myproject.csproj\" --packages \"mypackages\" /p:DisableImplicitNuGetFallbackFolder=true --verbosity normal", lastArgs);
        }

        [Fact]
        public void TestDotnetRestoreProjectToDirectory2()
        {
            // Setup
            var dotnetCliInvoker = new DotNetCliInvokerStub(MakeDotnetRestoreOutput());
            var dotnet = MakeDotnet(dotnetCliInvoker);

            // Execute
            var res = dotnet.Restore(new("myproject.csproj", "mypackages", false, "myconfig.config"));

            // Verify
            var lastArgs = dotnetCliInvoker.GetLastArgs();
            Assert.Equal("restore --no-dependencies \"myproject.csproj\" --packages \"mypackages\" /p:DisableImplicitNuGetFallbackFolder=true --verbosity normal --configfile \"myconfig.config\"", lastArgs);
            Assert.Equal(2, res.AssetsFilePaths.Count());
            Assert.Contains("/path/to/project.assets.json", res.AssetsFilePaths);
            Assert.Contains("/path/to/project2.assets.json", res.AssetsFilePaths);
        }

        [Fact]
        public void TestDotnetRestoreProjectToDirectory3()
        {
            // Setup
            var dotnetCliInvoker = new DotNetCliInvokerStub(MakeDotnetRestoreOutput());
            var dotnet = MakeDotnet(dotnetCliInvoker);

            // Execute
            var res = dotnet.Restore(new("myproject.csproj", "mypackages", false, "myconfig.config", true));

            // Verify
            var lastArgs = dotnetCliInvoker.GetLastArgs();
            Assert.Equal("restore --no-dependencies \"myproject.csproj\" --packages \"mypackages\" /p:DisableImplicitNuGetFallbackFolder=true --verbosity normal --configfile \"myconfig.config\" --force", lastArgs);
            Assert.Equal(2, res.AssetsFilePaths.Count());
            Assert.Contains("/path/to/project.assets.json", res.AssetsFilePaths);
            Assert.Contains("/path/to/project2.assets.json", res.AssetsFilePaths);
        }

        [Fact]
        public void TestDotnetRestoreSolutionToDirectory1()
        {
            // Setup
            var dotnetCliInvoker = new DotNetCliInvokerStub(MakeDotnetRestoreOutput());
            var dotnet = MakeDotnet(dotnetCliInvoker);

            // Execute
            var res = dotnet.Restore(new("mysolution.sln", "mypackages", false));

            // Verify
            var lastArgs = dotnetCliInvoker.GetLastArgs();
            Assert.Equal("restore --no-dependencies \"mysolution.sln\" --packages \"mypackages\" /p:DisableImplicitNuGetFallbackFolder=true --verbosity normal", lastArgs);
            Assert.Equal(2, res.RestoredProjects.Count());
            Assert.Contains("/path/to/project.csproj", res.RestoredProjects);
            Assert.Contains("/path/to/project2.csproj", res.RestoredProjects);
            Assert.Equal(2, res.AssetsFilePaths.Count());
            Assert.Contains("/path/to/project.assets.json", res.AssetsFilePaths);
            Assert.Contains("/path/to/project2.assets.json", res.AssetsFilePaths);
        }

        [Fact]
        public void TestDotnetRestoreSolutionToDirectory2()
        {
            // Setup
            var dotnetCliInvoker = new DotNetCliInvokerStub(MakeDotnetRestoreOutput());
            var dotnet = MakeDotnet(dotnetCliInvoker);
            dotnetCliInvoker.Success = false;

            // Execute
            var res = dotnet.Restore(new("mysolution.sln", "mypackages", false));

            // Verify
            var lastArgs = dotnetCliInvoker.GetLastArgs();
            Assert.Equal("restore --no-dependencies \"mysolution.sln\" --packages \"mypackages\" /p:DisableImplicitNuGetFallbackFolder=true --verbosity normal", lastArgs);
            Assert.Empty(res.RestoredProjects);
            Assert.Empty(res.AssetsFilePaths);
        }

        [Fact]
        public void TestDotnetNew()
        {
            // Setup
            var dotnetCliInvoker = new DotNetCliInvokerStub(new List<string>());
            var dotnet = MakeDotnet(dotnetCliInvoker);

            // Execute
            dotnet.New("myfolder");

            // Verify
            var lastArgs = dotnetCliInvoker.GetLastArgs();
            Assert.Equal("new console --no-restore --output \"myfolder\"", lastArgs);
        }

        [Fact]
        public void TestDotnetAddPackage()
        {
            // Setup
            var dotnetCliInvoker = new DotNetCliInvokerStub(new List<string>());
            var dotnet = MakeDotnet(dotnetCliInvoker);

            // Execute
            dotnet.AddPackage("myfolder", "mypackage");

            // Verify
            var lastArgs = dotnetCliInvoker.GetLastArgs();
            Assert.Equal("add \"myfolder\" package \"mypackage\" --no-restore", lastArgs);
        }

        [Fact]
        public void TestDotnetGetListedRuntimes1()
        {
            // Setup
            var dotnetCliInvoker = new DotNetCliInvokerStub(MakeDotnetListRuntimesOutput());
            var dotnet = MakeDotnet(dotnetCliInvoker);

            // Execute
            var runtimes = dotnet.GetListedRuntimes();

            // Verify
            var lastArgs = dotnetCliInvoker.GetLastArgs();
            Assert.Equal("--list-runtimes", lastArgs);
            Assert.Equal(2, runtimes.Count);
            Assert.Contains("Microsoft.AspNetCore.App 7.0.2 [/path/dotnet/shared/Microsoft.AspNetCore.App]", runtimes);
            Assert.Contains("Microsoft.NETCore.App 7.0.2 [/path/dotnet/shared/Microsoft.NETCore.App]", runtimes);
        }

        [Fact]
        public void TestDotnetGetListedRuntimes2()
        {
            // Setup
            var dotnetCliInvoker = new DotNetCliInvokerStub(MakeDotnetListRuntimesOutput());
            var dotnet = MakeDotnet(dotnetCliInvoker);
            dotnetCliInvoker.Success = false;

            // Execute
            var runtimes = dotnet.GetListedRuntimes();

            // Verify
            var lastArgs = dotnetCliInvoker.GetLastArgs();
            Assert.Equal("--list-runtimes", lastArgs);
            Assert.Empty(runtimes);
        }

        [Fact]
        public void TestDotnetExec()
        {
            // Setup
            var dotnetCliInvoker = new DotNetCliInvokerStub(new List<string>());
            var dotnet = MakeDotnet(dotnetCliInvoker);

            // Execute
            dotnet.Exec("myarg1 myarg2");

            // Verify
            var lastArgs = dotnetCliInvoker.GetLastArgs();
            Assert.Equal("exec myarg1 myarg2", lastArgs);
        }

        [Fact]
        public void TestNugetFeeds()
        {
            // Setup
            var dotnetCliInvoker = new DotNetCliInvokerStub(new List<string>());
            var dotnet = MakeDotnet(dotnetCliInvoker);

            // Execute
            dotnet.GetNugetFeeds("abc");

            // Verify
            var lastArgs = dotnetCliInvoker.GetLastArgs();
            Assert.Equal("nuget list source --format Short --configfile \"abc\"", lastArgs);
        }

        [Fact]
        public void TestNugetFeedsFromFolder()
        {
            // Setup
            var dotnetCliInvoker = new DotNetCliInvokerStub(new List<string>());
            var dotnet = MakeDotnet(dotnetCliInvoker);

            // Execute
            dotnet.GetNugetFeedsFromFolder("abc");

            // Verify
            var lastArgs = dotnetCliInvoker.GetLastArgs();
            Assert.Equal("nuget list source --format Short", lastArgs);
            Assert.Equal("abc", dotnetCliInvoker.WorkingDirectory);
        }
    }
}
