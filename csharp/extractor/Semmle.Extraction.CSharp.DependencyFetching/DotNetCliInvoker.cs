using System.Collections.Generic;
using System.Diagnostics;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    /// <summary>
    /// Low level utilities to run the "dotnet" command.
    /// </summary>
    internal sealed class DotNetCliInvoker : IDotNetCliInvoker
    {
        private readonly ProgressMonitor progressMonitor;

        public string Exec { get; }

        public DotNetCliInvoker(ProgressMonitor progressMonitor, string exec)
        {
            this.progressMonitor = progressMonitor;
            this.Exec = exec;
        }

        private ProcessStartInfo MakeDotnetStartInfo(string args)
        {
            var startInfo = new ProcessStartInfo(Exec, args)
            {
                UseShellExecute = false,
                RedirectStandardOutput = true
            };
            // Set the .NET CLI language to English to avoid localized output.
            startInfo.EnvironmentVariables["DOTNET_CLI_UI_LANGUAGE"] = "en";
            return startInfo;
        }

        private bool RunCommandAux(string args, out IList<string> output)
        {
            progressMonitor.RunningProcess($"{Exec} {args}");
            var pi = MakeDotnetStartInfo(args);
            var exitCode = pi.ReadOutput(out output, true);
            if (exitCode != 0)
            {
                progressMonitor.CommandFailed(Exec, args, exitCode);
                return false;
            }
            return true;
        }

        public bool RunCommand(string args) =>
            RunCommandAux(args, out _);

        public bool RunCommand(string args, out IList<string> output) =>
            RunCommandAux(args, out output);
    }
}
