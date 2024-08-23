using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class CatchClauseEntity : CachedEntity<(CatchClauseAst, CatchClauseAst)>
    {
        private CatchClauseEntity(PowerShellContext cx, CatchClauseAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public CatchClauseAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.catch_clause(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Body), Fragment.IsCatchAll);
            for(int index = 0; index < Fragment.CatchTypes.Count; index++)
            {
                trapFile.catch_clause_catch_type(this, index, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.CatchTypes[index]));
            }
            trapFile.catch_clause_location(this, TrapSuitableLocation);
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";catch_clause");
        }

        internal static CatchClauseEntity Create(PowerShellContext cx, CatchClauseAst fragment)
        {
            var init = (fragment, fragment);
            return CatchClauseEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class CatchClauseEntityFactory : CachedEntityFactory<(CatchClauseAst, CatchClauseAst), CatchClauseEntity>
        {
            public static CatchClauseEntityFactory Instance { get; } = new CatchClauseEntityFactory();

            public override CatchClauseEntity Create(PowerShellContext cx, (CatchClauseAst, CatchClauseAst) init) =>
                new CatchClauseEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}