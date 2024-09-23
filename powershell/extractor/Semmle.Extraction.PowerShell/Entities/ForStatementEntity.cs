using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class ForStatementEntity : CachedEntity<(ForStatementAst, ForStatementAst)>
    {
        private ForStatementEntity(PowerShellContext cx, ForStatementAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public ForStatementAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            // Condition can be null only if this is a For statement so For Statement must be parsed first
            trapFile.for_statement(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Body));
            trapFile.for_statement_location(this, TrapSuitableLocation);
            if (Fragment.Label is not null)
            {
                trapFile.label(this, Fragment.Label);
            }

            if (Fragment.Initializer is not null)
            {
                trapFile.for_statement_initializer(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Initializer));
            }

            if (Fragment.Condition is not null)
            {
                trapFile.for_statement_condition(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Condition));
            }

            if (Fragment.Iterator is not null)
            {
                trapFile.for_statement_iterator(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Iterator));
            }
            trapFile.parent(PowerShellContext, this, Fragment.Parent);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";for_statement");
        }

        internal static ForStatementEntity Create(PowerShellContext cx, ForStatementAst fragment)
        {
            var init = (fragment, fragment);
            return ForStatementEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class ForStatementEntityFactory : CachedEntityFactory<(ForStatementAst, ForStatementAst), ForStatementEntity>
        {
            public static ForStatementEntityFactory Instance { get; } = new ForStatementEntityFactory();

            public override ForStatementEntity Create(PowerShellContext cx, (ForStatementAst, ForStatementAst) init) =>
                new ForStatementEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}