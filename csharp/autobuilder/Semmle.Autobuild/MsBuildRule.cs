using Semmle.Util.Logging;
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

        public BuildScript Analyse(Autobuilder builder, bool auto)
        {
            if (!builder.ProjectsOrSolutionsToBuild.Any())
                return BuildScript.Failure;

            if (auto)
                builder.Log(Severity.Info, "Attempting to build using MSBuild");

            var vsTools = GetVcVarsBatFile(builder);

            if (vsTools == null && builder.ProjectsOrSolutionsToBuild.Any())
            {
                var firstSolution = builder.ProjectsOrSolutionsToBuild.OfType<ISolution>().FirstOrDefault();
                vsTools = firstSolution != null
                                ? BuildTools.FindCompatibleVcVars(builder.Actions, firstSolution)
                                : BuildTools.VcVarsAllBatFiles(builder.Actions).OrderByDescending(b => b.ToolsVersion).FirstOrDefault();
            }

            if (vsTools == null && builder.Actions.IsWindows())
            {
                builder.Log(Severity.Warning, "Could not find a suitable version of vcvarsall.bat");
            }

            var nuget =
                builder.CodeQLExtractorCSharpRoot != null ?
                builder.Actions.PathCombine(builder.CodeQLExtractorCSharpRoot, "tools", "nuget.exe") :
                builder.Actions.PathCombine(builder.SemmlePlatformTools, "csharp", "nuget", "nuget.exe");

            var ret = BuildScript.Success;

            foreach (var projectOrSolution in builder.ProjectsOrSolutionsToBuild)
            {
                if (builder.Options.NugetRestore)
                {
                    var nugetCommand = new CommandBuilder(builder.Actions).
                        RunCommand(nuget).
                        Argument("restore").
                        QuoteArgument(projectOrSolution.FullPath);
                    ret &= BuildScript.Try(nugetCommand.Script);
                }

                var command = new CommandBuilder(builder.Actions);

                if (vsTools != null)
                    command.CallBatFile(vsTools.Path);

                builder.MaybeIndex(command, MsBuild);
                command.QuoteArgument(projectOrSolution.FullPath);

                command.Argument("/p:UseSharedCompilation=false");

                string target = builder.Options.MsBuildTarget != null
                                       ? builder.Options.MsBuildTarget
                                       : "rebuild";
                string platform = builder.Options.MsBuildPlatform != null
                                         ? builder.Options.MsBuildPlatform
                                         : projectOrSolution is ISolution s1 ? s1.DefaultPlatformName : null;
                string configuration = builder.Options.MsBuildConfiguration != null
                                              ? builder.Options.MsBuildConfiguration
                                              : projectOrSolution is ISolution s2 ? s2.DefaultConfigurationName : null;

                command.Argument("/t:" + target);
                if (platform != null)
                    command.Argument(string.Format("/p:Platform=\"{0}\"", platform));
                if (configuration != null)
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
