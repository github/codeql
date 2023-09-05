using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    /// <summary>
    /// Utilities to run the "dotnet" command.
    /// </summary>
    internal partial class DotNet : IDotNet
    {
        private readonly IDotnetCommand dotnet;
        private readonly ProgressMonitor progressMonitor;

        internal DotNet(IDotnetCommand dotnet, ProgressMonitor progressMonitor)
        {
            this.progressMonitor = progressMonitor;
            this.dotnet = dotnet;
            Info();
        }

        public DotNet(IDependencyOptions options, ProgressMonitor progressMonitor) : this(new DotnetCommand(progressMonitor, Path.Combine(options.DotNetPath ?? string.Empty, "dotnet")), progressMonitor) { }


        private void Info()
        {
            // TODO: make sure the below `dotnet` version is matching the one specified in global.json
            var res = dotnet.RunCommand("--info");
            if (!res)
            {
                throw new Exception($"{dotnet.Exec} --info failed.");
            }
        }

        private static string GetRestoreArgs(string projectOrSolutionFile, string packageDirectory) =>
            $"restore --no-dependencies \"{projectOrSolutionFile}\" --packages \"{packageDirectory}\" /p:DisableImplicitNuGetFallbackFolder=true";

        public bool RestoreProjectToDirectory(string projectFile, string packageDirectory, out string stdout, string? pathToNugetConfig = null)
        {
            var args = GetRestoreArgs(projectFile, packageDirectory);
            if (pathToNugetConfig != null)
            {
                args += $" --configfile \"{pathToNugetConfig}\"";
            }
            var success = dotnet.RunCommand(args, out var output);
            stdout = string.Join("\n", output);
            return success;
        }

        public bool RestoreSolutionToDirectory(string solutionFile, string packageDirectory, out IEnumerable<string> projects)
        {
            var args = GetRestoreArgs(solutionFile, packageDirectory);
            args += " --verbosity normal";
            if (dotnet.RunCommand(args, out var output))
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
            return dotnet.RunCommand(args);
        }

        public bool AddPackage(string folder, string package)
        {
            var args = $"add \"{folder}\" package \"{package}\" --no-restore";
            return dotnet.RunCommand(args);
        }

        public IList<string> GetListedRuntimes() => GetListed("--list-runtimes", "runtime");

        public IList<string> GetListedSdks() => GetListed("--list-sdks", "SDK");

        private IList<string> GetListed(string args, string artifact)
        {
            if (dotnet.RunCommand(args, out var artifacts))
            {
                progressMonitor.LogInfo($"Found {artifact}s: {string.Join("\n", artifacts)}");
                return artifacts;
            }
            return new List<string>();
        }

        public bool Exec(string execArgs)
        {
            var args = $"exec {execArgs}";
            return dotnet.RunCommand(args);
        }

        [GeneratedRegex("Restored\\s+(.+\\.csproj)", RegexOptions.Compiled)]
        private static partial Regex RestoreProjectRegex();
    }
}
