using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class ScriptBlockEntity : CachedEntity<(ScriptBlockAst, ScriptBlockAst)>
    {
        private ScriptBlockEntity(PowerShellContext cx, ScriptBlockAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public ScriptBlockAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            // RequiresPsSnapins Property was removed in System.Management package 7.4.x and later
            trapFile.script_block(this, Fragment.UsingStatements.Count, Fragment.ScriptRequirements?.RequiredModules.Count ?? 0, Fragment.ScriptRequirements?.RequiredAssemblies.Count ?? 0, Fragment.ScriptRequirements?.RequiredPSEditions.Count ?? 0, 0);
            trapFile.script_block_location(this, TrapSuitableLocation);
            if (Fragment.ScriptRequirements is not null){
                trapFile.script_block_requires_elevation(this, Fragment.ScriptRequirements.IsElevationRequired);
                if (Fragment.ScriptRequirements.RequiredApplicationId is not null)
                {
                    trapFile.script_block_required_application_id(this, Fragment.ScriptRequirements.RequiredApplicationId);
                }
                if (Fragment.ScriptRequirements.RequiredPSVersion is not null)
                {
                    trapFile.script_block_required_ps_version(this, Fragment.ScriptRequirements.RequiredPSVersion.ToString());
                }
                for(int i = 0; i < Fragment.ScriptRequirements.RequiredModules.Count; i++)
                {
                    var theModule = ModuleSpecificationEntity.Create(PowerShellContext, Fragment.ScriptRequirements.RequiredModules[i], ReportingLocation);
                    trapFile.script_block_required_module(this, i, theModule);
                }
                for (int i = 0; i < Fragment.ScriptRequirements.RequiredAssemblies.Count; i++)
                {
                    trapFile.script_block_required_assembly(this, i, Fragment.ScriptRequirements.RequiredAssemblies[i]);
                }
                for (int i = 0; i < Fragment.ScriptRequirements.RequiredPSEditions.Count; i++)
                {
                    trapFile.script_block_required_ps_edition(this, i, Fragment.ScriptRequirements.RequiredPSEditions[i]);
                }
            }
            if (Fragment.ParamBlock is not null)
            {
                trapFile.script_block_param_block(this,
                    EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.ParamBlock));
            }

            if (Fragment.BeginBlock is not null)
            {
                trapFile.script_block_begin_block(this,
                    EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.BeginBlock));
            }

            if (Fragment.CleanBlock is not null)
            {
                trapFile.script_block_clean_block(this,
                    EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.CleanBlock));
            }

            if (Fragment.DynamicParamBlock is not null)
            {
                trapFile.script_block_dynamic_param_block(this,
                    EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.DynamicParamBlock));
            }
            
            if (Fragment.EndBlock is not null)
            {
                trapFile.script_block_end_block(this,
                    EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.EndBlock));
            }
            
            if (Fragment.ProcessBlock is not null)
            {            
                trapFile.script_block_process_block(this,
                EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.ProcessBlock));
            }

            // TODO: Fragment.Requirements, need a non-null example
            
            for (int index = 0; index < Fragment.UsingStatements.Count; index++)
            {
                trapFile.script_block_using(this, index,
                    EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.UsingStatements[index]));
            }

            if (Fragment.Parent is not null)
            {
                trapFile.parent(PowerShellContext, this, Fragment.Parent);
            }
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";script_block");
        }

        internal static ScriptBlockEntity Create(PowerShellContext cx, ScriptBlockAst fragment)
        {
            var init = (fragment, fragment);
            return ScriptBlockEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class ScriptBlockEntityFactory : CachedEntityFactory<(ScriptBlockAst, ScriptBlockAst), ScriptBlockEntity>
        {
            public static ScriptBlockEntityFactory Instance { get; } = new ScriptBlockEntityFactory();

            public override ScriptBlockEntity Create(PowerShellContext cx, (ScriptBlockAst, ScriptBlockAst) init) =>
                new ScriptBlockEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}