using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class CommandParameterEntity : CachedEntity<(CommandParameterAst, CommandParameterAst)>
    {
        private CommandParameterEntity(PowerShellContext cx, CommandParameterAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public CommandParameterAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.command_parameter(this, Fragment.ParameterName);
            trapFile.command_parameter_location(this, TrapSuitableLocation);
            if (Fragment.Argument is not null)
            {
                trapFile.command_parameter_argument(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext,Fragment.Argument));
            }
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";command_parameter");
        }

        internal static CommandParameterEntity Create(PowerShellContext cx, CommandParameterAst fragment)
        {
            var init = (fragment, fragment);
            return CommandParameterEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class CommandParameterEntityFactory : CachedEntityFactory<(CommandParameterAst, CommandParameterAst), CommandParameterEntity>
        {
            public static CommandParameterEntityFactory Instance { get; } = new CommandParameterEntityFactory();

            public override CommandParameterEntity Create(PowerShellContext cx, (CommandParameterAst, CommandParameterAst) init) =>
                new CommandParameterEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}