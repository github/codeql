using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class HashtableEntity : CachedEntity<(HashtableAst, HashtableAst)>
    {
        private HashtableEntity(PowerShellContext cx, HashtableAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public HashtableAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.hash_table(this);
            trapFile.hash_table_location(this, TrapSuitableLocation);
            int index = 0;
            foreach(var pair in Fragment.KeyValuePairs)
            {
                trapFile.hash_table_key_value_pairs(this, index++, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, pair.Item1), EntityConstructor.ConstructAppropriateEntity(PowerShellContext, pair.Item2));
            }
            trapFile.parent(PowerShellContext, this, Fragment.Parent);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";hash_table");
        }

        internal static HashtableEntity Create(PowerShellContext cx, HashtableAst fragment)
        {
            var init = (fragment, fragment);
            return HashtableEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class HashtableEntityFactory : CachedEntityFactory<(HashtableAst, HashtableAst), HashtableEntity>
        {
            public static HashtableEntityFactory Instance { get; } = new HashtableEntityFactory();

            public override HashtableEntity Create(PowerShellContext cx, (HashtableAst, HashtableAst) init) =>
                new HashtableEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}