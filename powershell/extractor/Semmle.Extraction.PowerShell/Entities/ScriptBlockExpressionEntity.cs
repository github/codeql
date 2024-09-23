using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class ScriptBlockExpressionEntity : CachedEntity<(ScriptBlockExpressionAst, ScriptBlockExpressionAst)>
    {
        private ScriptBlockExpressionEntity(PowerShellContext cx, ScriptBlockExpressionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public ScriptBlockExpressionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.script_block_expression(this, ScriptBlockEntity.Create(PowerShellContext, Fragment.ScriptBlock));
            trapFile.script_block_expression_location(this, TrapSuitableLocation);
            trapFile.parent(PowerShellContext, this, Fragment.Parent);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";script_block_expression");
        }

        internal static ScriptBlockExpressionEntity Create(PowerShellContext cx, ScriptBlockExpressionAst fragment)
        {
            var init = (fragment, fragment);
            return ScriptBlockExpressionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class ScriptBlockExpressionEntityFactory : CachedEntityFactory<(ScriptBlockExpressionAst, ScriptBlockExpressionAst), ScriptBlockExpressionEntity>
        {
            public static ScriptBlockExpressionEntityFactory Instance { get; } = new ScriptBlockExpressionEntityFactory();

            public override ScriptBlockExpressionEntity Create(PowerShellContext cx, (ScriptBlockExpressionAst, ScriptBlockExpressionAst) init) =>
                new ScriptBlockExpressionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}