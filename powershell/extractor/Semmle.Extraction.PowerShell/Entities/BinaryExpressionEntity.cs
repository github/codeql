using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class BinaryExpressionEntity : CachedEntity<(BinaryExpressionAst, BinaryExpressionAst)>
    {
        private BinaryExpressionEntity(PowerShellContext cx, BinaryExpressionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public BinaryExpressionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            var left = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Left);
            var right = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Right);
            trapFile.binary_expression(this, Fragment.Operator, left, right);
            trapFile.binary_expression_location(this, TrapSuitableLocation);
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";binary_expression");
        }

        internal static BinaryExpressionEntity Create(PowerShellContext cx, BinaryExpressionAst fragment)
        {
            var init = (fragment, fragment);
            return BinaryExpressionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class BinaryExpressionEntityFactory : CachedEntityFactory<(BinaryExpressionAst, BinaryExpressionAst), BinaryExpressionEntity>
        {
            public static BinaryExpressionEntityFactory Instance { get; } = new BinaryExpressionEntityFactory();

            public override BinaryExpressionEntity Create(PowerShellContext cx, (BinaryExpressionAst, BinaryExpressionAst) init) =>
                new BinaryExpressionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}