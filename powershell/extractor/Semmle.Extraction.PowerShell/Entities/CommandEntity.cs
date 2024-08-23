using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class CommandEntity : CachedEntity<(CommandAst, CommandAst)>
    {
        private CommandEntity(PowerShellContext cx, CommandAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public CommandAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.command(this, Fragment.GetCommandName() ?? string.Empty, Fragment.InvocationOperator, Fragment.CommandElements.Count, Fragment.Redirections.Count);
            trapFile.command_location(this, TrapSuitableLocation);
            // TODO: Need a sample where this isn't null
            if (Fragment.DefiningKeyword is { } dynamicKeyword)
            {
            }
            for (int index = 0; index < Fragment.CommandElements.Count; index++)
            {
                var entity = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.CommandElements[index]);
                trapFile.command_command_element(this, index, entity);
            }
            for(int index = 0; index < Fragment.Redirections.Count; index++)
            {
                var entity = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Redirections[index]);
                trapFile.command_redirection(this, index, entity);
            }
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";command");
        }

        internal static CommandEntity Create(PowerShellContext cx, CommandAst fragment)
        {
            var init = (fragment, fragment);
            return CommandEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class CommandEntityFactory : CachedEntityFactory<(CommandAst, CommandAst), CommandEntity>
        {
            public static CommandEntityFactory Instance { get; } = new CommandEntityFactory();

            public override CommandEntity Create(PowerShellContext cx, (CommandAst, CommandAst) init) =>
                new CommandEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}