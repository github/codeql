using Semmle.Autobuild.Shared;
using Semmle.Util;

namespace Semmle.Autobuild.CSharp
{
    /// <summary>
    /// Build using standalone extraction.
    /// </summary>
    internal class StandaloneBuildRule : IBuildRule<CSharpAutobuildOptions>
    {
        public BuildScript Analyse(IAutobuilder<CSharpAutobuildOptions> builder, bool auto)
        {
            if (builder.CodeQLExtractorLangRoot is null
                || builder.CodeQlPlatform is null)
            {
                return BuildScript.Failure;
            }

            var standalone = builder.Actions.PathCombine(builder.CodeQLExtractorLangRoot, "tools", builder.CodeQlPlatform, "Semmle.Extraction.CSharp.Standalone");
            var cmd = new CommandBuilder(builder.Actions);
            cmd.RunCommand(standalone);

            return cmd.Script;
        }
    }
}
