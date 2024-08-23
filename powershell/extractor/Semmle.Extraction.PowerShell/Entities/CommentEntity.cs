using Semmle.Extraction.Entities;
using System.IO;
using System.Linq;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal enum CommentType
    {
        SingleLine,
        MultiLineContinuation
    }
    internal class CommentEntity : CachedEntity<(Token, Token)>
    {
        private CommentEntity(PowerShellContext cx, Token token)
            : base(cx, (token, token))
        {
        }
        private Location? location;


        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.ExtentToAnalysisLocation(Fragment.Extent);
        public Token Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            location = TrapSuitableLocation;

            var literal = StringLiteralEntity.Create(PowerShellContext, ReportingLocation, Fragment.Text);
            trapFile.comment_entity(this, literal);
            trapFile.comment_entity_location(this, location);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";comment");
        }

        internal static CommentEntity Create(PowerShellContext cx, Token init)
        {
            var init2 = (init, init);
            return CommentLineFactory.Instance.CreateEntity(cx, init2, init2);
        }

        private class CommentLineFactory : CachedEntityFactory<(Token, Token), CommentEntity>
        {
            public static CommentLineFactory Instance { get; } = new CommentLineFactory();

            public override CommentEntity Create(PowerShellContext cx, (Token, Token) init) =>
                new CommentEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}
