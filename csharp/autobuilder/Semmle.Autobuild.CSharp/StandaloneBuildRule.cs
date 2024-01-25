using System.Linq;
using Semmle.Autobuild.Shared;

namespace Semmle.Autobuild.CSharp
{
    /// <summary>
    /// Build using standalone extraction.
    /// </summary>
    internal class StandaloneBuildRule : IBuildRule<CSharpAutobuildOptions>
    {
        private readonly string? dotNetPath;

        internal StandaloneBuildRule(string? dotNetPath)
        {
            this.dotNetPath = dotNetPath;
        }

        public BuildScript Analyse(IAutobuilder<CSharpAutobuildOptions> builder, bool auto)
        {
            BuildScript GetCommand()
            {
                string standalone;
                if (builder.CodeQLExtractorLangRoot is not null && builder.CodeQlPlatform is not null)
                {
                    standalone = builder.Actions.PathCombine(builder.CodeQLExtractorLangRoot, "tools", builder.CodeQlPlatform, "Semmle.Extraction.CSharp.Standalone");
                }
                else
                {
                    return BuildScript.Failure;
                }

                var cmd = new CommandBuilder(builder.Actions);
                cmd.RunCommand(standalone);

                if (!string.IsNullOrEmpty(this.dotNetPath))
                {
                    cmd.Argument("--dotnet");
                    cmd.QuoteArgument(this.dotNetPath);
                }

                return cmd.Script;
            }

            if (!builder.Options.Buildless)
            {
                return BuildScript.Failure;
            }

            return GetCommand();
        }
    }
}
