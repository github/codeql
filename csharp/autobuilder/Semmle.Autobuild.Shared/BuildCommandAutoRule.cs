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

        /// <summary>
        /// A list of paths to files in the project directory which we classified as scripts.
        /// </summary>
        public IEnumerable<string> CandidatePaths { get; private set; }

        /// <summary>
        /// The path of the script we decided to run, if any.
        /// </summary>
        public string? ScriptPath { get; private set; }

        public BuildCommandAutoRule(WithDotNet<AutobuildOptionsShared> withDotNet)
        {
            this.withDotNet = withDotNet;
            this.CandidatePaths = new List<string>();
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
            // the names given by `scripts`, then order them by their distance from the root
            this.CandidatePaths = builder.Paths.Where(p => scripts.Any(p.Item1.ToLower().EndsWith)).OrderBy(p => p.Item2).Select(p => p.Item1);
            // pick the first matching path, if there is one
            this.ScriptPath = this.CandidatePaths.FirstOrDefault();

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
