using System;
using System.Collections.Generic;
using System.Diagnostics;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    /// <summary>
    /// Utilities for querying information from the git CLI.
    /// </summary>
    internal class Git
    {
        private readonly ProgressMonitor progressMonitor;
        private const string git = "git";

        public Git(ProgressMonitor progressMonitor)
        {
            this.progressMonitor = progressMonitor;
        }

        /// <summary>
        /// Lists all files matching <paramref name="pattern"/> which are tracked in the
        /// current git repository.
        /// </summary>
        /// <param name="pattern">The file pattern.</param>
        /// <returns>A list of all tracked files which match <paramref name="pattern"/>.</returns>
        /// <exception cref="Exception"></exception>
        public List<string> ListFiles(string pattern)
        {
            var results = new List<string>();
            var args = string.Join(' ', "ls-files", $"\"{pattern}\"");

            progressMonitor.RunningProcess($"{git} {args}");
            var pi = new ProcessStartInfo(git, args)
            {
                UseShellExecute = false,
                RedirectStandardOutput = true
            };

            using var p = new Process() { StartInfo = pi };
            p.OutputDataReceived += new DataReceivedEventHandler((sender, e) =>
            {
                if (!string.IsNullOrWhiteSpace(e.Data))
                {
                    results.Add(e.Data);
                }
            });
            p.Start();
            p.BeginOutputReadLine();
            p.WaitForExit();

            if (p.ExitCode != 0)
            {
                progressMonitor.CommandFailed(git, args, p.ExitCode);
                throw new Exception($"{git} {args} failed");
            }

            return results;
        }

    }
}
