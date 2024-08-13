using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class ConfigurationDefinitionEntity : CachedEntity<(ConfigurationDefinitionAst, ConfigurationDefinitionAst)>
    {
        private ConfigurationDefinitionEntity(PowerShellContext cx, ConfigurationDefinitionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public ConfigurationDefinitionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.configuration_definition(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Body), Fragment.ConfigurationType, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.InstanceName));
            trapFile.configuration_definition_location(this, TrapSuitableLocation); 
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";configuration_definition");
        }

        internal static ConfigurationDefinitionEntity Create(PowerShellContext cx, ConfigurationDefinitionAst fragment)
        {
            var init = (fragment, fragment);
            return ConfigurationDefinitionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class ConfigurationDefinitionEntityFactory : CachedEntityFactory<(ConfigurationDefinitionAst, ConfigurationDefinitionAst), ConfigurationDefinitionEntity>
        {
            public static ConfigurationDefinitionEntityFactory Instance { get; } = new ConfigurationDefinitionEntityFactory();

            public override ConfigurationDefinitionEntity Create(PowerShellContext cx, (ConfigurationDefinitionAst, ConfigurationDefinitionAst) init) =>
                new ConfigurationDefinitionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}