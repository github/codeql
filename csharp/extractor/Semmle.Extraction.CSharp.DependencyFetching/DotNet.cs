using System;
using System.Collections.Generic;
using System.Diagnostics;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    /// <summary>
    /// Utilities to run the "dotnet" command.
    /// </summary>
    internal class DotNet : IDotNet
    {
        private const string dotnet = "dotnet";
        private readonly ProgressMonitor progressMonitor;

        public DotNet(ProgressMonitor progressMonitor)
        {
            this.progressMonitor = progressMonitor;
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

        private static ProcessStartInfo MakeDotnetStartInfo(string args, bool redirectStandardOutput) =>
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

        public bool RestoreToDirectory(string projectOrSolutionFile, string packageDirectory, string? pathToNugetConfig = null)
        {
            var args = $"restore --no-dependencies \"{projectOrSolutionFile}\" --packages \"{packageDirectory}\" /p:DisableImplicitNuGetFallbackFolder=true";
            if (pathToNugetConfig != null)
                args += $" --configfile \"{pathToNugetConfig}\"";
            return RunCommand(args);
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
            progressMonitor.RunningProcess($"{dotnet} {args}");
            var pi = MakeDotnetStartInfo(args, redirectStandardOutput: true);
            var exitCode = pi.ReadOutput(out var artifacts);
            if (exitCode != 0)
            {
                progressMonitor.CommandFailed(dotnet, args, exitCode);
                return new List<string>();
            }
            progressMonitor.LogInfo($"Found {artifact}s: {string.Join("\n", artifacts)}");
            return artifacts;
        }

        public bool Exec(string execArgs)
        {
            var args = $"exec {execArgs}";
            return RunCommand(args);
        }
    }
}
