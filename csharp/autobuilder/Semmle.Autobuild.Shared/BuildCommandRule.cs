using System;
using System.Collections.Generic;

namespace Semmle.Autobuild.Shared
{
    /// <summary>
    /// Execute the build_command rule.
    /// </summary>
    public class BuildCommandRule : IBuildRule
    {
        private readonly Func<Autobuilder, Func<IDictionary<string, string>?, BuildScript>, BuildScript> withDotNet;

        public BuildCommandRule(Func<Autobuilder, Func<IDictionary<string, string>?, BuildScript>, BuildScript> withDotNet)
        {
            this.withDotNet = withDotNet;
        }

        public BuildScript Analyse(Autobuilder builder, bool auto)
        {
            if (builder.Options.BuildCommand == null)
                return BuildScript.Failure;

            // Custom build commands may require a specific .NET Core version
            return withDotNet(builder, environment =>
                {
                    var command = new CommandBuilder(builder.Actions, null, environment);

                    // Custom build commands may require a specific Visual Studio version
                    var vsTools = MsBuildRule.GetVcVarsBatFile(builder);
                    if (vsTools != null)
                        command.CallBatFile(vsTools.Path);
                    builder.MaybeIndex(command, builder.Options.BuildCommand);

                    return command.Script;
                });
        }
    }
}
