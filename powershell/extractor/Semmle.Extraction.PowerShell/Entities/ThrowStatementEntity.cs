using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class ThrowStatementEntity : CachedEntity<(ThrowStatementAst, ThrowStatementAst)>
    {
        private ThrowStatementEntity(PowerShellContext cx, ThrowStatementAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public ThrowStatementAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.throw_statement(this, Fragment.IsRethrow);
            trapFile.throw_statement_location(this, TrapSuitableLocation);
            if (Fragment.Pipeline is not null)
            {
                trapFile.throw_statement_pipeline(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Pipeline));
            }
            trapFile.parent(PowerShellContext, this, Fragment.Parent);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";throw_statement");
        }

        internal static ThrowStatementEntity Create(PowerShellContext cx, ThrowStatementAst fragment)
        {
            var init = (fragment, fragment);
            return ThrowStatementEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class ThrowStatementEntityFactory : CachedEntityFactory<(ThrowStatementAst, ThrowStatementAst), ThrowStatementEntity>
        {
            public static ThrowStatementEntityFactory Instance { get; } = new ThrowStatementEntityFactory();

            public override ThrowStatementEntity Create(PowerShellContext cx, (ThrowStatementAst, ThrowStatementAst) init) =>
                new ThrowStatementEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}