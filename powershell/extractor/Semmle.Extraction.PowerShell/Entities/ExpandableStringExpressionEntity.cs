using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class ExpandableStringExpressionEntity : CachedEntity<(ExpandableStringExpressionAst, ExpandableStringExpressionAst)>
    {
        private ExpandableStringExpressionEntity(PowerShellContext cx, ExpandableStringExpressionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public ExpandableStringExpressionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            // todo: for expandable_string_expression, string_constant_expression, and constant_expression
            // implement support for when the value contains `n, since this is causing the line in .trap to be split
            
            trapFile.expandable_string_expression(this, StringLiteralEntity.Create(PowerShellContext, ReportingLocation, Fragment.Value), Fragment.StringConstantType, Fragment.NestedExpressions.Count);
            trapFile.expandable_string_expression_location(this, TrapSuitableLocation);
            for (int index = 0; index < Fragment.NestedExpressions.Count; index++)
            {
                trapFile.expandable_string_expression_nested_expression(this, index,
                    EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.NestedExpressions[index]));
            }
            trapFile.parent(PowerShellContext, this, Fragment.Parent);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";expandable_string_expression");
        }

        internal static ExpandableStringExpressionEntity Create(PowerShellContext cx, ExpandableStringExpressionAst fragment)
        {
            var init = (fragment, fragment);
            return ExpandableStringExpressionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class ExpandableStringExpressionEntityFactory : CachedEntityFactory<(ExpandableStringExpressionAst, ExpandableStringExpressionAst), ExpandableStringExpressionEntity>
        {
            public static ExpandableStringExpressionEntityFactory Instance { get; } = new ExpandableStringExpressionEntityFactory();

            public override ExpandableStringExpressionEntity Create(PowerShellContext cx, (ExpandableStringExpressionAst, ExpandableStringExpressionAst) init) =>
                new ExpandableStringExpressionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}