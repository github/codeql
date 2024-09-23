using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class NamedBlockEntity : CachedEntity<(NamedBlockAst, NamedBlockAst)>
    {
        private NamedBlockEntity(PowerShellContext cx, NamedBlockAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public NamedBlockAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.named_block(this, Fragment.Statements.Count, Fragment.Traps?.Count ?? 0);
            trapFile.named_block_location(this, TrapSuitableLocation);
            for(int index = 0; index < Fragment.Statements?.Count; index++)
            {
                trapFile.named_block_statement(this, index, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Statements[index]));
            }
            for(int index = 0; index < Fragment.Traps?.Count; index++)
            {
                trapFile.named_block_trap(this, index, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Traps[index]));
            }
            trapFile.parent(PowerShellContext, this, Fragment.Parent);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";named_block");
        }

        internal static NamedBlockEntity Create(PowerShellContext cx, NamedBlockAst fragment)
        {
            var init = (fragment, fragment);
            return NamedBlockEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class NamedBlockEntityFactory : CachedEntityFactory<(NamedBlockAst, NamedBlockAst), NamedBlockEntity>
        {
            public static NamedBlockEntityFactory Instance { get; } = new NamedBlockEntityFactory();

            public override NamedBlockEntity Create(PowerShellContext cx, (NamedBlockAst, NamedBlockAst) init) =>
                new NamedBlockEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}