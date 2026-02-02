using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
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

            // Set minimal environment variables.
            foreach (var kvp in IDotNetCliInvoker.MinimalEnvironment)
            {
                startInfo.EnvironmentVariables[kvp.Key] = kvp.Value;
            }

            // Configure the proxy settings, if applicable.
            if (this.proxy != null)
            {
                logger.LogDebug($"Configuring environment variables for the Dependabot proxy at {this.proxy.Address}");

                startInfo.EnvironmentVariables["HTTP_PROXY"] = this.proxy.Address;
                startInfo.EnvironmentVariables["HTTPS_PROXY"] = this.proxy.Address;
                startInfo.EnvironmentVariables["SSL_CERT_FILE"] = this.proxy.CertificatePath;
            }

            return startInfo;
        }

        private int RunCommandExitCodeAux(string args, string? workingDirectory, out IList<string> output, out string dirLog, bool silent)
        {
            dirLog = string.IsNullOrWhiteSpace(workingDirectory) ? "" : $" in {workingDirectory}";
            var pi = MakeDotnetStartInfo(args, workingDirectory);
            var threadId = Environment.CurrentManagedThreadId;
            void onOut(string s) => logger.Log(silent ? Severity.Debug : Severity.Info, s, threadId);
            void onError(string s) => logger.LogError(s, threadId);
            logger.LogInfo($"Running '{Exec} {args}'{dirLog}");
            var exitCode = pi.ReadOutput(out output, onOut, onError);
            return exitCode;
        }

        private bool RunCommandAux(string args, string? workingDirectory, out IList<string> output, bool silent)
        {
            var exitCode = RunCommandExitCodeAux(args, workingDirectory, out output, out var dirLog, silent);
            if (exitCode != 0)
            {
                logger.LogError($"Command '{Exec} {args}'{dirLog} failed with exit code {exitCode}");
                return false;
            }
            return true;
        }

        public bool RunCommand(string args, bool silent = true) =>
            RunCommandAux(args, null, out _, silent);

        public int RunCommandExitCode(string args, bool silent = true) =>
            RunCommandExitCodeAux(args, null, out _, out _, silent);

        public bool RunCommand(string args, out IList<string> output, bool silent = true) =>
            RunCommandAux(args, null, out output, silent);

        public bool RunCommand(string args, string? workingDirectory, out IList<string> output, bool silent = true) =>
            RunCommandAux(args, workingDirectory, out output, silent);
    }
}
