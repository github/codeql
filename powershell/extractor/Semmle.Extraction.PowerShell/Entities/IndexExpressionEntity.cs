using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class IndexExpressionEntity : CachedEntity<(IndexExpressionAst, IndexExpressionAst)>
    {
        private IndexExpressionEntity(PowerShellContext cx, IndexExpressionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public IndexExpressionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            var index = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Index);
            var target = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Target);
            trapFile.index_expression(this, index, target, Fragment.NullConditional);
            trapFile.index_expression_location(this, TrapSuitableLocation);
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";index_expression");
        }

        internal static IndexExpressionEntity Create(PowerShellContext cx, IndexExpressionAst fragment)
        {
            var init = (fragment, fragment);
            return IndexExpressionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class IndexExpressionEntityFactory : CachedEntityFactory<(IndexExpressionAst, IndexExpressionAst), IndexExpressionEntity>
        {
            public static IndexExpressionEntityFactory Instance { get; } = new IndexExpressionEntityFactory();

            public override IndexExpressionEntity Create(PowerShellContext cx, (IndexExpressionAst, IndexExpressionAst) init) =>
                new IndexExpressionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}