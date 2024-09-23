using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class AttributedExpressionEntity : CachedEntity<(AttributedExpressionAst, AttributedExpressionAst)>
    {
        private AttributedExpressionEntity(PowerShellContext cx, AttributedExpressionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public AttributedExpressionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.attributed_expression(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Attribute), 
                EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Child));
            trapFile.attributed_expression_location(this, TrapSuitableLocation);
            trapFile.parent(PowerShellContext, this, Fragment.Parent);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";attributed_expression");
        }

        internal static AttributedExpressionEntity Create(PowerShellContext cx, AttributedExpressionAst fragment)
        {
            var init = (fragment, fragment);
            return AttributedExpressionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class AttributedExpressionEntityFactory : CachedEntityFactory<(AttributedExpressionAst, AttributedExpressionAst), AttributedExpressionEntity>
        {
            public static AttributedExpressionEntityFactory Instance { get; } = new AttributedExpressionEntityFactory();

            public override AttributedExpressionEntity Create(PowerShellContext cx, (AttributedExpressionAst, AttributedExpressionAst) init) =>
                new AttributedExpressionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}