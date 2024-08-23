using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class TrapStatementEntity : CachedEntity<(TrapStatementAst, TrapStatementAst)>
    {
        private TrapStatementEntity(PowerShellContext cx, TrapStatementAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public TrapStatementAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.trap_statement(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Body));

            if (Fragment.TrapType is not null)
            {
                trapFile.trap_statement_type(this,
                    (TypeConstraintEntity)EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.TrapType));
            }

            trapFile.trap_statement_location(this, TrapSuitableLocation);
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";trap_statement");
        }

        internal static TrapStatementEntity Create(PowerShellContext cx, TrapStatementAst fragment)
        {
            var init = (fragment, fragment);
            return TrapStatementEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class TrapStatementEntityFactory : CachedEntityFactory<(TrapStatementAst, TrapStatementAst), TrapStatementEntity>
        {
            public static TrapStatementEntityFactory Instance { get; } = new TrapStatementEntityFactory();

            public override TrapStatementEntity Create(PowerShellContext cx, (TrapStatementAst, TrapStatementAst) init) =>
                new TrapStatementEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}