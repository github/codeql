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
            var config = new CommandBuilder(builder.Actions).
                RunCommand(builder.Odasa).
                Argument("index --xml --extensions config");
            var csproj = new CommandBuilder(builder.Actions).
                RunCommand(builder.Odasa).
                Argument("index --xml --extensions csproj");
            var props = new CommandBuilder(builder.Actions).
                RunCommand(builder.Odasa).
                Argument("index --xml --extensions props");
            return config.Script & csproj.Script & props.Script;
        }
    }
}
