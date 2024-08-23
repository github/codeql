using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class FileRedirectionEntity : CachedEntity<(FileRedirectionAst, FileRedirectionAst)>
    {
        private FileRedirectionEntity(PowerShellContext cx, FileRedirectionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public FileRedirectionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.file_redirection(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Location),
                Fragment.Append, Fragment.FromStream);
            trapFile.file_redirection_location(this, TrapSuitableLocation);
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";file_redirection");
        }

        internal static FileRedirectionEntity Create(PowerShellContext cx, FileRedirectionAst fragment)
        {
            var init = (fragment, fragment);
            return FileRedirectionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class FileRedirectionEntityFactory : CachedEntityFactory<(FileRedirectionAst, FileRedirectionAst), FileRedirectionEntity>
        {
            public static FileRedirectionEntityFactory Instance { get; } = new FileRedirectionEntityFactory();

            public override FileRedirectionEntity Create(PowerShellContext cx, (FileRedirectionAst, FileRedirectionAst) init) =>
                new FileRedirectionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}