using System.Collections.Generic;

namespace Semmle.Autobuild
{
    /// <summary>
    /// XML extraction.
    /// </summary>
    class XmlBuildRule : IBuildRule
    {
        public BuildScript Analyse(Autobuilder builder)
        {
            var command = new CommandBuilder(builder.Actions).
                RunCommand(builder.Odasa).
                Argument("index --xml --extensions config");
            return command.Script;
        }
    }
}
