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
        private readonly IDotNetCliInvoker dotnetCliInvoker;
        private readonly ProgressMonitor progressMonitor;

        private DotNet(IDotNetCliInvoker dotnetCliInvoker, ProgressMonitor progressMonitor)
        {
            this.progressMonitor = progressMonitor;
            this.dotnetCliInvoker = dotnetCliInvoker;
            Info();
        }

        private DotNet(IDependencyOptions options, ProgressMonitor progressMonitor) : this(new DotNetCliInvoker(progressMonitor, Path.Combine(options.DotNetPath ?? string.Empty, "dotnet")), progressMonitor) { }

        internal static IDotNet Make(IDotNetCliInvoker dotnetCliInvoker, ProgressMonitor progressMonitor) => new DotNet(dotnetCliInvoker, progressMonitor);

        public static IDotNet Make(IDependencyOptions options, ProgressMonitor progressMonitor) => new DotNet(options, progressMonitor);

        private void Info()
        {
            // TODO: make sure the below `dotnet` version is matching the one specified in global.json
            var res = dotnetCliInvoker.RunCommand("--info");
            if (!res)
            {
                throw new Exception($"{dotnetCliInvoker.Exec} --info failed.");
            }
        }

        private bool RunCommand(string args, out string stdout)
        {
            var success = dotnetCliInvoker.RunCommand(args, out var output);
            stdout = string.Join("\n", output);
            return success;
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

            return RunCommand(args, out stdout);
        }

        public bool RestoreSolutionToDirectory(string solutionFile, string packageDirectory, out IEnumerable<string> projects)
        {
            var args = GetRestoreArgs(solutionFile, packageDirectory);
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

        public bool New(string folder, out string stdout)
        {
            var args = $"new console --no-restore --output \"{folder}\"";
            return RunCommand(args, out stdout);
        }

        public bool AddPackage(string folder, string package, out string stdout)
        {
            var args = $"add \"{folder}\" package \"{package}\" --no-restore";
            return RunCommand(args, out stdout);
        }

        public IList<string> GetListedRuntimes() => GetListed("--list-runtimes", "runtime");

        public IList<string> GetListedSdks() => GetListed("--list-sdks", "SDK");

        private IList<string> GetListed(string args, string artifact)
        {
            if (dotnetCliInvoker.RunCommand(args, out IList<string> artifacts))
            {
                progressMonitor.LogInfo($"Found {artifact}s: {string.Join("\n", artifacts)}");
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
