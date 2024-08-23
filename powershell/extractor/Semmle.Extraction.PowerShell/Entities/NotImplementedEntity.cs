using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class NotImplementedEntity : CachedEntity<(Ast, Type)>
    {
        private NotImplementedEntity(PowerShellContext cx, Ast fragment, Type type)
            : base(cx, (fragment, type))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public Ast Fragment => Symbol.Item1;
        public Type type => Symbol.Item2;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.not_implemented(this, type.FullName ?? type.Name);
            trapFile.not_implemented_location(this, TrapSuitableLocation);
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";not_implemented");
        }

        internal static NotImplementedEntity Create(PowerShellContext cx, Ast fragment, Type type)
        {
            var init = (fragment, type);
            return NotImplementedEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class NotImplementedEntityFactory : CachedEntityFactory<(Ast, Type), NotImplementedEntity>
        {
            public static NotImplementedEntityFactory Instance { get; } = new NotImplementedEntityFactory();

            public override NotImplementedEntity Create(PowerShellContext cx, (Ast, Type) init) =>
                new NotImplementedEntity(cx, init.Item1, init.Item2);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}
