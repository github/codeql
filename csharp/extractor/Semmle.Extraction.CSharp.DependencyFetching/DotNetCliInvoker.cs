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
        private readonly DependabotProxy? proxy;

        public string Exec { get; }

        public DotNetCliInvoker(ILogger logger, string exec, DependabotProxy? dependabotProxy)
        {
            this.logger = logger;
            this.proxy = dependabotProxy;
            this.Exec = exec;
            logger.LogInfo($"Using .NET CLI executable: '{Exec}'");
        }

        private ProcessStartInfo MakeDotnetStartInfo(string args, string? workingDirectory)
        {
            var startInfo = new ProcessStartInfo(Exec, args)
            {
                UseShellExecute = false,
                RedirectStandardOutput = true,
                RedirectStandardError = true
            };
            if (!string.IsNullOrWhiteSpace(workingDirectory))
            {
                startInfo.WorkingDirectory = workingDirectory;
            }
            // Set the .NET CLI language to English to avoid localized output.
            startInfo.EnvironmentVariables["DOTNET_CLI_UI_LANGUAGE"] = "en";
            startInfo.EnvironmentVariables["MSBUILDDISABLENODEREUSE"] = "1";
            startInfo.EnvironmentVariables["DOTNET_SKIP_FIRST_TIME_EXPERIENCE"] = "true";

            // Configure the proxy settings, if applicable.
            if (this.proxy != null)
            {
                logger.LogInfo($"Setting up Dependabot proxy at {this.proxy.Address}");

                startInfo.EnvironmentVariables["HTTP_PROXY"] = this.proxy.Address;
                startInfo.EnvironmentVariables["HTTPS_PROXY"] = this.proxy.Address;
                startInfo.EnvironmentVariables["SSL_CERT_FILE"] = this.proxy.CertificatePath;
            }

            return startInfo;
        }

        private bool RunCommandAux(string args, string? workingDirectory, out IList<string> output, bool silent)
        {
            var dirLog = string.IsNullOrWhiteSpace(workingDirectory) ? "" : $" in {workingDirectory}";
            logger.LogInfo($"Running '{Exec} {args}'{dirLog}");
            var pi = MakeDotnetStartInfo(args, workingDirectory);
            var threadId = Environment.CurrentManagedThreadId;
            void onOut(string s) => logger.Log(silent ? Severity.Debug : Severity.Info, s, threadId);
            void onError(string s) => logger.LogError(s, threadId);
            var exitCode = pi.ReadOutput(out output, onOut, onError);
            if (exitCode != 0)
            {
                logger.LogError($"Command '{Exec} {args}'{dirLog} failed with exit code {exitCode}");
                return false;
            }
            return true;
        }

        public bool RunCommand(string args, bool silent = true) =>
            RunCommandAux(args, null, out _, silent);

        public bool RunCommand(string args, out IList<string> output, bool silent = true) =>
            RunCommandAux(args, null, out output, silent);

        public bool RunCommand(string args, string? workingDirectory, out IList<string> output, bool silent = true) =>
            RunCommandAux(args, workingDirectory, out output, silent);
    }
}
