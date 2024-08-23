using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class DynamicKeywordStatementEntity : CachedEntity<(DynamicKeywordStatementAst, DynamicKeywordStatementAst)>
    {
        private DynamicKeywordStatementEntity(PowerShellContext cx, DynamicKeywordStatementAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public DynamicKeywordStatementAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.dynamic_keyword_statement(this);
            trapFile.dynamic_keyword_statement_location(this, TrapSuitableLocation);
            for(int index = 0; index < Fragment.CommandElements.Count; index++)
            {
                trapFile.dynamic_keyword_statement_command_elements(this, index, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.CommandElements[index]));
            }
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";dynamic_keyword_statement");
        }

        internal static DynamicKeywordStatementEntity Create(PowerShellContext cx, DynamicKeywordStatementAst fragment)
        {
            var init = (fragment, fragment);
            return DynamicKeywordStatementEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class DynamicKeywordStatementEntityFactory : CachedEntityFactory<(DynamicKeywordStatementAst, DynamicKeywordStatementAst), DynamicKeywordStatementEntity>
        {
            public static DynamicKeywordStatementEntityFactory Instance { get; } = new DynamicKeywordStatementEntityFactory();

            public override DynamicKeywordStatementEntity Create(PowerShellContext cx, (DynamicKeywordStatementAst, DynamicKeywordStatementAst) init) =>
                new DynamicKeywordStatementEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}