using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class PipelineEntity : CachedEntity<(PipelineAst, PipelineAst)>
    {
        private PipelineEntity(PowerShellContext cx, PipelineAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public PipelineAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            // If there is just one element we don't want to include it in the database.
            if (Fragment.PipelineElements.Count == 1)
            {
                return;
            }
            trapFile.pipeline(this, Fragment.PipelineElements.Count);
            trapFile.pipeline_location(this, TrapSuitableLocation);
            for (var index = 0; index < Fragment.PipelineElements.Count; index++)
            {
                var subEntity = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.PipelineElements[index]);
                trapFile.pipeline_component(this, index, subEntity);
            }
            trapFile.parent(PowerShellContext, this, Fragment.Parent);   
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            if(Fragment.PipelineElements.Count == 1)
            {
                return;
            }
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";pipeline");
        }

        internal static PipelineEntity Create(PowerShellContext cx, PipelineAst fragment)
        {
            var init = (fragment, fragment);
            return PipelineEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class PipelineEntityFactory : CachedEntityFactory<(PipelineAst, PipelineAst), PipelineEntity>
        {
            public static PipelineEntityFactory Instance { get; } = new PipelineEntityFactory();

            public override PipelineEntity Create(PowerShellContext cx, (PipelineAst, PipelineAst) init) =>
                new PipelineEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}