using Semmle.Extraction.CSharp;
using Semmle.Util.Logging;
using Semmle.Autobuild.Shared;

namespace Semmle.Autobuild.CSharp
{
    public class CSharpAutobuilder : Autobuilder
    {
        public CSharpAutobuilder(IBuildActions actions, AutobuildOptions options) : base(actions, options) { }

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
            if (Options.BuildCommand != null)
                return CSharpBuildStrategy.CustomBuildCommand;

            if (Options.Buildless)
                return CSharpBuildStrategy.Buildless;

            if (Options.MsBuildArguments != null
                || Options.MsBuildConfiguration != null
                || Options.MsBuildPlatform != null
                || Options.MsBuildTarget != null)
            {
                return CSharpBuildStrategy.MSBuild;
            }

            if (Options.DotNetArguments != null || Options.DotNetVersion != null)
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
