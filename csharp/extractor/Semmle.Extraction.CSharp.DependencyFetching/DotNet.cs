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
            var args = $"restore --no-dependencies \"{projectOrSolutionFile}\" --packages \"{packageDirectory}\" /p:DisableImplicitNuGetFallbackFolder=true --verbosity normal";

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

        private static IEnumerable<string> GetFirstGroupOnMatch(Regex regex, IEnumerable<string> lines) =>
            lines
                .Select(line => regex.Match(line))
                .Where(match => match.Success)
                .Select(match => match.Groups[1].Value);

        private static IEnumerable<string> GetAssetsFilePaths(IEnumerable<string> lines) =>
            GetFirstGroupOnMatch(AssetsFileRegex(), lines);

        private static IEnumerable<string> GetRestoredProjects(IEnumerable<string> lines) =>
            GetFirstGroupOnMatch(RestoredProjectRegex(), lines);

        public bool RestoreProjectToDirectory(string projectFile, string packageDirectory, bool forceDotnetRefAssemblyFetching, out IEnumerable<string> assets, string? pathToNugetConfig = null)
        {
            var args = GetRestoreArgs(projectFile, packageDirectory, forceDotnetRefAssemblyFetching);
            if (pathToNugetConfig != null)
            {
                args += $" --configfile \"{pathToNugetConfig}\"";
            }

            var success = dotnetCliInvoker.RunCommand(args, out var output);
            assets = success ? GetAssetsFilePaths(output) : Array.Empty<string>();
            return success;
        }

        public bool RestoreSolutionToDirectory(string solutionFile, string packageDirectory, bool forceDotnetRefAssemblyFetching, out IEnumerable<string> projects, out IEnumerable<string> assets)
        {
            var args = GetRestoreArgs(solutionFile, packageDirectory, forceDotnetRefAssemblyFetching);
            var success = dotnetCliInvoker.RunCommand(args, out var output);
            projects = success ? GetRestoredProjects(output) : Array.Empty<string>();
            assets = success ? GetAssetsFilePaths(output) : Array.Empty<string>();
            return success;
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
        private static partial Regex RestoredProjectRegex();

        [GeneratedRegex("[Assets\\sfile\\shas\\snot\\schanged.\\sSkipping\\sassets\\sfile\\swriting.|Writing\\sassets\\sfile\\sto\\sdisk.]\\sPath:\\s(.+)", RegexOptions.Compiled)]
        private static partial Regex AssetsFileRegex();
    }
}
