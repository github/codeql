using Semmle.Autobuild.Shared;

namespace Semmle.Autobuild.CSharp
{
    /// <summary>
    /// ASP extraction.
    /// </summary>
    class AspBuildRule : IBuildRule
    {
        public BuildScript Analyse(Autobuilder builder, bool auto)
        {
            var javaHome = builder.JavaHome;
            var dist = builder.Distribution;

            var command = new CommandBuilder(builder.Actions).
                RunCommand(builder.Actions.PathCombine(javaHome, "bin", "java")).
                Argument("-jar").
                QuoteArgument(builder.Actions.PathCombine(dist, "tools", "extractor-asp.jar")).
                Argument(".");
            return command.Script;
        }
    }
}
