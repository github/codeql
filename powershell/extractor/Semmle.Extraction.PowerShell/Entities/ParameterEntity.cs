using System;
using System.IO;
using System.Management.Automation.Language;
using System.Reflection.Metadata;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class ParameterEntity : CachedEntity<(ParameterAst, ParameterAst)>
    {
        private ParameterEntity(PowerShellContext cx, ParameterAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public ParameterAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.parameter(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Name), Fragment.StaticType.Name, Fragment.Attributes.Count);
            trapFile.parameter_location(this, TrapSuitableLocation);
            for (int i = 0; i < Fragment.Attributes.Count; i++)
            {
                trapFile.parameter_attribute(this, i,
                    EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Attributes[i]));
            }

            if (Fragment.DefaultValue is not null)
            {
                var entity = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.DefaultValue);
                trapFile.parameter_default_value(this, entity);
            }
            trapFile.parent(PowerShellContext, this, Fragment.Parent);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";parameter");
        }

        internal static ParameterEntity Create(PowerShellContext cx, ParameterAst fragment)
        {
            var init = (fragment, fragment);
            return ParameterEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class ParameterEntityFactory : CachedEntityFactory<(ParameterAst, ParameterAst), ParameterEntity>
        {
            public static ParameterEntityFactory Instance { get; } = new ParameterEntityFactory();

            public override ParameterEntity Create(PowerShellContext cx, (ParameterAst, ParameterAst) init) =>
                new ParameterEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}