﻿using System;
using System.Collections.Generic;
using System.Diagnostics;
using Semmle.Util;

namespace Semmle.BuildAnalyser
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
            progressMonitor.RunningProcess($"{dotnet} --info");
            using var proc = Process.Start(dotnet, "--info");
            proc.WaitForExit();
            var ret = proc.ExitCode;

            if (ret != 0)
            {
                progressMonitor.CommandFailed(dotnet, "--info", ret);
                throw new Exception($"{dotnet} --info failed with exit code {ret}.");
            }
        }

        private bool RunCommand(string args)
        {
            progressMonitor.RunningProcess($"{dotnet} {args}");
            using var proc = Process.Start(dotnet, args);
            proc.WaitForExit();
            if (proc.ExitCode != 0)
            {
                progressMonitor.CommandFailed(dotnet, args, proc.ExitCode);
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

        public bool Exec(string execArgs)
        {
            // TODO: we might need to swallow the stdout of the started process to not pollute the logs of the extraction.
            var args = $"exec {execArgs}";
            return RunCommand(args);
        }

        public IList<string> GetListedRuntimes()
        {
            var args = "--list-runtimes";
            var pi = new ProcessStartInfo(dotnet, args)
            {
                RedirectStandardOutput = true,
                UseShellExecute = false
            };
            var exitCode = pi.ReadOutput(out var runtimes);
            if (exitCode != 0)
            {
                progressMonitor.CommandFailed(dotnet, args, exitCode);
                return new List<string>();
            }
            return runtimes;
        }

        public IList<string> GetListedSdks()
        {
            var args = "--list-sdks";
            var pi = new ProcessStartInfo(dotnet, args)
            {
                RedirectStandardOutput = true,
                UseShellExecute = false
            };
            var exitCode = pi.ReadOutput(out var sdks);
            if (exitCode != 0)
            {
                progressMonitor.CommandFailed(dotnet, args, exitCode);
                return new List<string>();
            }
            return sdks;
        }
    }
}
