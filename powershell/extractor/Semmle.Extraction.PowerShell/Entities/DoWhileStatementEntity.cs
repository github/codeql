using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class DoWhileStatementEntity : CachedEntity<(DoWhileStatementAst, DoWhileStatementAst)>
    {
        private DoWhileStatementEntity(PowerShellContext cx, DoWhileStatementAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public DoWhileStatementAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            // Condition can be null only if this is a For statement so For Statement must be parsed first
            trapFile.do_while_statement(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Body));
            trapFile.do_while_statement_location(this, TrapSuitableLocation);
            if (Fragment.Label is not null)
            {
                trapFile.label(this, Fragment.Label);
            }

            if (Fragment.Condition is not null)
            {
                trapFile.do_while_statement_condition(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Condition));
            }
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";do_while_statement");
        }

        internal static DoWhileStatementEntity Create(PowerShellContext cx, DoWhileStatementAst fragment)
        {
            var init = (fragment, fragment);
            return DoWhileStatementEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class DoWhileStatementEntityFactory : CachedEntityFactory<(DoWhileStatementAst, DoWhileStatementAst), DoWhileStatementEntity>
        {
            public static DoWhileStatementEntityFactory Instance { get; } = new DoWhileStatementEntityFactory();

            public override DoWhileStatementEntity Create(PowerShellContext cx, (DoWhileStatementAst, DoWhileStatementAst) init) =>
                new DoWhileStatementEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}