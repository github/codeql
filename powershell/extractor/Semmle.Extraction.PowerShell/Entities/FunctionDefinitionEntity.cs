using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class FunctionDefinitionEntity : CachedEntity<(FunctionDefinitionAst, FunctionDefinitionAst)>
    {
        private FunctionDefinitionEntity(PowerShellContext cx, FunctionDefinitionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public FunctionDefinitionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.function_definition(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Body), Fragment.Name, Fragment.IsFilter, Fragment.IsWorkflow);
            trapFile.function_definition_location(this, TrapSuitableLocation);
            for (int i = 0; i < Fragment.Parameters?.Count; i++)
            {
                trapFile.function_definition_parameter(this, i, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parameters[i]));
            }
            trapFile.parent(PowerShellContext, this, Fragment.Parent);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";function_definition");
        }

        internal static FunctionDefinitionEntity Create(PowerShellContext cx, FunctionDefinitionAst fragment)
        {
            var init = (fragment, fragment);
            return FunctionDefinitionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class FunctionDefinitionEntityFactory : CachedEntityFactory<(FunctionDefinitionAst, FunctionDefinitionAst), FunctionDefinitionEntity>
        {
            public static FunctionDefinitionEntityFactory Instance { get; } = new FunctionDefinitionEntityFactory();

            public override FunctionDefinitionEntity Create(PowerShellContext cx, (FunctionDefinitionAst, FunctionDefinitionAst) init) =>
                new FunctionDefinitionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}