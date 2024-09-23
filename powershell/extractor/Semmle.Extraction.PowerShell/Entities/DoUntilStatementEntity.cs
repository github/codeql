using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class DoUntilStatementEntity : CachedEntity<(DoUntilStatementAst, DoUntilStatementAst)>
    {
        private DoUntilStatementEntity(PowerShellContext cx, DoUntilStatementAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public DoUntilStatementAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            // Condition can be null only if this is a For statement so For Statement must be parsed first
            trapFile.do_until_statement(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Body));
            trapFile.do_until_statement_location(this, TrapSuitableLocation);
            if (Fragment.Label is not null)
            {
                trapFile.label(this, Fragment.Label);
            }

            if (Fragment.Condition is not null)
            {
                trapFile.do_until_statement_condition(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Condition));
            }
            trapFile.parent(PowerShellContext, this, Fragment.Parent);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";do_until_statement");
        }

        internal static DoUntilStatementEntity Create(PowerShellContext cx, DoUntilStatementAst fragment)
        {
            var init = (fragment, fragment);
            return DoUntilStatementEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class DoUntilStatementEntityFactory : CachedEntityFactory<(DoUntilStatementAst, DoUntilStatementAst), DoUntilStatementEntity>
        {
            public static DoUntilStatementEntityFactory Instance { get; } = new DoUntilStatementEntityFactory();

            public override DoUntilStatementEntity Create(PowerShellContext cx, (DoUntilStatementAst, DoUntilStatementAst) init) =>
                new DoUntilStatementEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}