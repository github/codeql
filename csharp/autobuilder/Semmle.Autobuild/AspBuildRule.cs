namespace Semmle.Autobuild
{
    /// <summary>
    /// ASP extraction.
    /// </summary>
    class AspBuildRule : IBuildRule
    {
        public BuildScript Analyse(Autobuilder builder, bool auto)
        {
            (var javaHome, var dist) =
                builder.CodeQLJavaHome != null ?
                (builder.CodeQLJavaHome, builder.CodeQLExtractorCSharpRoot) :
                (builder.SemmleJavaHome, builder.SemmleDist);
            var command = new CommandBuilder(builder.Actions).
                RunCommand(builder.Actions.PathCombine(javaHome, "bin", "java")).
                Argument("-jar").
                QuoteArgument(builder.Actions.PathCombine(dist, "tools", "extractor-asp.jar")).
                Argument(".");
            return command.Script;
        }
    }
}
