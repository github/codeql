using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class IfStatementEntity : CachedEntity<(IfStatementAst, IfStatementAst)>
    {
        private IfStatementEntity(PowerShellContext cx, IfStatementAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public IfStatementAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.if_statement(this);
            trapFile.if_statement_location(this, TrapSuitableLocation);
            for(int index = 0; index < Fragment.Clauses.Count; index++)
            {
                var item1 = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Clauses[index].Item1); 
                var item2 = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Clauses[index].Item2); 
                trapFile.if_statement_clause(this, index, item1, item2);
                index++; 
            }
            if (Fragment.ElseClause is not null)
            {
                trapFile.if_statement_else(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.ElseClause));
            }
            trapFile.parent(PowerShellContext, this, Fragment.Parent);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";if_statement");
        }

        internal static IfStatementEntity Create(PowerShellContext cx, IfStatementAst fragment)
        {
            var init = (fragment, fragment);
            return IfStatementEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class IfStatementEntityFactory : CachedEntityFactory<(IfStatementAst, IfStatementAst), IfStatementEntity>
        {
            public static IfStatementEntityFactory Instance { get; } = new IfStatementEntityFactory();

            public override IfStatementEntity Create(PowerShellContext cx, (IfStatementAst, IfStatementAst) init) =>
                new IfStatementEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}