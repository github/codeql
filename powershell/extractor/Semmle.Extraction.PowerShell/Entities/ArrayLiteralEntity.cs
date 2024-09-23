using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class ArrayLiteralEntity : CachedEntity<(ArrayLiteralAst, ArrayLiteralAst)>
    {
        private ArrayLiteralEntity(PowerShellContext cx, ArrayLiteralAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public ArrayLiteralAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.array_literal(this);
            trapFile.array_literal_location(this, TrapSuitableLocation);

            for (int index = 0; index < Fragment.Elements.Count; index++)
            {
                var entity = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Elements[index]);
                trapFile.array_literal_element(this, index, entity);
            }
            trapFile.parent(PowerShellContext, this, Fragment.Parent);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";array_literal");
        }

        internal static ArrayLiteralEntity Create(PowerShellContext cx, ArrayLiteralAst fragment)
        {
            var init = (fragment, fragment);
            return ArrayLiteralEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class ArrayLiteralEntityFactory : CachedEntityFactory<(ArrayLiteralAst, ArrayLiteralAst), ArrayLiteralEntity>
        {
            public static ArrayLiteralEntityFactory Instance { get; } = new ArrayLiteralEntityFactory();

            public override ArrayLiteralEntity Create(PowerShellContext cx, (ArrayLiteralAst, ArrayLiteralAst) init) =>
                new ArrayLiteralEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}