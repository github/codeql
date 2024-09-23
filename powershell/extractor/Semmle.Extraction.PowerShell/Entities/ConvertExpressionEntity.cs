using System;
using System.IO;
using System.Management.Automation.Language;
using System.Reflection;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class ConvertExpressionEntity : CachedEntity<(ConvertExpressionAst, ConvertExpressionAst)>
    {
        private ConvertExpressionEntity(PowerShellContext cx, ConvertExpressionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public ConvertExpressionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            var attribute = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Attribute);
            var child = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Child);
            var type = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Type);
            trapFile.convert_expression(this, attribute, child, type, Fragment.StaticType.Name);
            trapFile.convert_expression_location(this, TrapSuitableLocation);
            trapFile.parent(PowerShellContext, this, Fragment.Parent);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";convert_expression");
        }

        internal static ConvertExpressionEntity Create(PowerShellContext cx, ConvertExpressionAst fragment)
        {
            var init = (fragment, fragment);
            return ConvertExpressionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class ConvertExpressionEntityFactory : CachedEntityFactory<(ConvertExpressionAst, ConvertExpressionAst), ConvertExpressionEntity>
        {
            public static ConvertExpressionEntityFactory Instance { get; } = new ConvertExpressionEntityFactory();

            public override ConvertExpressionEntity Create(PowerShellContext cx, (ConvertExpressionAst, ConvertExpressionAst) init) =>
                new ConvertExpressionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}