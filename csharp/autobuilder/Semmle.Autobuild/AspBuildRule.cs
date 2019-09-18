using System.IO;

namespace Semmle.Autobuild
{
    /// <summary>
    /// ASP extraction.
    /// </summary>
    class AspBuildRule : IBuildRule
    {
        public BuildScript Analyse(Autobuilder builder, bool auto)
        {
            var command = new CommandBuilder(builder.Actions).
                RunCommand(builder.Actions.PathCombine(builder.SemmleJavaHome, "bin", "java")).
                Argument("-jar").
                QuoteArgument(builder.Actions.PathCombine(builder.SemmleDist, "tools", "extractor-asp.jar")).
                Argument(".");
            return command.Script;
        }
    }
}
