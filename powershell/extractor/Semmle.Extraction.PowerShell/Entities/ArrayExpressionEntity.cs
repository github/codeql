using System;
using System.IO;
using System.Management.Automation.Language;
using System.Reflection;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class ArrayExpressionEntity : CachedEntity<(ArrayExpressionAst, ArrayExpressionAst)>
    {
        private ArrayExpressionEntity(PowerShellContext cx, ArrayExpressionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public ArrayExpressionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            var subExpression = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.SubExpression);
            trapFile.array_expression(this, subExpression);
            trapFile.array_expression_location(this, TrapSuitableLocation);
            trapFile.parent(PowerShellContext, this, Fragment.Parent);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";array_expression");
        }

        internal static ArrayExpressionEntity Create(PowerShellContext cx, ArrayExpressionAst fragment)
        {
            var init = (fragment, fragment);
            return ArrayExpressionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class ArrayExpressionEntityFactory : CachedEntityFactory<(ArrayExpressionAst, ArrayExpressionAst), ArrayExpressionEntity>
        {
            public static ArrayExpressionEntityFactory Instance { get; } = new ArrayExpressionEntityFactory();

            public override ArrayExpressionEntity Create(PowerShellContext cx, (ArrayExpressionAst, ArrayExpressionAst) init) =>
                new ArrayExpressionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}