using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class NamedAttributeArgumentEntity : CachedEntity<(NamedAttributeArgumentAst, NamedAttributeArgumentAst)>
    {
        private NamedAttributeArgumentEntity(PowerShellContext cx, NamedAttributeArgumentAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public NamedAttributeArgumentAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.named_attribute_argument(this, Fragment.ArgumentName,
                EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Argument));
            trapFile.named_attribute_argument_location(this, TrapSuitableLocation);
            trapFile.parent(PowerShellContext, this, Fragment.Parent);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";named_attribute_argument");
        }

        internal static NamedAttributeArgumentEntity Create(PowerShellContext cx, NamedAttributeArgumentAst fragment)
        {
            var init = (fragment, fragment);
            return NamedAttributeArgumentEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class NamedAttributeArgumentEntityFactory : CachedEntityFactory<(NamedAttributeArgumentAst, NamedAttributeArgumentAst), NamedAttributeArgumentEntity>
        {
            public static NamedAttributeArgumentEntityFactory Instance { get; } = new NamedAttributeArgumentEntityFactory();

            public override NamedAttributeArgumentEntity Create(PowerShellContext cx, (NamedAttributeArgumentAst, NamedAttributeArgumentAst) init) =>
                new NamedAttributeArgumentEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}