using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class TryStatementEntity : CachedEntity<(TryStatementAst, TryStatementAst)>
    {
        private TryStatementEntity(PowerShellContext cx, TryStatementAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public TryStatementAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.try_statement(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Body));
            for(int index = 0; index < Fragment.CatchClauses.Count; index++)
            {
                trapFile.try_statement_catch_clause(this, index, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.CatchClauses[index]));
            }
            if (Fragment.Finally is not null)
            {
                trapFile.try_statement_finally(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Finally));
            }
            trapFile.try_statement_location(this, TrapSuitableLocation);
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";try_statement");
        }

        internal static TryStatementEntity Create(PowerShellContext cx, TryStatementAst fragment)
        {
            var init = (fragment, fragment);
            return TryStatementEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class TryStatementEntityFactory : CachedEntityFactory<(TryStatementAst, TryStatementAst), TryStatementEntity>
        {
            public static TryStatementEntityFactory Instance { get; } = new TryStatementEntityFactory();

            public override TryStatementEntity Create(PowerShellContext cx, (TryStatementAst, TryStatementAst) init) =>
                new TryStatementEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}