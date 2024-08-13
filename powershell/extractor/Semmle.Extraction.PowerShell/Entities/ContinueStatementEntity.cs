using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class ContinueStatementEntity : CachedEntity<(ContinueStatementAst, ContinueStatementAst)>
    {
        private ContinueStatementEntity(PowerShellContext cx, ContinueStatementAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public ContinueStatementAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.continue_statement(this);
            if (Fragment.Label is not null)
            {
                trapFile.statement_label(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Label));
            }

            trapFile.continue_statement_location(this, TrapSuitableLocation);
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";continue_statement");
        }

        internal static ContinueStatementEntity Create(PowerShellContext cx, ContinueStatementAst fragment)
        {
            var init = (fragment, fragment);
            return ContinueStatementEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class ContinueStatementEntityFactory : CachedEntityFactory<(ContinueStatementAst, ContinueStatementAst), ContinueStatementEntity>
        {
            public static ContinueStatementEntityFactory Instance { get; } = new ContinueStatementEntityFactory();

            public override ContinueStatementEntity Create(PowerShellContext cx, (ContinueStatementAst, ContinueStatementAst) init) =>
                new ContinueStatementEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}