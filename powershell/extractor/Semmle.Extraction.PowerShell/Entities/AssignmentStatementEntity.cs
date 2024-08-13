using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class AssignmentStatementEntity : CachedEntity<(AssignmentStatementAst, AssignmentStatementAst)>
    {
        private AssignmentStatementEntity(PowerShellContext cx, AssignmentStatementAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public AssignmentStatementAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            var left = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Left);
            var right = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Right);
            trapFile.assignment_statement(this, Fragment.Operator, left, right);
            trapFile.assignment_statement_location(this, TrapSuitableLocation);
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";assignment_statement");
        }

        internal static AssignmentStatementEntity Create(PowerShellContext cx, AssignmentStatementAst fragment)
        {
            var init = (fragment, fragment);
            return AssignmentStatementEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class AssignmentStatementEntityFactory : CachedEntityFactory<(AssignmentStatementAst, AssignmentStatementAst), AssignmentStatementEntity>
        {
            public static AssignmentStatementEntityFactory Instance { get; } = new AssignmentStatementEntityFactory();

            public override AssignmentStatementEntity Create(PowerShellContext cx, (AssignmentStatementAst, AssignmentStatementAst) init) =>
                new AssignmentStatementEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}