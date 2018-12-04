using System.Collections.Generic;

namespace Semmle.Autobuild
{
    /// <summary>
    /// XML extraction.
    /// </summary>
    class XmlBuildRule : IBuildRule
    {
        public BuildScript Analyse(Autobuilder builder, bool auto)
        {
            var command = new CommandBuilder(builder.Actions).
                RunCommand(builder.Odasa).
                Argument("index --xml --extensions config csproj props xml");
            return command.Script;
        }
    }
}
