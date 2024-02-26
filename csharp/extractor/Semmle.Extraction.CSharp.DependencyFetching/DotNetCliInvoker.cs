using System;
using System.Collections.Generic;
using System.Diagnostics;
using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    /// <summary>
    /// Low level utilities to run the "dotnet" command.
    /// </summary>
    internal sealed class DotNetCliInvoker : IDotNetCliInvoker
    {
        private readonly ILogger logger;

        public string Exec { get; }

        public DotNetCliInvoker(ILogger logger, string exec)
        {
            this.logger = logger;
            this.Exec = exec;
        }

        private ProcessStartInfo MakeDotnetStartInfo(string args)
        {
            var startInfo = new ProcessStartInfo(Exec, args)
            {
                UseShellExecute = false,
                RedirectStandardOutput = true,
                RedirectStandardError = true
            };
            // Set the .NET CLI language to English to avoid localized output.
            startInfo.EnvironmentVariables["DOTNET_CLI_UI_LANGUAGE"] = "en";
            startInfo.EnvironmentVariables["MSBUILDDISABLENODEREUSE"] = "1";
            startInfo.EnvironmentVariables["DOTNET_SKIP_FIRST_TIME_EXPERIENCE"] = "true";
            return startInfo;
        }

        private bool RunCommandAux(string args, out IList<string> output)
        {
            logger.LogInfo($"Running {Exec} {args}");
            var pi = MakeDotnetStartInfo(args);
            var threadId = Environment.CurrentManagedThreadId;
            void onOut(string s) => logger.LogInfo(s, threadId);
            void onError(string s) => logger.LogError(s, threadId);
            var exitCode = pi.ReadOutput(out output, onOut, onError);
            if (exitCode != 0)
            {
                logger.LogError($"Command {Exec} {args} failed with exit code {exitCode}");
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
