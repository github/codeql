using System;
using System.Collections.Generic;
using System.Diagnostics;
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
        private readonly ProgressMonitor progressMonitor;
        private readonly string dotnet;

        public DotNet(IDependencyOptions options, ProgressMonitor progressMonitor)
        {
            this.progressMonitor = progressMonitor;
            this.dotnet = Path.Combine(options.DotNetPath ?? string.Empty, "dotnet");
            Info();
        }

        private void Info()
        {
            // TODO: make sure the below `dotnet` version is matching the one specified in global.json
            var res = RunCommand("--info");
            if (!res)
            {
                throw new Exception($"{dotnet} --info failed.");
            }
        }

        private ProcessStartInfo MakeDotnetStartInfo(string args, bool redirectStandardOutput) =>
            new ProcessStartInfo(dotnet, args)
            {
                UseShellExecute = false,
                RedirectStandardOutput = redirectStandardOutput
            };

        private bool RunCommand(string args)
        {
            progressMonitor.RunningProcess($"{dotnet} {args}");
            using var proc = Process.Start(MakeDotnetStartInfo(args, redirectStandardOutput: false));
            proc?.WaitForExit();
            var exitCode = proc?.ExitCode ?? -1;
            if (exitCode != 0)
            {
                progressMonitor.CommandFailed(dotnet, args, exitCode);
                return false;
            }
            return true;
        }

        private bool RunCommand(string args, out IList<string> output)
        {
            progressMonitor.RunningProcess($"{dotnet} {args}");
            var pi = MakeDotnetStartInfo(args, redirectStandardOutput: true);
            var exitCode = pi.ReadOutput(out output);
            if (exitCode != 0)
            {
                progressMonitor.CommandFailed(dotnet, args, exitCode);
                return false;
            }
            return true;
        }

        private static string GetRestoreArgs(string projectOrSolutionFile, string packageDirectory) =>
            $"restore --no-dependencies \"{projectOrSolutionFile}\" --packages \"{packageDirectory}\" /p:DisableImplicitNuGetFallbackFolder=true";

        public bool RestoreProjectToDirectory(string projectFile, string packageDirectory, string? pathToNugetConfig = null)
        {
            var args = GetRestoreArgs(projectFile, packageDirectory);
            if (pathToNugetConfig != null)
            {
                args += $" --configfile \"{pathToNugetConfig}\"";
            }
            return RunCommand(args);
        }

        public bool RestoreSolutionToDirectory(string solutionFile, string packageDirectory, out IList<string> projects)
        {
            var args = GetRestoreArgs(solutionFile, packageDirectory);
            args += " --verbosity normal";
            if (RunCommand(args, out var output))
            {
                var regex = RestoreProjectRegex();
                projects = output
                    .Select(line => regex.Match(line))
                    .Where(match => match.Success)
                    .Select(match => match.Groups[1].Value)
                    .ToList();
                return true;
            }

            projects = new List<string>();
            return false;
        }

        public bool New(string folder)
        {
            var args = $"new console --no-restore --output \"{folder}\"";
            return RunCommand(args);
        }

        public bool AddPackage(string folder, string package)
        {
            var args = $"add \"{folder}\" package \"{package}\" --no-restore";
            return RunCommand(args);
        }

        public IList<string> GetListedRuntimes() => GetListed("--list-runtimes", "runtime");

        public IList<string> GetListedSdks() => GetListed("--list-sdks", "SDK");

        private IList<string> GetListed(string args, string artifact)
        {
            if (RunCommand(args, out var artifacts))
            {
                progressMonitor.LogInfo($"Found {artifact}s: {string.Join("\n", artifacts)}");
                return artifacts;
            }
            return new List<string>();
        }

        public bool Exec(string execArgs)
        {
            var args = $"exec {execArgs}";
            return RunCommand(args);
        }

        [GeneratedRegex("Restored\\s+(.+\\.csproj)", RegexOptions.Compiled)]
        private static partial Regex RestoreProjectRegex();
    }
}
