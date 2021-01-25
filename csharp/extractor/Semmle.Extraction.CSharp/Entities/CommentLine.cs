using Semmle.Extraction.CommentProcessing;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Extraction.Entities;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class CommentLine : CachedEntity<(Microsoft.CodeAnalysis.Location, string)>, ICommentLine
    {
        private CommentLine(Context cx, Microsoft.CodeAnalysis.Location loc, CommentLineType type, string text, string raw)
            : base(cx, (loc, text))
        {
            Type = type;
            RawText = raw;
        }

        public Microsoft.CodeAnalysis.Location Location => symbol.Item1;
        public CommentLineType Type { get; private set; }

        public string Text { get { return symbol.Item2; } }
        public string RawText { get; private set; }

        private Extraction.Entities.Location location;

        public override void Populate(TextWriter trapFile)
        {
            location = Context.Create(Location);
            trapFile.commentline(this, Type == CommentLineType.MultilineContinuation ? CommentLineType.Multiline : Type, Text, RawText);
            trapFile.commentline_location(this, location);
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => location.symbol;

        public override bool NeedsPopulation => true;

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.WriteSubId(Context.Create(Location));
            trapFile.Write(";commentline");
        }

        internal static CommentLine Create(Context cx, Microsoft.CodeAnalysis.Location loc, CommentLineType type, string text, string raw)
        {
            var init = (loc, type, text, raw);
            return CommentLineFactory.Instance.CreateEntity(cx, init, init);
        }

        private class CommentLineFactory : ICachedEntityFactory<(Microsoft.CodeAnalysis.Location, CommentLineType, string, string), CommentLine>
        {
            public static CommentLineFactory Instance { get; } = new CommentLineFactory();

            public CommentLine Create(Context cx, (Microsoft.CodeAnalysis.Location, CommentLineType, string, string) init) =>
                new CommentLine(cx, init.Item1, init.Item2, init.Item3, init.Item4);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}
