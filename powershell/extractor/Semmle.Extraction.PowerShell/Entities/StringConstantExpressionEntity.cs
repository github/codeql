using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class StringConstantExpressionEntity : CachedEntity<(StringConstantExpressionAst, StringConstantExpressionAst)>
    {
        private StringConstantExpressionEntity(PowerShellContext cx, StringConstantExpressionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public StringConstantExpressionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.string_constant_expression(this, StringLiteralEntity.Create(PowerShellContext, ReportingLocation, Fragment.Value));
            trapFile.string_constant_expression_location(this, TrapSuitableLocation);
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";string_constant_expression");
        }

        internal static StringConstantExpressionEntity Create(PowerShellContext cx, StringConstantExpressionAst fragment)
        {
            var init = (fragment, fragment);
            return StringConstantExpressionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class StringConstantExpressionEntityFactory : CachedEntityFactory<(StringConstantExpressionAst, StringConstantExpressionAst), StringConstantExpressionEntity>
        {
            public static StringConstantExpressionEntityFactory Instance { get; } = new StringConstantExpressionEntityFactory();

            public override StringConstantExpressionEntity Create(PowerShellContext cx, (StringConstantExpressionAst, StringConstantExpressionAst) init) =>
                new StringConstantExpressionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}