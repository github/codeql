using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class BreakStatementEntity : CachedEntity<(BreakStatementAst, BreakStatementAst)>
    {
        private BreakStatementEntity(PowerShellContext cx, BreakStatementAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public BreakStatementAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.break_statement(this);
            if (Fragment.Label is not null)
            {
                trapFile.statement_label(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Label));
            }

            trapFile.break_statement_location(this, TrapSuitableLocation);
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";break_statement");
        }

        internal static BreakStatementEntity Create(PowerShellContext cx, BreakStatementAst fragment)
        {
            var init = (fragment, fragment);
            return BreakStatementEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class BreakStatementEntityFactory : CachedEntityFactory<(BreakStatementAst, BreakStatementAst), BreakStatementEntity>
        {
            public static BreakStatementEntityFactory Instance { get; } = new BreakStatementEntityFactory();

            public override BreakStatementEntity Create(PowerShellContext cx, (BreakStatementAst, BreakStatementAst) init) =>
                new BreakStatementEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}