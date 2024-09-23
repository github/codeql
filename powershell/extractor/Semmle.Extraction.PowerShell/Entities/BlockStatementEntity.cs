using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class BlockStatementEntity : CachedEntity<(BlockStatementAst, BlockStatementAst)>
    {
        private BlockStatementEntity(PowerShellContext cx, BlockStatementAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public BlockStatementAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.block_statement(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Body), TokenEntity.Create(PowerShellContext, Fragment.Kind));
            trapFile.block_statement_location(this, TrapSuitableLocation);
            trapFile.parent(PowerShellContext, this, Fragment.Parent);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";block_statement");
        }

        internal static BlockStatementEntity Create(PowerShellContext cx, BlockStatementAst fragment)
        {
            var init = (fragment, fragment);
            return BlockStatementEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class BlockStatementEntityFactory : CachedEntityFactory<(BlockStatementAst, BlockStatementAst), BlockStatementEntity>
        {
            public static BlockStatementEntityFactory Instance { get; } = new BlockStatementEntityFactory();

            public override BlockStatementEntity Create(PowerShellContext cx, (BlockStatementAst, BlockStatementAst) init) =>
                new BlockStatementEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}