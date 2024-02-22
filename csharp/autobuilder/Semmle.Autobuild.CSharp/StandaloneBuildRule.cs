using System.Collections.Generic;
using Semmle.Autobuild.Shared;

namespace Semmle.Autobuild.CSharp
{
    /// <summary>
    /// Build using standalone extraction.
    /// </summary>
    internal class StandaloneBuildRule : IBuildRule<CSharpAutobuildOptions>
    {
        private readonly string? dotNetPath;
        private readonly IDictionary<string, string>? env;

        internal StandaloneBuildRule(string? dotNetPath, IDictionary<string, string>? env)
        {
            this.dotNetPath = dotNetPath;
            this.env = env;
        }

        public BuildScript Analyse(IAutobuilder<CSharpAutobuildOptions> builder, bool auto)
        {
            if (!builder.Options.Buildless
                || builder.CodeQLExtractorLangRoot is null
                || builder.CodeQlPlatform is null)
            {
                return BuildScript.Failure;
            }

            var standalone = builder.Actions.PathCombine(builder.CodeQLExtractorLangRoot, "tools", builder.CodeQlPlatform, "Semmle.Extraction.CSharp.Standalone");
            var cmd = new CommandBuilder(builder.Actions, environment: this.env);
            cmd.RunCommand(standalone);

            if (!string.IsNullOrEmpty(this.dotNetPath))
            {
                cmd.Argument("--dotnet");
                cmd.QuoteArgument(this.dotNetPath);
            }

            return cmd.Script;
        }
    }
}
