using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class UsingExpressionEntity : CachedEntity<(UsingExpressionAst, UsingExpressionAst)>
    {
        private UsingExpressionEntity(PowerShellContext cx, UsingExpressionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public UsingExpressionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.using_expression(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.SubExpression));
            trapFile.using_expression_location(this, TrapSuitableLocation);
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";using_expression");
        }

        internal static UsingExpressionEntity Create(PowerShellContext cx, UsingExpressionAst fragment)
        {
            var init = (fragment, fragment);
            return UsingExpressionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class UsingExpressionEntityFactory : CachedEntityFactory<(UsingExpressionAst, UsingExpressionAst), UsingExpressionEntity>
        {
            public static UsingExpressionEntityFactory Instance { get; } = new UsingExpressionEntityFactory();

            public override UsingExpressionEntity Create(PowerShellContext cx, (UsingExpressionAst, UsingExpressionAst) init) =>
                new UsingExpressionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}