using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class StatementBlockEntity : CachedEntity<(StatementBlockAst, StatementBlockAst)>
    {
        private StatementBlockEntity(PowerShellContext cx, StatementBlockAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public StatementBlockAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.statement_block(this, Fragment.Statements.Count, Fragment.Traps?.Count ?? 0);
            trapFile.statement_block_location(this, TrapSuitableLocation);
            
            for (int index = 0; index < Fragment.Statements.Count; index++)
            {
                trapFile.statement_block_statement(this, index,
                    EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Statements[index]));
            }

            if (Fragment.Traps is not null)
            {
                for (int index = 0; index < Fragment.Traps.Count; index++)
                {
                    trapFile.statement_block_trap(this, index,
                        EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Traps[index]));
                }
            }
            
            trapFile.parent(PowerShellContext, this, Fragment.Parent);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";statement_block");
        }

        internal static StatementBlockEntity Create(PowerShellContext cx, StatementBlockAst fragment)
        {
            var init = (fragment, fragment);
            return StatementBlockEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class StatementBlockEntityFactory : CachedEntityFactory<(StatementBlockAst, StatementBlockAst), StatementBlockEntity>
        {
            public static StatementBlockEntityFactory Instance { get; } = new StatementBlockEntityFactory();

            public override StatementBlockEntity Create(PowerShellContext cx, (StatementBlockAst, StatementBlockAst) init) =>
                new StatementBlockEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}