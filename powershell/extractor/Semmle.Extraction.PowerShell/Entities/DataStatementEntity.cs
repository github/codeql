using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class DataStatementEntity : CachedEntity<(DataStatementAst, DataStatementAst)>
    {
        private DataStatementEntity(PowerShellContext cx, DataStatementAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public DataStatementAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.data_statement(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Body));
            trapFile.data_statement_location(this, TrapSuitableLocation);
            if (Fragment.Variable != null)
            {
                trapFile.data_statement_variable(this, Fragment.Variable);
            }
            for(int i = 0; i < Fragment.CommandsAllowed.Count; i++)
            {
                trapFile.data_statement_commands_allowed(this, i, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.CommandsAllowed[i]));
            }
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";data_statement");
        }

        internal static DataStatementEntity Create(PowerShellContext cx, DataStatementAst fragment)
        {
            var init = (fragment, fragment);
            return DataStatementEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class DataStatementEntityFactory : CachedEntityFactory<(DataStatementAst, DataStatementAst), DataStatementEntity>
        {
            public static DataStatementEntityFactory Instance { get; } = new DataStatementEntityFactory();

            public override DataStatementEntity Create(PowerShellContext cx, (DataStatementAst, DataStatementAst) init) =>
                new DataStatementEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}