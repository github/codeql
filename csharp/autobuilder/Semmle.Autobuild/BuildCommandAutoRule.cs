﻿using System.Collections.Generic;
using System.IO;
using System.Linq;
using Semmle.Util.Logging;

namespace Semmle.Autobuild
{
    /// <summary>
    /// Auto-detection of build scripts.
    /// </summary>
    class BuildCommandAutoRule : IBuildRule
    {
        readonly IEnumerable<string> winExtensions = new List<string> {
            ".bat",
            ".cmd",
            ".exe"
        };

        readonly IEnumerable<string> linuxExtensions = new List<string> {
            "",
            ".sh"
        };

        readonly IEnumerable<string> buildScripts = new List<string> {
            "build"
        };

        public BuildScript Analyse(Autobuilder builder, bool auto)
        {
            builder.Log(Severity.Info, "Attempting to locate build script");

            var extensions = builder.Actions.IsWindows() ? winExtensions : linuxExtensions;
            var scripts = buildScripts.SelectMany(s => extensions.Select(e => s + e));
            var scriptPath = builder.Paths.Where(p => scripts.Any(p.Item1.ToLower().EndsWith)).OrderBy(p => p.Item2).Select(p => p.Item1).FirstOrDefault();

            if (scriptPath == null)
                return BuildScript.Failure;

            var chmod = new CommandBuilder(builder.Actions);
            chmod.RunCommand("/bin/chmod", $"u+x {scriptPath}");
            var chmodScript = builder.Actions.IsWindows() ? BuildScript.Success : BuildScript.Try(chmod.Script);

            var dir = Path.GetDirectoryName(scriptPath);

            // A specific .NET Core version may be required
            return chmodScript & DotNetRule.WithDotNet(builder, environment =>
            {
                var command = new CommandBuilder(builder.Actions, dir, environment);

                // A specific Visual Studio version may be required
                var vsTools = MsBuildRule.GetVcVarsBatFile(builder);
                if (vsTools != null)
                    command.CallBatFile(vsTools.Path);

                builder.MaybeIndex(command, scriptPath);
                return command.Script;
            });
        }
    }
}
