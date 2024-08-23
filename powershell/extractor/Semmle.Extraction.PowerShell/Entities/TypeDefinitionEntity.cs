using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class TypeDefinitionEntity : CachedEntity<(TypeDefinitionAst, TypeDefinitionAst)>
    {
        
        private TypeDefinitionEntity(PowerShellContext cx, TypeDefinitionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public TypeDefinitionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.type_definition(this, Fragment.Name, Fragment.TypeAttributes, Fragment.IsClass, Fragment.IsEnum, Fragment.IsInterface);
            trapFile.type_definition_location(this, TrapSuitableLocation);
            for(int index = 0; index < Fragment.Members.Count; index++)
            {
                trapFile.type_definition_members(this, index, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Members[index]));
            }
            for(int index = 0; index < Fragment.Attributes.Count; index++)
            {
                trapFile.type_definition_attributes(this, index, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Attributes[index]));
            }
            for(int index = 0; index < Fragment.BaseTypes.Count; index++)
            {
                trapFile.type_definition_base_type(this, index, TypeConstraintEntity.Create(PowerShellContext, Fragment.BaseTypes[index]));
            }
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";type_definition");
        }

        internal static TypeDefinitionEntity Create(PowerShellContext cx, TypeDefinitionAst fragment)
        {
            var init = (fragment, fragment);
            return TypeDefinitionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class TypeDefinitionEntityFactory : CachedEntityFactory<(TypeDefinitionAst, TypeDefinitionAst), TypeDefinitionEntity>
        {
            public static TypeDefinitionEntityFactory Instance { get; } = new TypeDefinitionEntityFactory();

            public override TypeDefinitionEntity Create(PowerShellContext cx, (TypeDefinitionAst, TypeDefinitionAst) init) =>
                new TypeDefinitionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}