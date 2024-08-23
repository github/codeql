using System;
using System.IO;
using System.Management.Automation.Language;
using System.Reflection;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class SubExpressionEntity : CachedEntity<(SubExpressionAst, SubExpressionAst)>
    {
        private SubExpressionEntity(PowerShellContext cx, SubExpressionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public SubExpressionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            var subExpression = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.SubExpression);
            trapFile.sub_expression(this, subExpression);
            trapFile.sub_expression_location(this, TrapSuitableLocation);
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";sub_expression");
        }

        internal static SubExpressionEntity Create(PowerShellContext cx, SubExpressionAst fragment)
        {
            var init = (fragment, fragment);
            return SubExpressionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class SubExpressionEntityFactory : CachedEntityFactory<(SubExpressionAst, SubExpressionAst), SubExpressionEntity>
        {
            public static SubExpressionEntityFactory Instance { get; } = new SubExpressionEntityFactory();

            public override SubExpressionEntity Create(PowerShellContext cx, (SubExpressionAst, SubExpressionAst) init) =>
                new SubExpressionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}