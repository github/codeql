using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class ReturnStatementEntity : CachedEntity<(ReturnStatementAst, ReturnStatementAst)>
    {
        private ReturnStatementEntity(PowerShellContext cx, ReturnStatementAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public ReturnStatementAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.return_statement(this);
            if (Fragment.Pipeline is not null)
            {
                trapFile.return_statement_pipeline(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Pipeline));
            }
            trapFile.return_statement_location(this, TrapSuitableLocation);
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";continue_statement");
        }

        internal static ReturnStatementEntity Create(PowerShellContext cx, ReturnStatementAst fragment)
        {
            var init = (fragment, fragment);
            return ReturnStatementEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class ReturnStatementEntityFactory : CachedEntityFactory<(ReturnStatementAst, ReturnStatementAst), ReturnStatementEntity>
        {
            public static ReturnStatementEntityFactory Instance { get; } = new ReturnStatementEntityFactory();

            public override ReturnStatementEntity Create(PowerShellContext cx, (ReturnStatementAst, ReturnStatementAst) init) =>
                new ReturnStatementEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}