using System;
using System.IO;
using System.Linq;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class AttributeEntity : CachedEntity<(AttributeAst, AttributeAst)>
    {
        private AttributeEntity(PowerShellContext cx, AttributeAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public AttributeAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.attribute(this, Fragment.TypeName.Name, Fragment.NamedArguments.Count, Fragment.PositionalArguments.Count);
            trapFile.attribute_location(this, TrapSuitableLocation);
            for (int i = 0; i < Fragment.NamedArguments.Count; i++)
            {
                trapFile.attribute_named_argument(this, i,
                    EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.NamedArguments[i]));
            }
            for (int i = 0; i < Fragment.PositionalArguments.Count; i++)
            {
                trapFile.attribute_positional_argument(this, i,
                    EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.PositionalArguments[i]));
            }
            trapFile.parent(PowerShellContext, this, Fragment.Parent);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";attribute");
        }

        internal static AttributeEntity Create(PowerShellContext cx, AttributeAst fragment)
        {
            var init = (fragment, fragment);
            return AttributeEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class AttributeEntityFactory : CachedEntityFactory<(AttributeAst, AttributeAst), AttributeEntity>
        {
            public static AttributeEntityFactory Instance { get; } = new AttributeEntityFactory();

            public override AttributeEntity Create(PowerShellContext cx, (AttributeAst, AttributeAst) init) =>
                new AttributeEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}