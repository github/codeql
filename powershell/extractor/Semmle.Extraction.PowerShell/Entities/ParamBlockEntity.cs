using System;
using System.IO;
using System.Linq;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class ParamBlockEntity : CachedEntity<(ParamBlockAst, ParamBlockAst)>
    {
        private ParamBlockEntity(PowerShellContext cx, ParamBlockAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public ParamBlockAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.param_block(this, Fragment.Attributes.Count, Fragment.Parameters.Count);
            trapFile.param_block_location(this, TrapSuitableLocation);
            for (int i = 0; i < Fragment.Attributes.Count; i++)
            {
                trapFile.param_block_attribute(this, i, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Attributes[i]));
            }

            for (int i = 0; i < Fragment.Parameters.Count; i++)
            {
                trapFile.param_block_parameter(this, i,
                    EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parameters[i]));
            }
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";param_block");
        }

        internal static ParamBlockEntity Create(PowerShellContext cx, ParamBlockAst fragment)
        {
            var init = (fragment, fragment);
            return ParamBlockEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class ParamBlockEntityFactory : CachedEntityFactory<(ParamBlockAst, ParamBlockAst), ParamBlockEntity>
        {
            public static ParamBlockEntityFactory Instance { get; } = new ParamBlockEntityFactory();

            public override ParamBlockEntity Create(PowerShellContext cx, (ParamBlockAst, ParamBlockAst) init) =>
                new ParamBlockEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}