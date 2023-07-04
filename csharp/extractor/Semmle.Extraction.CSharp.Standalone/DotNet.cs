using System;
using System.Diagnostics;

namespace Semmle.BuildAnalyser
{
    /// <summary>
    /// Utilities to run the "dotnet" command.
    /// </summary>
    internal class DotNet
    {
        private readonly ProgressMonitor progressMonitor;

        public DotNet(ProgressMonitor progressMonitor)
        {
            this.progressMonitor = progressMonitor;
            Info();
        }

        private void Info()
        {
            try
            {
                progressMonitor.RunningProcess("dotnet --info");
                using var proc = Process.Start("dotnet", "--info");
                proc.WaitForExit();
                var ret = proc.ExitCode;
                if (ret != 0)
                {
                    progressMonitor.CommandFailed("dotnet", "--info", ret);
                    throw new Exception($"dotnet --info failed with exit code {ret}.");
                }
            }
            catch (Exception ex)
            {
                throw new Exception("dotnet --info failed.", ex);
            }
        }

        private bool RunCommand(string args)
        {
            progressMonitor.RunningProcess($"dotnet {args}");
            using var proc = Process.Start("dotnet", args);
            proc.WaitForExit();
            if (proc.ExitCode != 0)
            {
                progressMonitor.CommandFailed("dotnet", args, proc.ExitCode);
                return false;
            }

            return true;
        }

        public bool RestoreToDirectory(string projectOrSolutionFile, string packageDirectory)
        {
            var args = $"restore --no-dependencies \"{projectOrSolutionFile}\" --packages \"{packageDirectory}\" /p:DisableImplicitNuGetFallbackFolder=true";
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
    }
}
