using Semmle.Autobuild.Shared;

namespace Semmle.Autobuild.CSharp
{
    /// <summary>
    /// Build using standalone extraction.
    /// </summary>
    class StandaloneBuildRule : IBuildRule
    {
        public BuildScript Analyse(Autobuilder builder, bool auto)
        {
            BuildScript GetCommand(string? solution)
            {
                string standalone;
                if (!(builder.CodeQLExtractorLangRoot is null) && !(builder.CodeQlPlatform is null)) {
                    standalone = builder.Actions.PathCombine(builder.CodeQLExtractorLangRoot, "tools", builder.CodeQlPlatform, "Semmle.Extraction.CSharp.Standalone");
                } else if (!(builder.SemmlePlatformTools is null)) {
                    standalone = builder.Actions.PathCombine(builder.SemmlePlatformTools, "csharp", "Semmle.Extraction.CSharp.Standalone");
                } else {
                    return BuildScript.Failure;
                }

                var cmd = new CommandBuilder(builder.Actions);
                cmd.RunCommand(standalone);

                if (solution != null)
                    cmd.QuoteArgument(solution);

                cmd.Argument("--references:.");

                if (!builder.Options.NugetRestore)
                {
                    cmd.Argument("--skip-nuget");
                }

                return cmd.Script;
            }

            if (!builder.Options.Buildless)
                return BuildScript.Failure;

            var solutions = builder.Options.Solution.Length;

            if (solutions == 0)
                return GetCommand(null);

            var script = BuildScript.Success;
            foreach (var solution in builder.Options.Solution)
                script &= GetCommand(solution);

            return script;
        }
    }
}
