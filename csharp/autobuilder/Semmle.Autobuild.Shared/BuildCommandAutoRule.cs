using System;
using System.Collections.Generic;
using System.Linq;

using Semmle.Util;
using Semmle.Util.Logging;

namespace Semmle.Autobuild.Shared
{
    /// <summary>
    /// Auto-detection of build scripts.
    /// </summary>
    public class BuildCommandAutoRule : IBuildRule<AutobuildOptionsShared>
    {
        private readonly WithDotNet<AutobuildOptionsShared> withDotNet;
        private (string path, int depth)[] candidates = Array.Empty<(string, int)>();

        /// <summary>
        /// Paths to files in the project directory which we classified as scripts, in no guaranteed order.
        /// </summary>
        public IEnumerable<string> CandidatePaths => this.candidates.Select(p => p.path);

        /// <summary>
        /// The path of the script we decided to run, if any.
        /// </summary>
        public string? ScriptPath { get; private set; }

        public BuildCommandAutoRule(WithDotNet<AutobuildOptionsShared> withDotNet)
        {
            this.withDotNet = withDotNet;
        }

        /// <summary>
        /// A list of extensions that we consider to be for scripts on Windows.
        /// </summary>
        private readonly IEnumerable<string> winExtensions = new List<string> {
            ".bat",
            ".cmd",
            ".exe"
        };

        /// <summary>
        /// A list of extensions that we consider to be for scripts on Linux.
        /// </summary>
        private readonly IEnumerable<string> linuxExtensions = new List<string> {
            "",
            ".sh"
        };

        /// <summary>
        /// A list of filenames without extensions that we think might be build scripts.
        /// </summary>
        private readonly IEnumerable<string> buildScripts = new List<string> {
            "build"
        };

        public BuildScript Analyse(IAutobuilder<AutobuildOptionsShared> builder, bool auto)
        {
            builder.Logger.LogInfo("Attempting to locate build script");

            // a list of extensions for files that we consider to be scripts on the current platform
            var extensions = builder.Actions.IsWindows() ? winExtensions : linuxExtensions;
            // a list of combined base script names with the current platform's script extensions
            // e.g. for Linux: build, build.sh
            var scripts = buildScripts.SelectMany(s => extensions.Select(e => s + e));
            // search through the files in the project directory for paths which end in one of
            // the names given by `scripts`
            this.candidates = builder.Paths
                .Where(p => scripts.Any(p.Item1.ToLower().EndsWith))
                .ToArray();

            // .NET optimizes FirstOrDefault on an ordered sequence to a linear-time minimum scan without sorting.
            this.ScriptPath = this.candidates
                .OrderBy(p => p.depth)
                .ThenBy(p => p.path, StringComparer.Ordinal)
                .Select(p => p.path)
                .FirstOrDefault();

            if (this.ScriptPath is null)
                return BuildScript.Failure;

            var chmod = new CommandBuilder(builder.Actions);
            chmod.RunCommand("/bin/chmod", $"u+x {this.ScriptPath}");
            var chmodScript = builder.Actions.IsWindows() ? BuildScript.Success : BuildScript.Try(chmod.Script);

            var dir = builder.Actions.GetDirectoryName(this.ScriptPath);

            // A specific .NET Core version may be required
            return chmodScript & withDotNet(builder, environment =>
            {
                var command = new CommandBuilder(builder.Actions, dir, environment);

                command.RunCommand(this.ScriptPath);
                return command.Script;
            });
        }
    }
}
