﻿using Semmle.Extraction.CSharp;
using Semmle.Util.Logging;
using Semmle.Autobuild.Shared;

namespace Semmle.Autobuild.CSharp
{
    /// <summary>
    /// Encapsulates C# build options.
    /// </summary>
    public class CSharpAutobuildOptions : AutobuildOptionsShared
    {
        private const string extractorOptionPrefix = "CODEQL_EXTRACTOR_CSHARP_OPTION_";

        public bool Buildless { get; }

        public override Language Language => Language.CSharp;


        /// <summary>
        /// Reads options from environment variables.
        /// Throws ArgumentOutOfRangeException for invalid arguments.
        /// </summary>
        public CSharpAutobuildOptions(IBuildActions actions) : base(actions)
        {
            Buildless = actions.GetEnvironmentVariable(lgtmPrefix + "BUILDLESS").AsBool("buildless", false) ||
                actions.GetEnvironmentVariable(extractorOptionPrefix + "BUILDLESS").AsBool("buildless", false);
        }
    }

    public class CSharpAutobuilder : Autobuilder<CSharpAutobuildOptions>
    {
        public CSharpAutobuilder(IBuildActions actions, CSharpAutobuildOptions options) : base(actions, options) { }

        public override BuildScript GetBuildScript()
        {
            /// <summary>
            /// A script that checks that the C# extractor has been executed.
            /// </summary>
            BuildScript CheckExtractorRun(bool warnOnFailure) =>
                BuildScript.Create(actions =>
                {
                    if (actions.FileExists(Extractor.GetCSharpLogPath()))
                        return 0;

                    if (warnOnFailure)
                        Log(Severity.Error, "No C# code detected during build.");

                    return 1;
                });

            var attempt = BuildScript.Failure;
            switch (GetCSharpBuildStrategy())
            {
                case CSharpBuildStrategy.CustomBuildCommand:
                    attempt = new BuildCommandRule(DotNetRule.WithDotNet).Analyse(this, false) & CheckExtractorRun(true);
                    break;
                case CSharpBuildStrategy.Buildless:
                    // No need to check that the extractor has been executed in buildless mode
                    attempt = new StandaloneBuildRule().Analyse(this, false);
                    break;
                case CSharpBuildStrategy.MSBuild:
                    attempt = new MsBuildRule().Analyse(this, false) & CheckExtractorRun(true);
                    break;
                case CSharpBuildStrategy.DotNet:
                    attempt = new DotNetRule().Analyse(this, false) & CheckExtractorRun(true);
                    break;
                case CSharpBuildStrategy.Auto:
                    var cleanTrapFolder =
                        BuildScript.DeleteDirectory(TrapDir);
                    var cleanSourceArchive =
                        BuildScript.DeleteDirectory(SourceArchiveDir);
                    var tryCleanExtractorArgsLogs =
                        BuildScript.Create(actions =>
                        {
                            foreach (var file in Extractor.GetCSharpArgsLogs())
                            {
                                try
                                {
                                    actions.FileDelete(file);
                                }
                                catch // lgtm[cs/catch-of-all-exceptions] lgtm[cs/empty-catch-block]
                                { }
                            }

                            return 0;
                        });
                    var attemptExtractorCleanup =
                        BuildScript.Try(cleanTrapFolder) &
                        BuildScript.Try(cleanSourceArchive) &
                        tryCleanExtractorArgsLogs &
                        BuildScript.DeleteFile(Extractor.GetCSharpLogPath());

                    /// <summary>
                    /// Execute script `s` and check that the C# extractor has been executed.
                    /// If either fails, attempt to cleanup any artifacts produced by the extractor,
                    /// and exit with code 1, in order to proceed to the next attempt.
                    /// </summary>
                    BuildScript IntermediateAttempt(BuildScript s) =>
                        (s & CheckExtractorRun(false)) |
                        (attemptExtractorCleanup & BuildScript.Failure);

                    attempt =
                        // First try .NET Core
                        IntermediateAttempt(new DotNetRule().Analyse(this, true)) |
                        // Then MSBuild
                        (() => IntermediateAttempt(new MsBuildRule().Analyse(this, true))) |
                        // And finally look for a script that might be a build script
                        (() => new BuildCommandAutoRule(DotNetRule.WithDotNet).Analyse(this, true) & CheckExtractorRun(true)) |
                        // All attempts failed: print message
                        AutobuildFailure();
                    break;
            }

            return attempt;
        }

        /// <summary>
        /// Gets the build strategy that the autobuilder should apply, based on the
        /// options in the `lgtm.yml` file.
        /// </summary>
        private CSharpBuildStrategy GetCSharpBuildStrategy()
        {
            if (Options.BuildCommand is not null)
                return CSharpBuildStrategy.CustomBuildCommand;

            if (Options.Buildless)
                return CSharpBuildStrategy.Buildless;

            if (Options.MsBuildArguments is not null
                || Options.MsBuildConfiguration is not null
                || Options.MsBuildPlatform is not null
                || Options.MsBuildTarget is not null)
            {
                return CSharpBuildStrategy.MSBuild;
            }

            if (Options.DotNetArguments is not null || Options.DotNetVersion is not null)
                return CSharpBuildStrategy.DotNet;

            return CSharpBuildStrategy.Auto;
        }

        private enum CSharpBuildStrategy
        {
            CustomBuildCommand,
            Buildless,
            MSBuild,
            DotNet,
            Auto
        }
    }
}
