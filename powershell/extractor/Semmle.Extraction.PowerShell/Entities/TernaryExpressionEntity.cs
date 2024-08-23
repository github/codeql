using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class TernaryExpressionEntity : CachedEntity<(TernaryExpressionAst, TernaryExpressionAst)>
    {
        
        private TernaryExpressionEntity(PowerShellContext cx, TernaryExpressionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public TernaryExpressionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            var condition = EntityConstructor.ConstructAppropriateEntity(PowerShellContext,Fragment.Condition);
            var ifFalse = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.IfFalse);
            var ifTrue = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.IfTrue);

            trapFile.ternary_expression(this, condition, ifFalse, ifTrue);
            trapFile.ternary_expression_location(this, TrapSuitableLocation);
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";ternary_expression");
        }

        internal static TernaryExpressionEntity Create(PowerShellContext cx, TernaryExpressionAst fragment)
        {
            var init = (fragment, fragment);
            return TernaryExpressionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class TernaryExpressionEntityFactory : CachedEntityFactory<(TernaryExpressionAst, TernaryExpressionAst), TernaryExpressionEntity>
        {
            public static TernaryExpressionEntityFactory Instance { get; } = new TernaryExpressionEntityFactory();

            public override TernaryExpressionEntity Create(PowerShellContext cx, (TernaryExpressionAst, TernaryExpressionAst) init) =>
                new TernaryExpressionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}