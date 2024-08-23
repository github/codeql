using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class ExitStatementEntity : CachedEntity<(ExitStatementAst, ExitStatementAst)>
    {
        private ExitStatementEntity(PowerShellContext cx, ExitStatementAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public ExitStatementAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            if(Fragment.Pipeline is not null)
            {
                trapFile.exit_statement_pipeline(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Pipeline));
            }    
            trapFile.exit_statement(this);
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
            trapFile.exit_statement_location(this, TrapSuitableLocation);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";exit_statement");
        }

        internal static ExitStatementEntity Create(PowerShellContext cx, ExitStatementAst fragment)
        {
            var init = (fragment, fragment);
            return ExitStatementEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class ExitStatementEntityFactory : CachedEntityFactory<(ExitStatementAst, ExitStatementAst), ExitStatementEntity>
        {
            public static ExitStatementEntityFactory Instance { get; } = new ExitStatementEntityFactory();

            public override ExitStatementEntity Create(PowerShellContext cx, (ExitStatementAst, ExitStatementAst) init) =>
                new ExitStatementEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}