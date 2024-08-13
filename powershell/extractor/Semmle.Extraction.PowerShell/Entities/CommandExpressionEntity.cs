using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class CommandExpressionEntity : CachedEntity<(CommandExpressionAst, CommandExpressionAst)>
    {
        private CommandExpressionEntity(PowerShellContext cx, CommandExpressionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public CommandExpressionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            var wrappedEntity =
                EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Expression);
            trapFile.command_expression(this, wrappedEntity, Fragment.Redirections.Count);
            trapFile.command_expression_location(this, TrapSuitableLocation);
            for (var index = 0; index < Fragment.Redirections.Count; index++)
            {
                trapFile.command_expression_redirection(this, index, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Redirections[index]));
            }
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";command_expression");
        }

        internal static CommandExpressionEntity Create(PowerShellContext cx, CommandExpressionAst fragment)
        {
            var init = (fragment, fragment);
            return CommandExpressionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class CommandExpressionEntityFactory : CachedEntityFactory<(CommandExpressionAst, CommandExpressionAst), CommandExpressionEntity>
        {
            public static CommandExpressionEntityFactory Instance { get; } = new CommandExpressionEntityFactory();

            public override CommandExpressionEntity Create(PowerShellContext cx, (CommandExpressionAst, CommandExpressionAst) init) =>
                new CommandExpressionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}