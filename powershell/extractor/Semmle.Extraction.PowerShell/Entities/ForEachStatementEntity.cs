using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class ForEachStatementEntity : CachedEntity<(ForEachStatementAst, ForEachStatementAst)>
    {
        private ForEachStatementEntity(PowerShellContext cx, ForEachStatementAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public ForEachStatementAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            // Condition can be null only if this is a For statement so For Statement must be parsed first
            trapFile.foreach_statement(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Variable), 
                EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Condition), 
                EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Body), Fragment.Flags);
            trapFile.foreach_statement_location(this, TrapSuitableLocation);
            if (Fragment.Label is not null)
            {
                trapFile.label(this, Fragment.Label);
            }
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";foreach_statement");
        }

        internal static ForEachStatementEntity Create(PowerShellContext cx, ForEachStatementAst fragment)
        {
            var init = (fragment, fragment);
            return ForEachStatementEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class ForEachStatementEntityFactory : CachedEntityFactory<(ForEachStatementAst, ForEachStatementAst), ForEachStatementEntity>
        {
            public static ForEachStatementEntityFactory Instance { get; } = new ForEachStatementEntityFactory();

            public override ForEachStatementEntity Create(PowerShellContext cx, (ForEachStatementAst, ForEachStatementAst) init) =>
                new ForEachStatementEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}