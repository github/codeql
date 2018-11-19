using Semmle.Util.Logging;
using System.IO;
using System.Linq;

namespace Semmle.Autobuild
{
    /// <summary>
    /// A build rule using msbuild.
    /// </summary>
    class MsBuildRule : IBuildRule
    {
        /// <summary>
        /// The name of the msbuild command.
        /// </summary>
        const string MsBuild = "msbuild";

        public BuildScript Analyse(Autobuilder builder)
        {
            builder.Log(Severity.Info, "Attempting to build using MSBuild");

            if (!builder.SolutionsToBuild.Any())
            {
                builder.Log(Severity.Info, "Could not find a suitable solution file to build");
                return BuildScript.Failure;
            }

            var vsTools = GetVcVarsBatFile(builder);

            if (vsTools == null && builder.SolutionsToBuild.Any())
            {
                vsTools = BuildTools.FindCompatibleVcVars(builder.Actions, builder.SolutionsToBuild.First());
            }

            if (vsTools == null && builder.Actions.IsWindows())
            {
                builder.Log(Severity.Warning, "Could not find a suitable version of vcvarsall.bat");
            }

            var nuget = builder.Actions.PathCombine(builder.SemmlePlatformTools, "csharp", "nuget", "nuget.exe");

            var ret = BuildScript.Success;

            foreach (var solution in builder.SolutionsToBuild)
            {
                if (builder.Options.NugetRestore)
                {
                    var nugetCommand = new CommandBuilder(builder.Actions).
                        RunCommand(nuget).
                        Argument("restore").
                        QuoteArgument(solution.Path);
                    ret &= BuildScript.Try(nugetCommand.Script);
                }

                var command = new CommandBuilder(builder.Actions);

                if (vsTools != null)
                {
                    command.CallBatFile(vsTools.Path);
                }

                command.IndexCommand(builder.Odasa, MsBuild);
                command.QuoteArgument(solution.Path);

                command.Argument("/p:UseSharedCompilation=false");

                string target = builder.Options.MsBuildTarget != null ? builder.Options.MsBuildTarget : "rebuild";
                string platform = builder.Options.MsBuildPlatform != null ? builder.Options.MsBuildPlatform : solution.DefaultPlatformName;
                string configuration = builder.Options.MsBuildConfiguration != null ? builder.Options.MsBuildConfiguration : solution.DefaultConfigurationName;

                command.Argument("/t:" + target);
                command.Argument(string.Format("/p:Platform=\"{0}\"", platform));
                command.Argument(string.Format("/p:Configuration=\"{0}\"", configuration));
                command.Argument("/p:MvcBuildViews=true");

                command.Argument(builder.Options.MsBuildArguments);

                ret &= command.Script;
            }

            return ret;
        }

        /// <summary>
        /// Gets the BAT file used to initialize the appropriate Visual Studio
        /// version/platform, as specified by the `vstools_version` property in
        /// lgtm.yml.
        ///
        /// Returns <code>null</code> when no version is specified.
        /// </summary>
        public static VcVarsBatFile GetVcVarsBatFile(Autobuilder builder)
        {
            VcVarsBatFile vsTools = null;

            if (builder.Options.VsToolsVersion != null)
            {
                if (int.TryParse(builder.Options.VsToolsVersion, out var msToolsVersion))
                {
                    foreach (var b in BuildTools.VcVarsAllBatFiles(builder.Actions))
                    {
                        builder.Log(Severity.Info, "Found {0} version {1}", b.Path, b.ToolsVersion);
                    }

                    vsTools = BuildTools.FindCompatibleVcVars(builder.Actions, msToolsVersion);
                    if (vsTools == null)
                        builder.Log(Severity.Warning, "Could not find build tools matching version {0}", msToolsVersion);
                    else
                        builder.Log(Severity.Info, "Setting Visual Studio tools to {0}", vsTools.Path);
                }
                else
                {
                    builder.Log(Severity.Error, "The format of vstools_version is incorrect. Please specify an integer.");
                }
            }

            return vsTools;
        }
    }
}
