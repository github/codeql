using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class MergingRedirectionEntity : CachedEntity<(MergingRedirectionAst, MergingRedirectionAst)>
    {
        private MergingRedirectionEntity(PowerShellContext cx, MergingRedirectionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public MergingRedirectionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.merging_redirection(this, Fragment.FromStream, Fragment.ToStream);
            trapFile.merging_redirection_location(this, TrapSuitableLocation);
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";merging_redirection");
        }

        internal static MergingRedirectionEntity Create(PowerShellContext cx, MergingRedirectionAst fragment)
        {
            var init = (fragment, fragment);
            return MergingRedirectionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class MergingRedirectionEntityFactory : CachedEntityFactory<(MergingRedirectionAst, MergingRedirectionAst), MergingRedirectionEntity>
        {
            public static MergingRedirectionEntityFactory Instance { get; } = new MergingRedirectionEntityFactory();

            public override MergingRedirectionEntity Create(PowerShellContext cx, (MergingRedirectionAst, MergingRedirectionAst) init) =>
                new MergingRedirectionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}