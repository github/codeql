using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class UsingStatementEntity : CachedEntity<(UsingStatementAst, UsingStatementAst)>
    {
        private UsingStatementEntity(PowerShellContext cx, UsingStatementAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public UsingStatementAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.using_statement(this, Fragment.UsingStatementKind);
            trapFile.using_statement_location(this, TrapSuitableLocation);
            if(Fragment.Alias is not null)
            {
                trapFile.using_statement_alias(this, StringConstantExpressionEntity.Create(PowerShellContext, Fragment.Alias));
            }
            if (Fragment.Name is not null)
            {
                trapFile.using_statement_name(this, StringConstantExpressionEntity.Create(PowerShellContext, Fragment.Name));
            }
            if (Fragment.ModuleSpecification is not null)
            {
                trapFile.using_statement_module_specification(this, HashtableEntity.Create(PowerShellContext, Fragment.ModuleSpecification));
            }
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";using_statement");
        }

        internal static UsingStatementEntity Create(PowerShellContext cx, UsingStatementAst fragment)
        {
            var init = (fragment, fragment);
            return UsingStatementEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class UsingStatementEntityFactory : CachedEntityFactory<(UsingStatementAst, UsingStatementAst), UsingStatementEntity>
        {
            public static UsingStatementEntityFactory Instance { get; } = new UsingStatementEntityFactory();

            public override UsingStatementEntity Create(PowerShellContext cx, (UsingStatementAst, UsingStatementAst) init) =>
                new UsingStatementEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}