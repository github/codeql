using Semmle.Autobuild.Shared;
using Semmle.Extraction.CSharp;
using Semmle.Util;

namespace Semmle.Autobuild.CSharp
{
    internal class AutoBuildRule : IBuildRule<CSharpAutobuildOptions>
    {
        private readonly CSharpAutobuilder autobuilder;

        public DotNetRule DotNetRule { get; }

        public MsBuildRule MsBuildRule { get; }

        public BuildCommandAutoRule BuildCommandAutoRule { get; }

        public AutoBuildRule(CSharpAutobuilder autobuilder)
        {
            this.autobuilder = autobuilder;
            this.DotNetRule = new DotNetRule();
            this.MsBuildRule = new MsBuildRule();
            this.BuildCommandAutoRule = new BuildCommandAutoRule(DotNetRule.WithDotNet);
        }

        public BuildScript Analyse(IAutobuilder<CSharpAutobuildOptions> builder, bool auto)
        {
            var cleanTrapFolder =
                BuildScript.DeleteDirectory(this.autobuilder.TrapDir);
            var cleanSourceArchive =
                BuildScript.DeleteDirectory(this.autobuilder.SourceArchiveDir);
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

            // Execute script `s` and check that the C# extractor has been executed.
            // If either fails, attempt to cleanup any artifacts produced by the extractor,
            // and exit with code 1, in order to proceed to the next attempt.
            BuildScript IntermediateAttempt(BuildScript s) =>
                (s & this.autobuilder.CheckExtractorRun(false)) |
                (attemptExtractorCleanup & BuildScript.Failure);

            return
                // First try .NET Core
                IntermediateAttempt(this.DotNetRule.Analyse(this.autobuilder, true)) |
                // Then MSBuild
                (() => IntermediateAttempt(this.MsBuildRule.Analyse(this.autobuilder, true))) |
                // And finally look for a script that might be a build script
                (() => this.BuildCommandAutoRule.Analyse(this.autobuilder, true) & this.autobuilder.CheckExtractorRun(true));
        }
    }
}
