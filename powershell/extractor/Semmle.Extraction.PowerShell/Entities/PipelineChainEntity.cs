using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class PipelineChainEntity : CachedEntity<(PipelineChainAst, PipelineChainAst)>
    {
        private PipelineChainEntity(PowerShellContext cx, PipelineChainAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public PipelineChainAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.pipeline_chain(this, Fragment.Background, Fragment.Operator, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.LhsPipelineChain), EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.RhsPipeline));
            trapFile.pipeline_chain_location(this, TrapSuitableLocation);
            trapFile.parent(PowerShellContext, this, Fragment.Parent);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";pipeline_chain");
        }

        internal static PipelineChainEntity Create(PowerShellContext cx, PipelineChainAst fragment)
        {
            var init = (fragment, fragment);
            return PipelineChainEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class PipelineChainEntityFactory : CachedEntityFactory<(PipelineChainAst, PipelineChainAst), PipelineChainEntity>
        {
            public static PipelineChainEntityFactory Instance { get; } = new PipelineChainEntityFactory();

            public override PipelineChainEntity Create(PowerShellContext cx, (PipelineChainAst, PipelineChainAst) init) =>
                new PipelineChainEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}