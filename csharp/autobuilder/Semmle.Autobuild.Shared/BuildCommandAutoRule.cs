using System.Collections.Generic;
using System.Linq;
using Semmle.Util.Logging;

namespace Semmle.Autobuild.Shared
{
    /// <summary>
    /// Auto-detection of build scripts.
    /// </summary>
    public class BuildCommandAutoRule : IBuildRule
    {
        private readonly WithDotNet withDotNet;

        public BuildCommandAutoRule(WithDotNet withDotNet)
        {
            this.withDotNet = withDotNet;
        }

        private readonly IEnumerable<string> winExtensions = new List<string> {
            ".bat",
            ".cmd",
            ".exe"
        };

        private readonly IEnumerable<string> linuxExtensions = new List<string> {
            "",
            ".sh"
        };

        private readonly IEnumerable<string> buildScripts = new List<string> {
            "build"
        };

        public BuildScript Analyse(Autobuilder builder, bool auto)
        {
            builder.Log(Severity.Info, "Attempting to locate build script");

            var extensions = builder.Actions.IsWindows() ? winExtensions : linuxExtensions;
            var scripts = buildScripts.SelectMany(s => extensions.Select(e => s + e));
            var scriptPath = builder.Paths.Where(p => scripts.Any(p.Item1.ToLower().EndsWith)).OrderBy(p => p.Item2).Select(p => p.Item1).FirstOrDefault();

            if (scriptPath is null)
                return BuildScript.Failure;

            var chmod = new CommandBuilder(builder.Actions);
            chmod.RunCommand("/bin/chmod", $"u+x {scriptPath}");
            var chmodScript = builder.Actions.IsWindows() ? BuildScript.Success : BuildScript.Try(chmod.Script);

            var dir = builder.Actions.GetDirectoryName(scriptPath);

            // A specific .NET Core version may be required
            return chmodScript & withDotNet(builder, environment =>
            {
                var command = new CommandBuilder(builder.Actions, dir, environment);

                // A specific Visual Studio version may be required
                var vsTools = MsBuildRule.GetVcVarsBatFile(builder);
                if (vsTools is not null)
                    command.CallBatFile(vsTools.Path);

                builder.MaybeIndex(command, scriptPath);
                return command.Script;
            });
        }
    }
}
