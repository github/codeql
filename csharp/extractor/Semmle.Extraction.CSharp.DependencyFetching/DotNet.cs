using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    /// <summary>
    /// Utilities to run the "dotnet" command.
    /// </summary>
    internal partial class DotNet : IDotNet
    {
        private readonly IDotNetCliInvoker dotnetCliInvoker;
        private readonly ProgressMonitor progressMonitor;
        private readonly TemporaryDirectory? tempWorkingDirectory;

        private DotNet(IDotNetCliInvoker dotnetCliInvoker, ProgressMonitor progressMonitor, TemporaryDirectory? tempWorkingDirectory = null)
        {
            this.progressMonitor = progressMonitor;
            this.tempWorkingDirectory = tempWorkingDirectory;
            this.dotnetCliInvoker = dotnetCliInvoker;
            Info();
        }

        private DotNet(IDependencyOptions options, ProgressMonitor progressMonitor, TemporaryDirectory tempWorkingDirectory) : this(new DotNetCliInvoker(progressMonitor, Path.Combine(options.DotNetPath ?? string.Empty, "dotnet")), progressMonitor, tempWorkingDirectory) { }

        internal static IDotNet Make(IDotNetCliInvoker dotnetCliInvoker, ProgressMonitor progressMonitor) => new DotNet(dotnetCliInvoker, progressMonitor);

        public static IDotNet Make(IDependencyOptions options, ProgressMonitor progressMonitor, TemporaryDirectory tempWorkingDirectory) => new DotNet(options, progressMonitor, tempWorkingDirectory);

        private void Info()
        {
            // TODO: make sure the below `dotnet` version is matching the one specified in global.json
            var res = dotnetCliInvoker.RunCommand("--info");
            if (!res)
            {
                throw new Exception($"{dotnetCliInvoker.Exec} --info failed.");
            }
        }

        private string GetRestoreArgs(string projectOrSolutionFile, string packageDirectory, bool forceDotnetRefAssemblyFetching)
        {
            var args = $"restore --no-dependencies \"{projectOrSolutionFile}\" --packages \"{packageDirectory}\" /p:DisableImplicitNuGetFallbackFolder=true";

            if (forceDotnetRefAssemblyFetching)
            {
                // Ugly hack: we set the TargetFrameworkRootPath and NetCoreTargetingPackRoot properties to an empty folder:
                var path = ".empty";
                if (tempWorkingDirectory != null)
                {
                    path = Path.Combine(tempWorkingDirectory.ToString(), "emptyFakeDotnetRoot");
                    Directory.CreateDirectory(path);
                }

                args += $" /p:TargetFrameworkRootPath=\"{path}\" /p:NetCoreTargetingPackRoot=\"{path}\"";
            }

            return args;
        }

        public bool RestoreProjectToDirectory(string projectFile, string packageDirectory, bool forceDotnetRefAssemblyFetching, string? pathToNugetConfig = null)
        {
            var args = GetRestoreArgs(projectFile, packageDirectory, forceDotnetRefAssemblyFetching);
            if (pathToNugetConfig != null)
            {
                args += $" --configfile \"{pathToNugetConfig}\"";
            }

            return dotnetCliInvoker.RunCommand(args);
        }

        public bool RestoreSolutionToDirectory(string solutionFile, string packageDirectory, bool forceDotnetRefAssemblyFetching, out IEnumerable<string> projects)
        {
            var args = GetRestoreArgs(solutionFile, packageDirectory, forceDotnetRefAssemblyFetching);
            args += " --verbosity normal";
            if (dotnetCliInvoker.RunCommand(args, out var output))
            {
                var regex = RestoreProjectRegex();
                projects = output
                    .Select(line => regex.Match(line))
                    .Where(match => match.Success)
                    .Select(match => match.Groups[1].Value);
                return true;
            }

            projects = Array.Empty<string>();
            return false;
        }

        public bool New(string folder)
        {
            var args = $"new console --no-restore --output \"{folder}\"";
            return dotnetCliInvoker.RunCommand(args);
        }

        public bool AddPackage(string folder, string package)
        {
            var args = $"add \"{folder}\" package \"{package}\" --no-restore";
            return dotnetCliInvoker.RunCommand(args);
        }

        public IList<string> GetListedRuntimes() => GetListed("--list-runtimes", "runtime");

        public IList<string> GetListedSdks() => GetListed("--list-sdks", "SDK");

        private IList<string> GetListed(string args, string artifact)
        {
            if (dotnetCliInvoker.RunCommand(args, out var artifacts))
            {
                return artifacts;
            }
            return new List<string>();
        }

        public bool Exec(string execArgs)
        {
            var args = $"exec {execArgs}";
            return dotnetCliInvoker.RunCommand(args);
        }

        [GeneratedRegex("Restored\\s+(.+\\.csproj)", RegexOptions.Compiled)]
        private static partial Regex RestoreProjectRegex();
    }
}
