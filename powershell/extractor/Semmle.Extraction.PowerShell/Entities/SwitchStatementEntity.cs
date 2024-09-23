using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class SwitchStatementEntity : CachedEntity<(SwitchStatementAst, SwitchStatementAst)>
    {
        private SwitchStatementEntity(PowerShellContext cx, SwitchStatementAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public SwitchStatementAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.switch_statement(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Condition), Fragment.Flags);
            trapFile.switch_statement_location(this, TrapSuitableLocation);
            for(int index = 0; index < Fragment.Clauses.Count; index++)
            {
                trapFile.switch_statement_clauses(this, index, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Clauses[index].Item1), EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Clauses[index].Item2));
            }
            if (Fragment.Default is not null)
            {
                trapFile.switch_statement_default(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Default));
            }
            if (Fragment.Label is not null)
            {
                trapFile.label(this, Fragment.Label);
            }
            trapFile.parent(PowerShellContext, this, Fragment.Parent);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";switch_statement");
        }

        internal static SwitchStatementEntity Create(PowerShellContext cx, SwitchStatementAst fragment)
        {
            var init = (fragment, fragment);
            return SwitchStatementEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class SwitchStatementEntityFactory : CachedEntityFactory<(SwitchStatementAst, SwitchStatementAst), SwitchStatementEntity>
        {
            public static SwitchStatementEntityFactory Instance { get; } = new SwitchStatementEntityFactory();

            public override SwitchStatementEntity Create(PowerShellContext cx, (SwitchStatementAst, SwitchStatementAst) init) =>
                new SwitchStatementEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}