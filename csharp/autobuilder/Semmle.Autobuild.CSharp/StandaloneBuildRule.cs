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
            if (builder.Options.Binlog is string binlog)
            {
                return BuildScript.Create(_ => Semmle.Extraction.CSharp.Driver.Main(["--binlog", binlog]));
            }
            else
            {
                return BuildScript.Create(_ => Semmle.Extraction.CSharp.Standalone.Program.Main([]));
            }
        }
    }
}
