using System.Collections.Generic;
using System.Diagnostics;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    /// <summary>
    /// Low level utilities to run the "dotnet" command.
    /// </summary>
    internal sealed class DotnetCommand : IDotnetCommand
    {
        private readonly ProgressMonitor progressMonitor;

        public string Exec { get; }

        public DotnetCommand(ProgressMonitor progressMonitor, string exec)
        {
            this.progressMonitor = progressMonitor;
            this.Exec = exec;
        }

        private ProcessStartInfo MakeDotnetStartInfo(string args, bool redirectStandardOutput)
        {
            var startInfo = new ProcessStartInfo(Exec, args)
            {
                UseShellExecute = false,
                RedirectStandardOutput = redirectStandardOutput
            };
            // Set the .NET CLI language to English to avoid localized output.
            startInfo.EnvironmentVariables["DOTNET_CLI_UI_LANGUAGE"] = "en";
            return startInfo;
        }

        public bool RunCommand(string args)
        {
            progressMonitor.RunningProcess($"{Exec} {args}");
            using var proc = Process.Start(MakeDotnetStartInfo(args, redirectStandardOutput: false));
            proc?.WaitForExit();
            var exitCode = proc?.ExitCode ?? -1;
            if (exitCode != 0)
            {
                progressMonitor.CommandFailed(Exec, args, exitCode);
                return false;
            }
            return true;
        }

        public bool RunCommand(string args, out IList<string> output)
        {
            progressMonitor.RunningProcess($"{Exec} {args}");
            var pi = MakeDotnetStartInfo(args, redirectStandardOutput: true);
            var exitCode = pi.ReadOutput(out output);
            if (exitCode != 0)
            {
                progressMonitor.CommandFailed(Exec, args, exitCode);
                return false;
            }
            return true;
        }
    }
}
