using Semmle.Util.Logging;
using System.Linq;

namespace Semmle.Autobuild.Shared
{
    /// <summary>
    /// A build rule using msbuild.
    /// </summary>
    public class MsBuildRule : IBuildRule
    {
        /// <summary>
        /// The name of the msbuild command.
        /// </summary>
        private const string msBuild = "msbuild";

        public BuildScript Analyse(Autobuilder builder, bool auto)
        {
            if (!builder.ProjectsOrSolutionsToBuild.Any())
                return BuildScript.Failure;

            if (auto)
                builder.Log(Severity.Info, "Attempting to build using MSBuild");

            var vsTools = GetVcVarsBatFile(builder);

            if (vsTools is null && builder.ProjectsOrSolutionsToBuild.Any())
            {
                var firstSolution = builder.ProjectsOrSolutionsToBuild.OfType<ISolution>().FirstOrDefault();
                vsTools = firstSolution is not null
                                ? BuildTools.FindCompatibleVcVars(builder.Actions, firstSolution)
                                : BuildTools.VcVarsAllBatFiles(builder.Actions).OrderByDescending(b => b.ToolsVersion).FirstOrDefault();
            }

            if (vsTools is null && builder.Actions.IsWindows())
            {
                builder.Log(Severity.Warning, "Could not find a suitable version of VsDevCmd.bat/vcvarsall.bat");
            }

            // Use `nuget.exe` from source code repo, if present, otherwise first attempt with global
            // `nuget` command, and if that fails, attempt to download `nuget.exe` from nuget.org
            var nuget = builder.GetFilename("nuget.exe").Select(t => t.Item1).FirstOrDefault() ?? "nuget";
            var nugetDownload = builder.Actions.PathCombine(builder.Options.RootDirectory, ".nuget", "nuget.exe");
            var nugetDownloaded = false;

            var ret = BuildScript.Success;

            foreach (var projectOrSolution in builder.ProjectsOrSolutionsToBuild)
            {
                if (builder.Options.NugetRestore)
                {
                    BuildScript GetNugetRestoreScript() =>
                        new CommandBuilder(builder.Actions).
                            RunCommand(nuget).
                            Argument("restore").
                            QuoteArgument(projectOrSolution.FullPath).
                            Argument("-DisableParallelProcessing").
                            Script;
                    var nugetRestore = GetNugetRestoreScript();
                    var msbuildRestoreCommand = new CommandBuilder(builder.Actions).
                        RunCommand(msBuild).
                        Argument("/t:restore").
                        QuoteArgument(projectOrSolution.FullPath);

                    if (nugetDownloaded)
                    {
                        ret &= BuildScript.Try(nugetRestore | msbuildRestoreCommand.Script);
                    }
                    else
                    {
                        // If `nuget restore` fails, and we have not already attempted to download `nuget.exe`,
                        // download it and reattempt `nuget restore`.
                        var nugetDownloadAndRestore =
                            BuildScript.Bind(DownloadNugetExe(builder, nugetDownload), exitCode =>
                            {
                                nugetDownloaded = true;
                                if (exitCode != 0)
                                    return BuildScript.Failure;

                                nuget = nugetDownload;
                                return GetNugetRestoreScript();
                            });
                        ret &= BuildScript.Try(nugetRestore | nugetDownloadAndRestore | msbuildRestoreCommand.Script);
                    }
                }

                var command = new CommandBuilder(builder.Actions);

                if (vsTools is not null)
                {
                    command.CallBatFile(vsTools.Path);
                    // `vcvarsall.bat` sets a default Platform environment variable,
                    // which may not be compatible with the supported platforms of the
                    // given project/solution. Unsetting it means that the default platform
                    // of the project/solution is used instead.
                    command.RunCommand("set Platform=&& type NUL", quoteExe: false);
                }

                builder.MaybeIndex(command, msBuild);
                command.QuoteArgument(projectOrSolution.FullPath);

                command.Argument("/p:UseSharedCompilation=false");

                var target = builder.Options.MsBuildTarget ?? "rebuild";
                var platform = builder.Options.MsBuildPlatform ?? (projectOrSolution is ISolution s1 ? s1.DefaultPlatformName : null);
                var configuration = builder.Options.MsBuildConfiguration ?? (projectOrSolution is ISolution s2 ? s2.DefaultConfigurationName : null);

                command.Argument("/t:" + target);
                if (platform is not null)
                    command.Argument(string.Format("/p:Platform=\"{0}\"", platform));
                if (configuration is not null)
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
        public static VcVarsBatFile? GetVcVarsBatFile(Autobuilder builder)
        {
            VcVarsBatFile? vsTools = null;

            if (builder.Options.VsToolsVersion is not null)
            {
                if (int.TryParse(builder.Options.VsToolsVersion, out var msToolsVersion))
                {
                    foreach (var b in BuildTools.VcVarsAllBatFiles(builder.Actions))
                    {
                        builder.Log(Severity.Info, "Found {0} version {1}", b.Path, b.ToolsVersion);
                    }

                    vsTools = BuildTools.FindCompatibleVcVars(builder.Actions, msToolsVersion);
                    if (vsTools is null)
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

        /// <summary>
        /// Returns a script for downloading `nuget.exe` from nuget.org.
        /// </summary>
        private static BuildScript DownloadNugetExe(Autobuilder builder, string path) =>
            BuildScript.Create(_ =>
            {
                builder.Log(Severity.Info, "Attempting to download nuget.exe");
                return 0;
            })
            &
            BuildScript.DownloadFile(
                "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe",
                path,
                e => builder.Log(Severity.Warning, $"Failed to download 'nuget.exe': {e.Message}"))
            &
            BuildScript.Create(_ =>
            {
                builder.Log(Severity.Info, $"Successfully downloaded {path}");
                return 0;
            });
    }
}
