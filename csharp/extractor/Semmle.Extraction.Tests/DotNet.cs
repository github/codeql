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
        public bool Success { get; set; } = true;

        public DotNetCliInvokerStub(IList<string> output)
        {
            this.output = output;
        }

        public string Exec => "dotnet";

        public bool RunCommand(string args)
        {
            lastArgs = args;
            return Success;
        }

        public bool RunCommand(string args, out IList<string> output)
        {
            lastArgs = args;
            output = this.output;
            return Success;
        }

        public string GetLastArgs() => lastArgs;
    }

    public class DotNetTests
    {
        private static IDotNet MakeDotnet(IDotNetCliInvoker dotnetCliInvoker) =>
            DotNet.Make(dotnetCliInvoker, new ProgressMonitor(new LoggerStub()));

        private static IList<string> MakeDotnetRestoreOutput() =>
            new List<string> {
                "  Determining projects to restore...",
                "  Restored /path/to/project.csproj (in 1.23 sec).",
                "  Other output...",
                "  More output...",
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
            var _ = MakeDotnet(dotnetCliInvoker);

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
                var _ = MakeDotnet(dotnetCliInvoker);
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
            dotnet.RestoreProjectToDirectory("myproject.csproj", "mypackages", false);

            // Verify
            var lastArgs = dotnetCliInvoker.GetLastArgs();
            Assert.Equal("restore --no-dependencies \"myproject.csproj\" --packages \"mypackages\" /p:DisableImplicitNuGetFallbackFolder=true", lastArgs);
        }

        [Fact]
        public void TestDotnetRestoreProjectToDirectory2()
        {
            // Setup
            var dotnetCliInvoker = new DotNetCliInvokerStub(new List<string>());
            var dotnet = MakeDotnet(dotnetCliInvoker);

            // Execute
            dotnet.RestoreProjectToDirectory("myproject.csproj", "mypackages", false, "myconfig.config");

            // Verify
            var lastArgs = dotnetCliInvoker.GetLastArgs();
            Assert.Equal("restore --no-dependencies \"myproject.csproj\" --packages \"mypackages\" /p:DisableImplicitNuGetFallbackFolder=true --configfile \"myconfig.config\"", lastArgs);
        }

        [Fact]
        public void TestDotnetRestoreSolutionToDirectory1()
        {
            // Setup
            var dotnetCliInvoker = new DotNetCliInvokerStub(MakeDotnetRestoreOutput());
            var dotnet = MakeDotnet(dotnetCliInvoker);

            // Execute
            dotnet.RestoreSolutionToDirectory("mysolution.sln", "mypackages", false, out var projects);

            // Verify
            var lastArgs = dotnetCliInvoker.GetLastArgs();
            Assert.Equal("restore --no-dependencies \"mysolution.sln\" --packages \"mypackages\" /p:DisableImplicitNuGetFallbackFolder=true --verbosity normal", lastArgs);
            Assert.Equal(2, projects.Count());
            Assert.Contains("/path/to/project.csproj", projects);
            Assert.Contains("/path/to/project2.csproj", projects);
        }

        [Fact]
        public void TestDotnetRestoreSolutionToDirectory2()
        {
            // Setup
            var dotnetCliInvoker = new DotNetCliInvokerStub(MakeDotnetRestoreOutput());
            var dotnet = MakeDotnet(dotnetCliInvoker);
            dotnetCliInvoker.Success = false;

            // Execute
            dotnet.RestoreSolutionToDirectory("mysolution.sln", "mypackages", false, out var projects);

            // Verify
            var lastArgs = dotnetCliInvoker.GetLastArgs();
            Assert.Equal("restore --no-dependencies \"mysolution.sln\" --packages \"mypackages\" /p:DisableImplicitNuGetFallbackFolder=true --verbosity normal", lastArgs);
            Assert.Empty(projects);
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
    }
}
