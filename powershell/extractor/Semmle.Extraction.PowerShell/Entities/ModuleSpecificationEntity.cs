using System;
using System.IO;
using System.Management.Automation.Language;
using Microsoft.PowerShell.Commands;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class ModuleSpecificationEntity : CachedEntity<(ModuleSpecification, Microsoft.CodeAnalysis.Location)>
    {
        private ModuleSpecificationEntity(PowerShellContext cx, ModuleSpecification fragment, Microsoft.CodeAnalysis.Location location)
            : base(cx, (fragment, location))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => Symbol.Item2;
        public ModuleSpecification Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.module_specification(this, Fragment.Name, Fragment.Guid?.ToString() ?? string.Empty, Fragment.MaximumVersion ?? string.Empty, Fragment.RequiredVersion?.ToString() ?? string.Empty, Fragment.Version?.ToString() ?? string.Empty);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";module_specification");
        }

        internal static ModuleSpecificationEntity Create(PowerShellContext cx, ModuleSpecification fragment, Microsoft.CodeAnalysis.Location location)
        {
            var init = (fragment, location);
            return ModuleSpecificationEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class ModuleSpecificationEntityFactory : CachedEntityFactory<(ModuleSpecification, Microsoft.CodeAnalysis.Location), ModuleSpecificationEntity>
        {
            public static ModuleSpecificationEntityFactory Instance { get; } = new ModuleSpecificationEntityFactory();

            public override ModuleSpecificationEntity Create(PowerShellContext cx, (ModuleSpecification, Microsoft.CodeAnalysis.Location) init) =>
                new ModuleSpecificationEntity(cx, init.Item1, init.Item2);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}