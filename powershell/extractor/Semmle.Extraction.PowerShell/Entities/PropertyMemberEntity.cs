using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class PropertyMemberEntity : CachedEntity<(PropertyMemberAst, PropertyMemberAst)>
    {
        private PropertyMemberEntity(PowerShellContext cx, PropertyMemberAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public PropertyMemberAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.property_member(this, Fragment.IsHidden, Fragment.IsPrivate, Fragment.IsPublic, Fragment.IsStatic, Fragment.Name, Fragment.PropertyAttributes);
            trapFile.property_member_location(this, TrapSuitableLocation);
            for(int index = 0; index < Fragment.Attributes.Count; index++)
            {
                trapFile.property_member_attribute(this, index, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Attributes[index]));
            }
            if (Fragment.PropertyType is not null)
            {
                trapFile.property_member_property_type(this, TypeConstraintEntity.Create(PowerShellContext, Fragment.PropertyType));
            }
            if (Fragment.InitialValue is not null)
            {
                trapFile.property_member_initial_value(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.InitialValue));
            }
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";property_member");
        }

        internal static PropertyMemberEntity Create(PowerShellContext cx, PropertyMemberAst fragment)
        {
            var init = (fragment, fragment);
            return PropertyMemberEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class PropertyMemberEntityFactory : CachedEntityFactory<(PropertyMemberAst, PropertyMemberAst), PropertyMemberEntity>
        {
            public static PropertyMemberEntityFactory Instance { get; } = new PropertyMemberEntityFactory();

            public override PropertyMemberEntity Create(PowerShellContext cx, (PropertyMemberAst, PropertyMemberAst) init) =>
                new PropertyMemberEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}