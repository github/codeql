using System.Linq;
using Semmle.Util;
using Semmle.Util.Logging;
using Semmle.Autobuild.Shared;
using Semmle.Extraction.CSharp;

namespace Semmle.Autobuild.CSharp
{
    /// <summary>
    /// Encapsulates C# build options.
    /// </summary>
    public class CSharpAutobuildOptions : AutobuildOptionsShared
    {
        private const string buildModeEnvironmentVariable = "CODEQL_EXTRACTOR_CSHARP_BUILD_MODE";
        internal const string ExtractorOptionBuildless = "CODEQL_EXTRACTOR_CSHARP_OPTION_BUILDLESS";
        internal const string ExtractorOptionBinlog = "CODEQL_EXTRACTOR_CSHARP_OPTION_BINLOG";

        public bool Buildless { get; }
        public string? Binlog { get; }

        public override Language Language => Language.CSharp;


        /// <summary>
        /// Reads options from environment variables.
        /// Throws ArgumentOutOfRangeException for invalid arguments.
        /// </summary>
        public CSharpAutobuildOptions(IBuildActions actions) : base(actions)
        {
            Buildless =
                actions.GetEnvironmentVariable(ExtractorOptionBuildless).AsBool("buildless", false) ||
                actions.GetEnvironmentVariable(buildModeEnvironmentVariable)?.ToLower() == "none";

            Binlog = actions.GetEnvironmentVariable(ExtractorOptionBinlog);
        }
    }

    public class CSharpAutobuilder : Autobuilder<CSharpAutobuildOptions>
    {
        private const string buildCommandDocsUrl =
            "https://docs.github.com/en/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/configuring-the-codeql-workflow-for-compiled-languages";

        private readonly AutoBuildRule autoBuildRule;

        public CSharpAutobuilder(IBuildActions actions, CSharpAutobuildOptions options) : base(actions, options, new CSharpDiagnosticClassifier()) =>
            this.autoBuildRule = new AutoBuildRule(this);

        public override BuildScript GetBuildScript()
        {
            var attempt = BuildScript.Failure;
            switch (GetCSharpBuildStrategy())
            {
                case CSharpBuildStrategy.Buildless:
                    // No need to check that the extractor has been executed in buildless mode
                    attempt = BuildScript.Bind(
                        AddBuildlessWronglyConfiguredWarning() & AddBuildlessStartedDiagnostic() & new StandaloneBuildRule().Analyse(this, false),
                        AddBuildlessEndedDiagnostic);
                    break;
                case CSharpBuildStrategy.Auto:
                    attempt =
                        // Attempt a few different build strategies to see if one works
                        this.autoBuildRule.Analyse(this, true) |
                        // All attempts failed: print message
                        AutobuildFailure();
                    break;
            }

            return attempt;
        }

        /// <summary>
        /// A script that checks that the C# extractor has been executed.
        /// </summary>
        public BuildScript CheckExtractorRun(bool warnOnFailure) =>
            BuildScript.Create(actions =>
            {
                if (actions.FileExists(Extractor.GetCSharpLogPath()))
                    return 0;

                if (warnOnFailure)
                    Logger.LogError("No C# code detected during build.");

                return 1;
            });

        private BuildScript AddBuildlessWronglyConfiguredWarning()
        {
            return BuildScript.Create(actions =>
            {
                if (actions.GetEnvironmentVariable(CSharpAutobuildOptions.ExtractorOptionBuildless) is null)
                {
                    return 0;
                }

                AddDiagnostic(new DiagnosticMessage(
                    Options.Language,
                    "buildless/use-build-mode",
                    "C# was extracted with the deprecated 'buildless' option, use build-mode instead",
                    visibility: new DiagnosticMessage.TspVisibility(statusPage: true, cliSummaryTable: true, telemetry: true),
                    markdownMessage: "C# was extracted with the deprecated 'buildless' option, use build-mode instead.",
                    severity: DiagnosticMessage.TspSeverity.Warning
                ));
                return 0;
            });
        }

        private BuildScript AddBuildlessStartedDiagnostic()
        {
            return BuildScript.Create(actions =>
            {
                AddDiagnostic(new DiagnosticMessage(
                    Options.Language,
                    "buildless/mode-active",
                    "C# was extracted with build-mode set to 'none'",
                    visibility: new DiagnosticMessage.TspVisibility(statusPage: true, cliSummaryTable: true, telemetry: true),
                    markdownMessage: "C# was extracted with build-mode set to 'none'. This means that all C# source in the working directory will be scanned, with build tools, such as Nuget and Dotnet CLIs, only contributing information about external dependencies.",
                    severity: DiagnosticMessage.TspSeverity.Note
                ));

                // For the time being we are adding an additional message regarding the binlog usage. In the future, we might want to remove the buildless messages altogether when the binlog option is specified.
                if (actions.GetEnvironmentVariable(CSharpAutobuildOptions.ExtractorOptionBinlog) is not null)
                {
                    AddDiagnostic(new DiagnosticMessage(
                        Options.Language,
                        "buildless/binlog",
                        "C# was extracted with the experimental 'binlog' option",
                        visibility: new DiagnosticMessage.TspVisibility(statusPage: true, cliSummaryTable: true, telemetry: true),
                        markdownMessage: "C# was extracted with the experimental 'binlog' option.",
                        severity: DiagnosticMessage.TspSeverity.Note
                    ));
                }

                return 0;
            });
        }

