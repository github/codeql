using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class WhileStatementEntity : CachedEntity<(WhileStatementAst, WhileStatementAst)>
    {
        private WhileStatementEntity(PowerShellContext cx, WhileStatementAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public WhileStatementAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            // Condition can be null only if this is a For statement so For Statement must be parsed first
            trapFile.while_statement(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Body));
            trapFile.while_statement_location(this, TrapSuitableLocation);
            if (Fragment.Label is not null)
            {
                trapFile.label(this, Fragment.Label);
            }

            if (Fragment.Condition is not null)
            {
                trapFile.while_statement_condition(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Condition));
            }
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";while_statement");
        }

        internal static WhileStatementEntity Create(PowerShellContext cx, WhileStatementAst fragment)
        {
            var init = (fragment, fragment);
            return WhileStatementEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class WhileStatementEntityFactory : CachedEntityFactory<(WhileStatementAst, WhileStatementAst), WhileStatementEntity>
        {
            public static WhileStatementEntityFactory Instance { get; } = new WhileStatementEntityFactory();

            public override WhileStatementEntity Create(PowerShellContext cx, (WhileStatementAst, WhileStatementAst) init) =>
                new WhileStatementEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}