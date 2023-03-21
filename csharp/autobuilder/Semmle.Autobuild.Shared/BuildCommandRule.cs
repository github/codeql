namespace Semmle.Autobuild.Shared
{
    /// <summary>
    /// Execute the build_command rule.
    /// </summary>
    public class BuildCommandRule : IBuildRule<AutobuildOptionsShared>
    {
        private readonly WithDotNet<AutobuildOptionsShared> withDotNet;

        public BuildCommandRule(WithDotNet<AutobuildOptionsShared> withDotNet)
        {
            this.withDotNet = withDotNet;
        }

        public BuildScript Analyse(IAutobuilder<AutobuildOptionsShared> builder, bool auto)
        {
            if (builder.Options.BuildCommand is null)
                return BuildScript.Failure;

            // Custom build commands may require a specific .NET Core version
            return withDotNet(builder, environment =>
                {
                    var command = new CommandBuilder(builder.Actions, null, environment);

                    // Custom build commands may require a specific Visual Studio version
                    var vsTools = MsBuildRule.GetVcVarsBatFile(builder);
                    if (vsTools is not null)
                        command.CallBatFile(vsTools.Path);
                    command.RunCommand(builder.Options.BuildCommand);

                    return command.Script;
                });
        }
    }
}