        private BuildScript AddBuildlessEndedDiagnostic(int buildResult)
        {
            return BuildScript.Create(actions =>
            {
                if (buildResult == 0)
                {
                    AddDiagnostic(new DiagnosticMessage(
                        Options.Language,
                        "buildless/complete",
                        "C# analysis with build-mode 'none' completed",
                        visibility: new DiagnosticMessage.TspVisibility(statusPage: false, cliSummaryTable: true, telemetry: true),
                        markdownMessage: "C# analysis with build-mode 'none' completed.",
                        severity: DiagnosticMessage.TspSeverity.Unknown
                    ));
                }
                else
                {
                    AddDiagnostic(new DiagnosticMessage(
                        Options.Language,
                        "buildless/failed",
                        "C# analysis with build-mode 'none' failed",
                        visibility: new DiagnosticMessage.TspVisibility(statusPage: true, cliSummaryTable: true, telemetry: true),
                        markdownMessage: "C# analysis with build-mode 'none' failed.",
                        severity: DiagnosticMessage.TspSeverity.Error
                    ));
                }
                return buildResult;
            });
        }

        protected override void AutobuildFailureDiagnostic()
        {
            // if `ScriptPath` is not null here, the `BuildCommandAuto` rule was
            // run and found at least one script to execute
            if (this.autoBuildRule.BuildCommandAutoRule.ScriptPath is not null)
            {
                var relScriptPath = this.MakeRelative(autoBuildRule.BuildCommandAutoRule.ScriptPath);

                // if we found multiple build scripts in the project directory, then we can say
                // as much to indicate that we may have picked the wrong one;
                // otherwise, we just report that the one script we found didn't work
                DiagnosticMessage message =
                    this.autoBuildRule.BuildCommandAutoRule.CandidatePaths.Count() > 1 ?
                    new(
                        this.Options.Language,
                        "multiple-build-scripts",
                        "There are multiple potential build scripts",
                        markdownMessage:
                            "CodeQL found multiple potential build scripts for your project and " +
                            $"attempted to run `{relScriptPath}`, which failed. " +
                            "This may not be the right build script for your project.\n\n" +
                            $"Set up a [manual build command]({buildCommandDocsUrl})."
                    ) :
                    new(
                        this.Options.Language,
                        "script-failure",
                        "Unable to build project using build script",
                        markdownMessage:
                            "CodeQL attempted to build your project using a script located at " +
                            $"`{relScriptPath}`, which failed.\n\n" +
                            $"Set up a [manual build command]({buildCommandDocsUrl})."
                    );

                AddDiagnostic(message);
            }

            // project files which don't exist get marked as not .NET core projects, but we don't want
            // to show an error for this if the files don't exist
            var foundNotDotNetProjects = autoBuildRule.DotNetRule.NotDotNetProjects.Where(
                proj => this.Actions.FileExists(proj.FullPath)
            );

            // both dotnet and msbuild builds require project or solution files; if we haven't found any
            // then neither of those rules would've worked
            if (this.ProjectsOrSolutionsToBuild.Count == 0)
            {
                this.AddDiagnostic(new(
                    this.Options.Language,
                    "no-projects-or-solutions",
                    "No project or solutions files found",
                    markdownMessage:
                        "CodeQL could not find any project or solution files in your repository.\n\n" +
                        $"Set up a [manual build command]({buildCommandDocsUrl})."
                ));
            }
            // show a warning if there are projects which are not compatible with .NET Core, in case that is unintentional
            else if (foundNotDotNetProjects.Any())
            {
                this.AddDiagnostic(new(
                    this.Options.Language,
                    "dotnet-incompatible-projects",
                    "Some projects are incompatible with .NET Core",
                    severity: DiagnosticMessage.TspSeverity.Warning,
                    markdownMessage: $"""
                    CodeQL found some projects which cannot be built with .NET Core:

                    {autoBuildRule.DotNetRule.NotDotNetProjects.Select(p => this.MakeRelative(p.FullPath)).ToMarkdownList(MarkdownUtil.CodeFormatter, 5)}
                    """
                ));
            }

            // report any projects that failed to build with .NET Core
            if (autoBuildRule.DotNetRule.FailedProjectsOrSolutions.Any())
            {
                this.AddDiagnostic(new(
                    this.Options.Language,
                    "dotnet-build-failure",
                    "Some projects or solutions failed to build using .NET Core",
                    markdownMessage: $"""
                    CodeQL was unable to build the following projects using .NET Core:

                    {autoBuildRule.DotNetRule.FailedProjectsOrSolutions.Select(p => this.MakeRelative(p.FullPath)).ToMarkdownList(MarkdownUtil.CodeFormatter, 10)}

                    Set up a [manual build command]({buildCommandDocsUrl}).
                    """
                ));
            }

            // report any projects that failed to build with MSBuild
            if (autoBuildRule.MsBuildRule.FailedProjectsOrSolutions.Any())
            {
                this.AddDiagnostic(new(
                    this.Options.Language,
                    "msbuild-build-failure",
                    "Some projects or solutions failed to build using MSBuild",
                    markdownMessage: $"""
                    CodeQL was unable to build the following projects using MSBuild:

                    {autoBuildRule.MsBuildRule.FailedProjectsOrSolutions.Select(p => this.MakeRelative(p.FullPath)).ToMarkdownList(MarkdownUtil.CodeFormatter, 10)}

                    Set up a [manual build command]({buildCommandDocsUrl}).
                    """
                ));
            }
        }

        /// <summary>
        /// Gets the build strategy that the autobuilder should apply, based on the
        /// options in the `lgtm.yml` file.
        /// </summary>
        private CSharpBuildStrategy GetCSharpBuildStrategy()
        {
            if (Options.Buildless)
                return CSharpBuildStrategy.Buildless;

            return CSharpBuildStrategy.Auto;
        }

        private enum CSharpBuildStrategy
        {
            Buildless,
            Auto
        }
    }
}
