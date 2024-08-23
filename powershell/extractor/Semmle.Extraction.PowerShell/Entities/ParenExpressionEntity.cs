using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class ParenExpressionEntity : CachedEntity<(ParenExpressionAst, ParenExpressionAst)>
    {
        private ParenExpressionEntity(PowerShellContext cx, ParenExpressionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public ParenExpressionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.paren_expression(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Pipeline));
            trapFile.paren_expression_location(this, TrapSuitableLocation);
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";paren_expression");
        }

        internal static ParenExpressionEntity Create(PowerShellContext cx, ParenExpressionAst fragment)
        {
            var init = (fragment, fragment);
            return ParenExpressionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class ParenExpressionEntityFactory : CachedEntityFactory<(ParenExpressionAst, ParenExpressionAst), ParenExpressionEntity>
        {
            public static ParenExpressionEntityFactory Instance { get; } = new ParenExpressionEntityFactory();

            public override ParenExpressionEntity Create(PowerShellContext cx, (ParenExpressionAst, ParenExpressionAst) init) =>
                new ParenExpressionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}